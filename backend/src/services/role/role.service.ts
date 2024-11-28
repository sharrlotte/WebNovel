import { Injectable, OnModuleInit } from '@nestjs/common';
import { CreateRoleDto } from './dto/create-role.dto';
import { UpdateRoleDto } from './dto/update-role.dto';
import { DatabaseService } from 'src/services/database/database.service';

const defaultRoles = [
  {
    id: 1,
    name: 'USER',
    description: 'User role',
    createdAt: new Date(),
  },
  {
    id: 2,
    name: 'RECRUITER',
    description: 'Recruiter role',
    createdAt: new Date(),
  },
  {
    id: 3,
    name: 'CANDIDATE',
    description: 'Candidate role',
    createdAt: new Date(),
  },
  {
    id: 4,
    name: 'EMPLOYEE',
    description: 'Employee role',
    createdAt: new Date(),
  },
  {
    id: 5,
    name: 'ADMIN',
    description: 'Admin role',
    createdAt: new Date(),
  },
];

@Injectable()
export class RoleService implements OnModuleInit {
  constructor(private prismService: DatabaseService) {}

  onModuleInit() {
    defaultRoles.forEach(async (role) => {
      await this.prismService.role.upsert({
        where: { name: role.name, id: role.id },
        create: role,
        update: role,
      });
    });
  }
  create(createRoleDto: CreateRoleDto) {
    return 'This action adds a new role';
  }

  findAll() {
    return `This action returns all role`;
  }

  findOne(id: number) {
    return `This action returns a #${id} role`;
  }

  update(id: number, updateRoleDto: UpdateRoleDto) {
    return `This action updates a #${id} role`;
  }

  remove(id: number) {
    return `This action removes a #${id} role`;
  }
}
