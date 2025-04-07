/*
  Warnings:

  - You are about to drop the column `idStore` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the `Store` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `idShops` to the `Product` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Product" DROP CONSTRAINT "Product_idStore_fkey";

-- DropForeignKey
ALTER TABLE "Store" DROP CONSTRAINT "Store_idAddress_fkey";

-- DropForeignKey
ALTER TABLE "Store" DROP CONSTRAINT "Store_idUser_fkey";

-- AlterTable
ALTER TABLE "Product" DROP COLUMN "idStore",
ADD COLUMN     "idShops" INTEGER NOT NULL;

-- DropTable
DROP TABLE "Store";

-- CreateTable
CREATE TABLE "Shops" (
    "id" SERIAL NOT NULL,
    "idPaypal" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "idAddress" INTEGER NOT NULL,
    "idUser" INTEGER,

    CONSTRAINT "Shops_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Shops_idAddress_key" ON "Shops"("idAddress");

-- AddForeignKey
ALTER TABLE "Shops" ADD CONSTRAINT "Shops_idAddress_fkey" FOREIGN KEY ("idAddress") REFERENCES "Address"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Shops" ADD CONSTRAINT "Shops_idUser_fkey" FOREIGN KEY ("idUser") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_idShops_fkey" FOREIGN KEY ("idShops") REFERENCES "Shops"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
