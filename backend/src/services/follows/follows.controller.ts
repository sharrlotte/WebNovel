import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  ParseIntPipe,
} from '@nestjs/common';
import { FollowsService } from './follows.service';
import { CreateFollowDto } from './dto/create-follow.dto';
import FollowDto from './dto/follows.dto';
import { plainToInstance } from 'class-transformer';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('follows')
@Controller('follows')
export class FollowsController {
  constructor(private readonly followsService: FollowsService) {}

  @Post()
  create(@Body() createFollowDto: CreateFollowDto) {
    return plainToInstance(
      FollowDto,
      this.followsService.create(createFollowDto),
    );
  }

  @Get()
  findAll() {
    return this.followsService
      .findAll()
      .then((items) => items.map((item) => plainToInstance(FollowDto, item)));
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return plainToInstance(FollowDto, this.followsService.findOne(id));
  }

  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number) {
    return plainToInstance(FollowDto, this.followsService.remove(id));
  }
}
