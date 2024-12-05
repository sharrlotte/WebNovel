import {
  Controller,
  HttpException,
  Injectable,
  Post,
  Req,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Request } from 'express';
import { AppConfig } from 'src/config/configuration';
import { OAuth2Client } from 'google-auth-library';
import { UsersService } from 'src/services/users/users.service';
import { JwtAuthService } from 'src/services/jwt/jwt.service';

@Controller('auth/google')
@Injectable()
export class GoogleOauthController {
  private google: OAuth2Client;
  constructor(
    private configService: ConfigService<AppConfig>,
    private usersService: UsersService,
    private jwtService: JwtAuthService,
  ) {
    this.google = new OAuth2Client(
      configService.get<string>('auth.google.clientId', { infer: true }),
      configService.get<string>('auth.google.clientId', { infer: true }),
    );
  }

  @Post('')
  async googleAuthCallback(@Req() req: Request) {
    const accessToken = req.body.idToken;

    const ticket = await this.google.verifyIdToken({
      idToken: accessToken,
      audience: [
        this.configService.getOrThrow<string>('auth.google.clientId', {
          infer: true,
        }),
      ],
    });

    const data = ticket.getPayload();

    if (!data) {
      throw new HttpException('Invalid token', 400);
    }

    const { sub, name, profile } = data;

    let user = await this.usersService.find(sub, 'google');

    if (!user) {
      user = await this.usersService.create(sub, 'google', {
        name: name,
        profileUrl: profile,
      });
    }

    return { accessToken: this.jwtService.login(user) };
  }
}
