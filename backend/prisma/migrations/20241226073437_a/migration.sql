-- CreateTable
CREATE TABLE "NovelCategory" (
    "id" SERIAL NOT NULL,
    "novelId" INTEGER NOT NULL,
    "categoryId" INTEGER NOT NULL,

    CONSTRAINT "NovelCategory_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "NovelCategory" ADD CONSTRAINT "NovelCategory_novelId_fkey" FOREIGN KEY ("novelId") REFERENCES "Novel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NovelCategory" ADD CONSTRAINT "NovelCategory_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
