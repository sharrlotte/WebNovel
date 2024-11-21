import { Injectable } from '@nestjs/common';
import { CreateNovelDto } from './dto/create-novel.dto';
import { UpdateNovelDto } from './dto/update-novel.dto';
import { DatabaseService } from 'src/services/database/database.service';

@Injectable()
export class NovelService {
  constructor(private readonly databaseService: DatabaseService) {}

  create(createNovelDto: CreateNovelDto) {
    return this.databaseService.novel.create({
      data: { ...createNovelDto, userId: 0 },
    });
  }

  findAll() {
    return this.databaseService.novel.findMany({
      include: {
        user: true,
        chapters: true,
      },
    });
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

  update(id: number, updateNovelDto: UpdateNovelDto) {
    return this.databaseService.novel.update({
      where: { id },
      data: updateNovelDto,
    });
  }

  remove(id: number) {
    return this.databaseService.novel.delete({
      where: { id },
    });
  }
}
