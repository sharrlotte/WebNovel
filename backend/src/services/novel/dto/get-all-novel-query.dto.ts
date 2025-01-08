import { Type } from 'class-transformer';
import { Min } from 'class-validator';

export class GetAllNovelQuery {
  status: string;

  sort: string;

  gene: string;

  @Type(() => Number)
  @Min(1)
  page: number = 0;
}

export const sortMapping = {
  newest: {
    updatedAt: 'desc',
  },
  latest_update: {
    updatedAt: 'desc',
  },
  most_liked: {
    rating: 'desc',
  },
  most_viewed: {
    view: 'desc',
  },
  chapter_count: {
    chapter: 'desc',
  },
};
