import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { GeneService } from './gene.service';
import { CreateGeneDto } from './dto/create-gene.dto';
import { UpdateGeneDto } from './dto/update-gene.dto';

@Controller('gene')
export class GeneController {
  constructor(private readonly geneService: GeneService) {}

  @Post()
  create(@Body() createGeneDto: CreateGeneDto) {
    return this.geneService.create(createGeneDto);
  }

  @Get()
  findAll() {
    return this.geneService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.geneService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateGeneDto: UpdateGeneDto) {
    return this.geneService.update(+id, updateGeneDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.geneService.remove(+id);
  }
}
