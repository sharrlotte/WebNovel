/*
  Warnings:

  - Added the required column `chapterId` to the `View` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "View" ADD COLUMN     "chapterId" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "View" ADD CONSTRAINT "View_chapterId_fkey" FOREIGN KEY ("chapterId") REFERENCES "Chapter"("id") ON DELETE CASCADE ON UPDATE CASCADE;
