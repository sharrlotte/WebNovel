import { Expose, Type } from 'class-transformer';
import CategoryDto from 'src/services/category/dto/category.dto';
import ChapterDto from 'src/services/chapters/dto/chapter.dto';

export default class NewNovelDto {
  @Expose()
  id: number;

  @Expose()
  name: string;

  @Expose()
  description: string;

  @Expose()
  createdAt: Date;

  @Expose()
  cover: string;

  @Expose()
  author: string;

  @Expose()
  status: string;

  @Expose()
  view: number;

  @Expose()
  updatedAt: Date;

  @Expose()
  rating: number;

  @Expose()
  followerCount: number;

  @Expose()
  commentCount: number;

  @Expose()
  userId: number;

  @Expose()
  isFollowing: boolean;

  @Expose()
  @Type(() => CategoryDto)
  categories: CategoryDto[];

  @Expose()
  @Type(() => ChapterDto)
  chapters: ChapterDto[];
}
