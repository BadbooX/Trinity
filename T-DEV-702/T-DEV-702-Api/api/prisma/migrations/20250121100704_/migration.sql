/*
  Warnings:

  - You are about to drop the column `idShops` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the `Shops` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `idShop` to the `Product` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Product" DROP CONSTRAINT "Product_idShops_fkey";

-- DropForeignKey
ALTER TABLE "Shops" DROP CONSTRAINT "Shops_idAddress_fkey";

-- DropForeignKey
ALTER TABLE "Shops" DROP CONSTRAINT "Shops_idUser_fkey";

-- AlterTable
ALTER TABLE "Product" DROP COLUMN "idShops",
ADD COLUMN     "idShop" INTEGER NOT NULL;

-- DropTable
DROP TABLE "Shops";

-- CreateTable
CREATE TABLE "Shop" (
    "id" SERIAL NOT NULL,
    "idPaypal" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "idAddress" INTEGER NOT NULL,
    "idUser" INTEGER,

    CONSTRAINT "Shop_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Shop_idAddress_key" ON "Shop"("idAddress");

-- AddForeignKey
ALTER TABLE "Shop" ADD CONSTRAINT "Shop_idAddress_fkey" FOREIGN KEY ("idAddress") REFERENCES "Address"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Shop" ADD CONSTRAINT "Shop_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_idShop_fkey" FOREIGN KEY ("idShop") REFERENCES "Shop"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
