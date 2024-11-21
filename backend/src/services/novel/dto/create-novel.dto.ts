import { IsString, IsNotEmpty, IsOptional, IsNumber } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateNovelDto {
  @ApiProperty({ example: 'Tên truyện', description: 'Tên truyện' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({ example: 'Mô tả truyện', description: 'Mô tả truyện', required: false })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({ example: 'url_cover.jpg', description: 'Đường dẫn ảnh bìa', required: false })
  @IsString()
  @IsOptional()
  cover?: string;

  @ApiProperty({ example: 'Tên tác giả', description: 'Tên tác giả' })
  @IsString()
  @IsNotEmpty()
  author: string;

  @ApiProperty({ example: 'Đang tiến hành', description: 'Trạng thái truyện' })
  @IsString()
  @IsNotEmpty()
  status: string;
}
