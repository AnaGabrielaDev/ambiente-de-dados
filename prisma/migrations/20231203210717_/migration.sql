-- DropForeignKey
ALTER TABLE `Tournament` DROP FOREIGN KEY `Tournament_rotation_id_fkey`;

-- AlterTable
ALTER TABLE `Tournament` MODIFY `rotation_id` INTEGER NULL;

-- AddForeignKey
ALTER TABLE `Tournament` ADD CONSTRAINT `Tournament_rotation_id_fkey` FOREIGN KEY (`rotation_id`) REFERENCES `Rotation`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
