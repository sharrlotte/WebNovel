import { Expose } from 'class-transformer';

export class GoogleAuthResponse {
  @Expose()
  accessToken: string;
}
