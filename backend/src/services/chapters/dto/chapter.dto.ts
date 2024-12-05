import { Expose } from 'class-transformer';

export default class ChapterDto {
  @Expose()
  id: number;

  @Expose()
  name: string;

  @Expose()
  createdAt: Date;

  @Expose()
  novelId: number;
}
