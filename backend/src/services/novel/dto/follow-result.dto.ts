import { Expose } from 'class-transformer';

export class FollowResultDto {
  @Expose()
  result: boolean;
}
