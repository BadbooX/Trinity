/*
  Warnings:

  - You are about to drop the column `streetNumber` on the `Address` table. All the data in the column will be lost.
  - You are about to drop the column `streetType` on the `Address` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `Address` table. All the data in the column will be lost.
  - You are about to drop the column `password` on the `Shop` table. All the data in the column will be lost.
  - Added the required column `street` to the `Address` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Address" DROP CONSTRAINT "Address_userId_fkey";

-- DropIndex
DROP INDEX "Address_userId_key";

-- AlterTable
ALTER TABLE "Address" DROP COLUMN "streetNumber",
DROP COLUMN "streetType",
DROP COLUMN "userId",
ADD COLUMN     "Userid" INTEGER,
ADD COLUMN     "street" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Shop" DROP COLUMN "password";

-- AddForeignKey
ALTER TABLE "Address" ADD CONSTRAINT "Address_Userid_fkey" FOREIGN KEY ("Userid") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
