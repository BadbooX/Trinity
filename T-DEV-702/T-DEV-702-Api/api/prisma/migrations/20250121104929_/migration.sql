/*
  Warnings:

  - Made the column `idUser` on table `Shop` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "Shop" DROP CONSTRAINT "Shop_idUser_fkey";

-- AlterTable
ALTER TABLE "Shop" ALTER COLUMN "idUser" SET NOT NULL;

-- AddForeignKey
ALTER TABLE "Shop" ADD CONSTRAINT "Shop_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
