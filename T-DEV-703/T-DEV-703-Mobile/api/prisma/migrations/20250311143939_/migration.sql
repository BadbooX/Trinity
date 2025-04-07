/*
  Warnings:

  - You are about to drop the `Invoice` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `InvoiceProduct` table. If the table is not empty, all the data it contains will be lost.

*/
-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "OrderStatus" ADD VALUE 'PAID';
ALTER TYPE "OrderStatus" ADD VALUE 'REFUNDED';

-- DropForeignKey
ALTER TABLE "Invoice" DROP CONSTRAINT "Invoice_idUser_fkey";

-- DropForeignKey
ALTER TABLE "InvoiceProduct" DROP CONSTRAINT "InvoiceProduct_idInvoice_fkey";

-- DropForeignKey
ALTER TABLE "InvoiceProduct" DROP CONSTRAINT "InvoiceProduct_idProduct_fkey";

-- DropTable
DROP TABLE "Invoice";

-- DropTable
DROP TABLE "InvoiceProduct";
