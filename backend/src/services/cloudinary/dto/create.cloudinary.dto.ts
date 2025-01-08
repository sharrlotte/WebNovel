import { IsFile, MaxFileSize, MemoryStoredFile } from 'nestjs-form-data';

export class CreateCloudinaryDto {
  @IsFile()
  image: MemoryStoredFile;
}
