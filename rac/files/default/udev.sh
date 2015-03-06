for i in b c d e f g h i
do
echo "KERNEL==\"sd*\", BUS==\"scsi\", PROGRAM==\"/sbin/scsi_id -g -u -s %p\", RESULT==\"`scsi_id -g -u -s /block/sd$i`\", NAME=\"asm-disk$i\", OWNER=\"grid\", GROUP=\"asmadmin\", MODE=\"0660\""
done