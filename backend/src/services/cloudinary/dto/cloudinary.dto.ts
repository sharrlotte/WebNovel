import { Expose } from 'class-transformer';

export class CloudinaryDto {
  @Expose()
  url: string;
}
