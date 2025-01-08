import { IsString, IsNotEmpty, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class CreateNovelDto {
  @Expose()
  @ApiProperty({ example: 'Tên truyện', description: 'Tên truyện' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({
    example: 'Mô tả truyện',
    description: 'Mô tả truyện',
    required: false,
  })
  @IsString()
  @IsOptional()
  @Expose()
  description?: string;

  @ApiProperty({
    example: 'url_cover.jpg',
    description: 'Đường dẫn ảnh bìa',
    required: false,
  })
  @IsString()
  @IsOptional()
  @Expose()
  cover?: string;

  @ApiProperty({ example: 'Tên tác giả', description: 'Tên tác giả' })
  @IsString()
  @IsNotEmpty()
  @Expose()
  author: string;

  @Expose()
  categoryIds: string[];
}
