import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { CategoryModule } from './services/category/category.module';
import { DatabaseModule } from 'src/services/database/database.module';
import { GenesModule } from './services/genes/genes.module';
import { NovelModule } from './services/novel/novel.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    CategoryModule, DatabaseModule, GenesModule, NovelModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
