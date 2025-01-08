import {
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Query,
  Req,
} from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { getSession, getSessionOrNull } from 'src/services/auth/auth.utils';
import { Request } from 'express';
import { UsersService } from 'src/services/users/users.service';
import { UserResponse } from 'src/services/users/dto/user.response';
import { SessionResponseDto } from 'src/services/auth/dto/session.dto';
import NovelDto from 'src/services/novel/dto/novel.dto';
import { GetAllNovelQuery } from 'src/services/novel/dto/get-all-novel-query.dto';

@Controller('users')
export class UsersController {
  constructor(private readonly userService: UsersService) {}

  @Get('/session')
  getSession(@Req() req: Request): SessionResponseDto | null {
    const session = getSessionOrNull(req);

    if (session === null) {
      return null;
    }

    return plainToInstance(SessionResponseDto, {
      ...session,
      rolePicked: !session.roles.some(
        (role) => role === 'CANDIDATE' || role === 'RECRUITER',
      ),
    });
  }

  @Get(':id')
  get(@Param('id', ParseIntPipe) id: number) {
    return plainToInstance(UserResponse, this.userService.get(id));
  }
  @Get('@me/novels')
  getMyNovel(@Req() req: Request, @Query() query: GetAllNovelQuery) {
    const session = getSession(req);

    return this.userService
      .getMyNovel(session, query)
      .then((items) => items.map((item) => plainToInstance(NovelDto, item)));
  }
  @Get('@me/favorites')
  getMyFavorites(@Req() req: Request, @Query() query: GetAllNovelQuery) {
    const session = getSession(req);

    return this.userService
      .getMyFavorites(session, query)
      .then((items) => items.map((item) => plainToInstance(NovelDto, item)));
  }
}
