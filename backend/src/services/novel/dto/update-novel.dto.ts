import { PartialType } from '@nestjs/mapped-types';
import { CreateNovelDto } from './create-novel.dto';
import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { IsEnum, IsNotEmpty } from 'class-validator';
import { NovelStatus } from 'src/services/novel/novel-status.enum';

export class UpdateNovelDto extends PartialType(CreateNovelDto) {
  cover?: string;
  @ApiProperty({
    example: NovelStatus.ON_GOING,
    description: 'Trạng thái truyện',
    enum: NovelStatus,
    enumName: 'NovelStatus',
  })
  @IsEnum(NovelStatus, {
    message:
      'Trạng thái truyện phải là: Đang tiến hành, Hoàn thành hoặc Tạm ngưng',
  })
  @Expose()
  @IsNotEmpty()
  status: NovelStatus;
  
  @Expose()
  categoryIds?: string[];
}
