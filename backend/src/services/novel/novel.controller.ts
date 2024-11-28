import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseIntPipe,
} from '@nestjs/common';
import { NovelService } from './novel.service';
import { CreateNovelDto } from './dto/create-novel.dto';
import { UpdateNovelDto } from './dto/update-novel.dto';
import NovelDto from './dto/novel.dto';
import { plainToInstance } from 'class-transformer';

@Controller('novels')
export class NovelController {
  constructor(private readonly novelService: NovelService) {}

  @Post()
  create(@Body() createNovelDto: CreateNovelDto) {
    return plainToInstance(
      NovelDto,
      this.novelService.create(createNovelDto),
    );
  }

  @Get()
  findAll() {
    return this.novelService
      .findAll()
      .then((items) => items.map((item) => plainToInstance(NovelDto, item)));
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return plainToInstance(NovelDto, this.novelService.findOne(id));
  }

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateNovelDto: UpdateNovelDto,
  ) {
    return plainToInstance(
      NovelDto,
      this.novelService.update(id, updateNovelDto),
    );
  }

  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number) {
    return plainToInstance(NovelDto, this.novelService.remove(id));
  }
}
