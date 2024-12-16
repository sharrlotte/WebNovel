import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';
import { CreateFollowDto } from './dto/create-follow.dto';
import { UpdateFollowDto } from './dto/update-follow.dto';

@Injectable()
export class FollowsService {
  constructor(private readonly databaseService: DatabaseService) {}

  async create(createFollowDto: CreateFollowDto) {
    // Kiểm tra novel tồn tại
    const novel = await this.databaseService.novel.findUnique({
      where: { id: createFollowDto.novelId },
    });

    if (!novel) {
      throw new NotFoundException(`Novel với ID ${createFollowDto.novelId} không tồn tại`);
    }

    // Kiểm tra xem đã follow chưa
    const existingFollow = await this.databaseService.follow.findFirst({
      where: {
        AND: [
          { novelId: createFollowDto.novelId },
          { userId: 0 }, // Tạm thời hardcode, sau này sẽ lấy từ session
        ],
      },
    });

    if (existingFollow) {
      throw new BadRequestException('Bạn đã follow truyện này rồi');
    }

    return this.databaseService.follow.create({
      data: {
        novelId: createFollowDto.novelId,
        userId: 0, // Tạm thời hardcode, sau này sẽ lấy từ session
        createdAt: new Date(), // Tự động tạo thời gian
      },
      include: {
        novel: true,
        user: true,
      },
    });
  }

  findAll() {
    return this.databaseService.follow.findMany({
      include: {
        novel: true,
        user: true,
      },
    });
  }

  async findOne(id: number) {
    const follow = await this.databaseService.follow.findUnique({
      where: { id },
      include: {
        novel: true,
        user: true,
      },
    });

    if (!follow) {
      throw new NotFoundException(`Follow với ID ${id} không tồn tại`);
    }

    return follow;
  }

  // Không cần phương thức update vì người dùng chỉ cần thêm/xóa follow

  async remove(id: number) {
    const follow = await this.databaseService.follow.findUnique({
      where: { id },
    });

    if (!follow) {
      throw new NotFoundException(`Follow với ID ${id} không tồn tại`);
    }

    return this.databaseService.follow.delete({
      where: { id },
      include: {
        novel: true,
        user: true,
      },
    });
  }
}
