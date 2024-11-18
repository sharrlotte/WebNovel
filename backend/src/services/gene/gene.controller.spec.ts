import { Test, TestingModule } from '@nestjs/testing';
import { GeneController } from './gene.controller';
import { GeneService } from './gene.service';

describe('GeneController', () => {
  let controller: GeneController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [GeneController],
      providers: [GeneService],
    }).compile();

    controller = module.get<GeneController>(GeneController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
