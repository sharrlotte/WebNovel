import {
  Injectable,
  BadRequestException,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { CreateNovelDto } from './dto/create-novel.dto';
import { UpdateNovelDto } from './dto/update-novel.dto';
import { DatabaseService } from 'src/services/database/database.service';
import {
  GetAllNovelQuery,
  sortMapping,
} from 'src/services/novel/dto/get-all-novel-query.dto';
import { SessionDto } from 'src/services/auth/dto/session.dto';
import { NovelStatus } from 'src/services/novel/enums/novel-status.enum';
import { CreateChapterDto } from 'src/services/chapters/dto/create-chapter.dto';
import { CreateCommentDto } from 'src/services/comments/dto/create-comment.dto';

@Injectable()
export class NovelService {
  constructor(private readonly databaseService: DatabaseService) {}

  async create(createNovelDto: CreateNovelDto, userId: number) {
    return this.databaseService.novel.create({
      data: {
        ...createNovelDto,
        userId,
        status: NovelStatus.ON_GOING,
      },
    });
  }

  async findManyChapters(novelId: number, page: number) {
    return this.databaseService.chapter
      .findMany({
        where: {
          novelId,
        },
        include: {
          _count: {
            select: {
              Comment: true,
            },
          },
        },
        skip: (page - 1) * 20,
        take: 20,
      })
      .then((res) =>
        res.map((chapter) => ({ comment: chapter._count.Comment, ...chapter })),
      );
  }

  async findNextChapter(id: number, chapterId: number) {
    return this.databaseService.chapter.findFirst({
      where: {
        novelId: id,
        id: {
          gt: chapterId,
        },
      },
      orderBy: {
        id: 'asc',
      },
    });
  }

  async findAll(query: GetAllNovelQuery, session: SessionDto) {
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

    const result = await this.databaseService.novel.findMany({
      where: q,
      orderBy: s,
      include: {
        user: true,
        categories: true,
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
      isFollowing: item.follows?.length === 1,
    }));
  }

  findOne(id: number) {
    return this.databaseService.novel.findUnique({
      where: { id },
      include: {
        user: true,
        chapters: true,
        comments: true,
        ratings: true,
      },
    });
  }

  async addComment(id: number, userId: number, payload: CreateCommentDto) {
    return this.databaseService.comment.create({
      data: {
        ...payload,
        userId: userId,
        novelId: id,
      },
    });
  }

  async addChapterComment(
    id: number,
    chapterId: number,
    userId: number,
    payload: CreateCommentDto,
  ) {
    return this.databaseService.comment.create({
      data: {
        ...payload,
        chapterId,
        userId: userId,
        novelId: id,
      },
    });
  }

  async addChapter(id: number, userId: number, payload: CreateChapterDto) {
    const novel = await this.databaseService.novel.findFirst({
      where: { id: id },
    });

    if (novel.userId !== userId) {
      throw new ForbiddenException();
    }

    const sameChapterName = await this.databaseService.chapter.findFirst({
      where: {
        novelId: id,
        name: payload.name,
      },
    });

    if (sameChapterName) {
      throw new BadRequestException('Chapter name already exists');
    }

    return this.databaseService.chapter.create({
      data: {
        ...payload,
        novelId: id,
      },
    });
  }

  async getComments(id: number) {
    return this.databaseService.comment.findMany({
      where: {
        novelId: id,
      },
      include: {
        user: true,
      },
    });
  }

  async getChapterComments(id: number, chapterId: number) {
    return this.databaseService.comment.findMany({
      where: {
        novelId: id,
        chapterId,
      },
      include: {
        user: true,
      },
    });
  }

  async follow(id: number, userId: number) {
    const follow = await this.databaseService.follow.findFirst({
      where: {
        novelId: id,
        userId,
      },
    });

    if (follow) {
      await this.databaseService.follow.delete({
        where: {
          id: follow.id,
        },
      });

      await this.databaseService.novel.update({
        where: { id: id },
        data: { followerCount: { decrement: 1 } },
      });

      return { result: false };
    } else {
      await this.databaseService.follow.create({
        data: {
          novelId: id,
          userId,
          createdAt: new Date(),
        },
      });

      await this.databaseService.novel.update({
        where: { id: id },
        data: { followerCount: { increment: 1 } },
      });

      return { result: true };
    }
  }

  async update(id: number, updateNovelDto: UpdateNovelDto, userId: number) {
    const novel = await this.findOne(id);
    if (novel.userId !== userId) {
      throw new ForbiddenException('Bạn không có quyền sửa novel này');
    }
    try {
      const currentNovel = await this.databaseService.novel.findUnique({
        where: { id },
      });

      if (!currentNovel) {
        throw new NotFoundException(`Novel với ID ${id} không tồn tại`);
      }

      // Kiểm tra view
      if (
        'view' in updateNovelDto &&
        updateNovelDto.view !== currentNovel.view
      ) {
        throw new BadRequestException(
          'Bạn không được phép sửa số lượt xem của truyện',
        );
      }

      // Kiểm tra updatedAt

      // Kiểm tra rating
      if (
        'rating' in updateNovelDto &&
        updateNovelDto.rating !== currentNovel.rating
      ) {
        throw new BadRequestException(
          'Bạn không được phép sửa điểm đánh giá của truyện',
        );
      }

      // Kiểm tra followerCount
      if (
        'followerCount' in updateNovelDto &&
        updateNovelDto.followerCount !== currentNovel.followerCount
      ) {
        throw new BadRequestException(
          'Bạn không được phép sửa số người theo dõi truyện',
        );
      }

      // Kiểm tra commentCount
      if (
        'commentCount' in updateNovelDto &&
        updateNovelDto.commentCount !== currentNovel.commentCount
      ) {
        throw new BadRequestException(
          'Bạn không được phép sửa số lượng bình luận',
        );
      }

      return await this.databaseService.novel.update({
        where: { id },
        data: updateNovelDto,
      });
    } catch (error) {
      if (
        error instanceof BadRequestException ||
        error instanceof NotFoundException
      ) {
        throw error;
      }
      throw new BadRequestException('Không thể sửa UserId.');
    }
  }

  async remove(id: number, userId: number) {
    const novel = await this.findOne(id);

    if (!novel) {
      throw new NotFoundException(`Novel với ID ${id} không tồn tại`);
    }

    if (novel.userId !== userId) {
      throw new ForbiddenException('Bạn không có quyền xóa novel này');
    }

    return this.databaseService.novel.delete({
      where: { id },
    });
  }
}
