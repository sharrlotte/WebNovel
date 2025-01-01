import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseIntPipe,
  Req,
  Query,
} from '@nestjs/common';
import { NovelService } from './novel.service';
import { CreateNovelDto } from './dto/create-novel.dto';
import { UpdateNovelDto } from './dto/update-novel.dto';
import NovelDto from './dto/novel.dto';
import { plainToClass, plainToInstance } from 'class-transformer';
import { getSession, getSessionOrNull } from '../auth/auth.utils';
import { Request } from 'express';
import { GetAllNovelQuery } from 'src/services/novel/dto/get-all-novel-query.dto';
import ChapterDto from 'src/services/chapters/dto/chapter.dto';
import { FollowResultDto } from 'src/services/novel/dto/follow-result.dto';

@Controller('novels')
export class NovelController {
  constructor(private readonly novelService: NovelService) {}

  @Post()
  create(@Body() createNovelDto: CreateNovelDto, @Req() req: Request) {
    const session = getSession(req);
    return plainToInstance(
      NovelDto,
      this.novelService.create(
        plainToClass(CreateNovelDto, createNovelDto, {
          strategy: 'excludeAll',
        }),
        session.id,
      ),
    );
  }

  @Get()
  async findAll(@Query() query: GetAllNovelQuery, @Req() req: Request) {
    const session = getSessionOrNull(req);

    const data = await this.novelService
      .findAll(query, session)
      .then((items) => items.map((item) => plainToInstance(NovelDto, item)));

    return data;
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return plainToInstance(NovelDto, this.novelService.findOne(id));
  }

  @Get(':id/chapters')
  findManyChapters(
    @Param('id', ParseIntPipe) id: number,
    @Query('page', ParseIntPipe) page,
  ) {
    return this.novelService
      .findManyChapters(id, page)
      .then((items) => items.map((item) => plainToInstance(ChapterDto, item)));
  }

  @Get(':id/chapters/:chapterId/next')
  findNextChapter(
    @Param('id', ParseIntPipe) id: number,
    @Param('chapterId', ParseIntPipe) chapterId: number,
  ) {
    return this.novelService
      .findNextChapter(id, chapterId)
      .then((item) => plainToInstance(ChapterDto, item));
  }

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateNovelDto: UpdateNovelDto,
    @Req() req: Request,
  ) {
    const session = getSession(req);
    return plainToInstance(
      NovelDto,
      this.novelService.update(id, updateNovelDto, session.id),
    );
  }

  @Post(':id/follow')
  follow(@Param('id', ParseIntPipe) id: number, @Req() req: Request) {
    const session = getSession(req);
    return plainToInstance(
      FollowResultDto,
      this.novelService.follow(id, session.id),
    );
  }

  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number, @Req() req: Request) {
    const session = getSession(req);
    return plainToInstance(NovelDto, this.novelService.remove(id, session.id));
  }
}
