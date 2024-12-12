import { Expose, Type } from 'class-transformer';
import { UserResponse } from 'src/services/users/dto/user.response';

export class GoogleAuthResponse {
  @Expose()
  accessToken: string;

  @Expose()
  @Type(() => UserResponse)
  user: UserResponse;
}
