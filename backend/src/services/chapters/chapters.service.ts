import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { CreateChapterDto } from './dto/create-chapter.dto';
import { UpdateChapterDto } from './dto/update-chapter.dto';
import { DatabaseService } from 'src/services/database/database.service';

@Injectable()
export class ChaptersService {
  constructor(private readonly databaseService: DatabaseService) {}

  async create(createChapterDto: CreateChapterDto) {
    const existingChapter = await this.databaseService.chapter.findFirst({
      where: {
        AND: [
          { name: createChapterDto.name },
          { novelId: createChapterDto.novelId }
        ]
      }
    });

    if (existingChapter) {
      throw new ConflictException('Chapter với tên này đã tồn tại trong novel này');
    }

    return this.databaseService.chapter.create({
      data: createChapterDto,
    });
  }

  async findAll() {
    try {
      const chapters = await this.databaseService.chapter.findMany({
        include: {
          novel: true,
          Comment: true,
        },
      });

      if (!chapters || chapters.length === 0) {
        return []; 
      }

      return chapters;
    } catch (error) {
      console.error('Error in findAll:', error);
      throw error;
    }
  }

  async findOne(id: number) {
    try {
      const chapter = await this.databaseService.chapter.findUnique({
        where: { id },
        include: {
          novel: true,
          Comment: true,
        },
      });

      if (!chapter) {
        throw new NotFoundException(`Chapter with ID ${id} not found`);
      }

      return chapter;
    } catch (error) {
      console.error(`Error in findOne(${id}):`, error);
      throw error;
    }
  }

  async update(id: number, updateChapterDto: UpdateChapterDto) {
    try {
      return await this.databaseService.chapter.update({
        where: { id },
        data: updateChapterDto,
      });
    } catch (error) {
      throw new NotFoundException(`Chapter with ID ${id} not found`);
    }
  }

  async remove(id: number) {
    try {
      return await this.databaseService.chapter.delete({
        where: { id },
      });
    } catch (error) {
      throw new NotFoundException(`Chapter with ID ${id} not found`);
    }
  }
}
