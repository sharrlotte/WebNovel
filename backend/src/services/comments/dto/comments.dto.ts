import { Expose, Type } from 'class-transformer';
import { UserResponse } from 'src/services/users/dto/user.response';

export default class CommentDto {
  @Expose()
  id: number;

  @Expose()
  chapterId: number;

  @Expose()
  userId: number;

  @Expose()
  content: string;

  @Expose()
  createdAt: Date;

  @Expose()
  @Type(() => UserResponse)
  user: UserResponse;

  @Expose()
  novelId?: number;
}
