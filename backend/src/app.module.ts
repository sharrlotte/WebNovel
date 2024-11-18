import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { CategoryModule } from './services/category/category.module';
import { DatabaseModule } from 'src/services/database/database.module';
import { GeneModule } from './services/gene/gene.module';

@Module({
  imports: [CategoryModule, DatabaseModule, GeneModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
