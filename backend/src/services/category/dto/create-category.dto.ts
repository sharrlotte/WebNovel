import { IsNotEmpty, MinLength } from 'class-validator';

export class CreateCategoryDto {
  @IsNotEmpty()
  @MinLength(1)
  name: string;

  @IsNotEmpty()
  @MinLength(1)
  description?: string;
}
