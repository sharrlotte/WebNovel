import { Injectable, OnModuleInit } from '@nestjs/common';
import { DatabaseService } from 'src/services/database/database.service';

const authorities = [
  'MANAGE_USER',
  'VIEW_REPORT',
  'VIEW_TRANSACTION',
  'MANAGE_CATEGORY',
];

const defaultAuthorities = authorities.map((authority, index) => ({
  id: index,
  name: authority,
  description: authority,
  createdAt: new Date(),
}));

@Injectable()
export class AuthoritiesService implements OnModuleInit {
  constructor(private DatabaseService: DatabaseService) {}

  onModuleInit() {
    defaultAuthorities.forEach(async (authority) => {
      await this.DatabaseService.authority.upsert({
        where: {
          id: authority.id,
        },
        create: authority,
        update: authority,
      });
    });
  }
}
