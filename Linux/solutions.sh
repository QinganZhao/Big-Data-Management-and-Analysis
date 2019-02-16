mkdir HW1
cd HW1
wget http://www.gutenberg.org/files/98/98-0.txt -O story.txt

split story.txt sample_
mkdir subfiles
mv sample_* subfiles

cd subfiles/sample1
echo franklin >.franklin
echo zhao >.zhao

ls -a
cat .franklin
cat .zhao

cd ../tmp 

tar -cf subfiles.tar sample_*
gzip subfiles.tar 

mkdir tar_zip
mv subfiles.tar.gz tar_zip
cd tar_zip
gzip -d subfiles.tar.gz 
tar -xf subfiles.tar

scp -r -P 1111 fzhao@localhost:HW1/subfiles/tar_zip ~/Desktop

vi unixIsAwesome1.txt

:wq

cat unixIsAwesome1.txt > unixIsAwesome2.txt

cat unixIsAwesome2.txt 

cat -n unixIsAwesome2.txt | head -n -2

cd subfiles

vi sample_aa

head -n30 sample_aa > outputb5b.txt

Open terminal in Mac, then: 
scp -P 1111 fzhao@localhost:HW1/subfiles/outputb5b.txt ~/Desktop/

chmod 754 sample_aa

ping amazon.com
