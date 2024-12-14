import {
  Controller,
  Get,
  Post,
  Body,
  Delete,
  Param,
  ParseIntPipe,
} from '@nestjs/common';
import { HistorysService } from './historys.service';
import { CreateHistoryDto } from './dto/create-history.dto';
import HistoryDto from './dto/history.dto';
import { plainToInstance } from 'class-transformer';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('historys')
@Controller('historys')
export class HistorysController {
  constructor(private readonly historysService: HistorysService) {}

  @Post()
  create(@Body() createHistoryDto: CreateHistoryDto) {
    return plainToInstance(
      HistoryDto,
      this.historysService.create(createHistoryDto),
    );
  }

  @Get()
  findAll() {
    return this.historysService
      .findAll()
      .then((items) => items.map((item) => plainToInstance(HistoryDto, item)));
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return plainToInstance(HistoryDto, this.historysService.findOne(id));
  }

  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number) {
    return plainToInstance(HistoryDto, this.historysService.remove(id));
  }
}
