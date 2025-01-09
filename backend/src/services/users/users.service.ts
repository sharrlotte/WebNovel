import { Injectable } from '@nestjs/common';

import { Prisma, User } from '@prisma/client';
import NotFound from 'src/error/NotFound';
import { SessionDto } from 'src/services/auth/dto/session.dto';
import { DatabaseService } from 'src/services/database/database.service';
import {
  GetAllNovelQuery,
  sortMapping,
} from 'src/services/novel/dto/get-all-novel-query.dto';
import { AuthProvider } from 'src/types/auth';

type UserWithAuthoritiesAndRoles = Prisma.UserGetPayload<{}> & {
  roles: string[];
  authorities: string[];
};

@Injectable()
export class UsersService {
  constructor(private prisma: DatabaseService) {}

  async find(
    providerId: string,
    provider: AuthProvider,
  ): Promise<UserWithAuthoritiesAndRoles | null> {
    let user = await this.prisma.account
      .findFirst({
        where: {
          provider,
          providerId,
        },
      })
      .user({
        include: {
          authorities: {
            select: {
              authority: {
                select: {
                  name: true,
                },
              },
            },
          },
          roles: {
            select: {
              role: {
                select: {
                  name: true,
                },
              },
            },
          },
        },
      });

    if (!user) {
      return null;
    }

    const roles = user.roles.map((item) => item.role.name);
    const authorities = user.authorities.map((item) => item.authority.name);

    return { ...user, roles, authorities };
  }

  async create(
    providerId: string,
    provider: AuthProvider,
    { name, profileUrl }: { name: string; profileUrl: string },
  ): Promise<UserWithAuthoritiesAndRoles> {
    const role = await this.prisma.role.findFirstOrThrow({
      where: { name: 'USER' },
    });

    const user = await this.prisma.user.create({
      data: {
        name: name,
        avatar: profileUrl,
        isDeleted: false,
        isBanned: false,
        roles: {
          create: {
            roleId: role.id,
          },
        },
        accounts: {
          create: {
            provider,
            providerId,
            createdAt: new Date(),
          },
        },
      },
    });

    return { ...user, authorities: [], roles: [role.name] };
  }

  async get(id: number): Promise<User> {
    const user = await this.prisma.user.findFirst({ where: { id } });

    if (!user) {
      throw new NotFound('id');
    }

    return user;
  }

  async getMyNovel(session: SessionDto, query: GetAllNovelQuery) {
    const { status, sort, gene, page } = query;

    let q = {};
    let s = undefined;

    if (status && status !== 'all') {
      q = {
        status: status,
      };
    }

    if (sort) {
      s = sortMapping[sort];
    } else {
      s = sortMapping['latest_update'];
    }

    if (gene) {
      q = {
        ...q,
        categories: {
          some: {
            category: {
              id: parseInt(gene),
            },
          },
        },
      };
    }

    const result = await this.prisma.novel.findMany({
      where: {
        ...q,
        userId: session.id,
      },
      orderBy: s,
      include: {
        user: true,
        categories: {
          select: {
            category: true,
          },
        },
        follows:
          session === null
            ? false
            : {
                where: {
                  userId: session.id,
                },
              },
      },
      skip: 20 * (page - 1),
      take: 20,
    });

    return result.map((item) => ({
      ...item,
      categories: item.categories.map((c) => c.category),
      isFollowing: item.follows?.length === 1,
    }));
  }

  async getNewNovels(session: SessionDto) {
    const latestViewedChapters = await this.prisma.view.groupBy({
      by: ['novelId'],
      where: {
        userId: session.id,
      },
      _max: {
        chapterId: true,
      },
    });

    const result = await this.prisma.novel.findMany({
      where: {
        OR: latestViewedChapters.map((view) => ({
          id: view.novelId,
          chapters: {
            some: {
              id: {
                gt: view._max.chapterId,
              },
              View: {
                none: {
                  userId: session.id,
                },
              },
            },
          },
          follows: {
            some: {
              userId: session.id,
            },
          },
        })),
      },
      include: {
        chapters: {
          where: {
            OR: latestViewedChapters.map((view) => ({
              novelId: view.novelId,
              id: {
                gt: view._max.chapterId,
              },
              View: {
                none: {
                  userId: session.id,
                },
              },
            })),
          },
          orderBy: {
            id: 'asc',
          },
        },
        user: true,
        categories: {
          select: {
            category: true,
          },
        },
        follows:
          session === null
            ? false
            : {
                where: {
                  userId: session.id,
                },
              },
      },
    });

    return result.map((item) => ({
      ...item,
      categories: item.categories.map((c) => c.category),
      isFollowing: item.follows?.length === 1,
    }));
  }

  async getMyFavorites(session: SessionDto, query: GetAllNovelQuery) {
    const { status, sort, gene, page } = query;

    let q = {};
    let s = undefined;

    if (status && status !== 'all') {
      q = {
        status: status,
      };
    }

    if (sort) {
      s = sortMapping[sort];
    } else {
      s = sortMapping['latest_update'];
    }

    if (gene) {
      q = {
        ...q,
        categories: {
          some: {
            category: {
              id: parseInt(gene),
            },
          },
        },
      };
    }

    const result = await this.prisma.novel.findMany({
      where: {
        ...q,
        userId: session.id,
        follows: {
          every: {
            userId: session.id,
          },
        },
      },
      orderBy: s,
      include: {
        user: true,
        categories: {
          select: {
            category: true,
          },
        },
      },
      skip: 20 * (page - 1),
      take: 20,
    });

    return result.map((item) => ({
      ...item,
      categories: item.categories.map((c) => c.category),
      isFollowing: true,
    }));
  }
}
