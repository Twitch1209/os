
obj/user/testfile.debug：     文件格式 elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 54 06 00 00       	call   800685 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 50 80 00       	push   $0x805000
  800042:	e8 63 0d 00 00       	call   800daa <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 54 80 00    	mov    %ebx,0x805400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 69 13 00 00       	call   8013c2 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 50 80 00       	push   $0x805000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 43 13 00 00       	call   8013ab <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 1b 13 00 00       	call   801394 <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	57                   	push   %edi
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008a:	ba 00 00 00 00       	mov    $0x0,%edx
  80008f:	b8 40 23 80 00       	mov    $0x802340,%eax
  800094:	e8 9a ff ff ff       	call   800033 <xopen>
  800099:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80009c:	74 08                	je     8000a6 <umain+0x28>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	0f 88 e9 03 00 00    	js     80048f <umain+0x411>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
  8000a6:	85 c0                	test   %eax,%eax
  8000a8:	0f 89 f3 03 00 00    	jns    8004a1 <umain+0x423>
		panic("serve_open /not-found succeeded!");

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b3:	b8 75 23 80 00       	mov    $0x802375,%eax
  8000b8:	e8 76 ff ff ff       	call   800033 <xopen>
  8000bd:	85 c0                	test   %eax,%eax
  8000bf:	0f 88 f0 03 00 00    	js     8004b5 <umain+0x437>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000c5:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000cc:	0f 85 f5 03 00 00    	jne    8004c7 <umain+0x449>
  8000d2:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000d9:	0f 85 e8 03 00 00    	jne    8004c7 <umain+0x449>
  8000df:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000e6:	0f 85 db 03 00 00    	jne    8004c7 <umain+0x449>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 96 23 80 00       	push   $0x802396
  8000f4:	e8 c7 06 00 00       	call   8007c0 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800102:	50                   	push   %eax
  800103:	68 00 c0 cc cc       	push   $0xccccc000
  800108:	ff 15 1c 30 80 00    	call   *0x80301c
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	0f 88 c2 03 00 00    	js     8004db <umain+0x45d>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 35 00 30 80 00    	pushl  0x803000
  800122:	e8 4c 0c 00 00       	call   800d73 <strlen>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80012d:	0f 85 ba 03 00 00    	jne    8004ed <umain+0x46f>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 b8 23 80 00       	push   $0x8023b8
  80013b:	e8 80 06 00 00       	call   8007c0 <cprintf>

	memset(buf, 0, sizeof buf);
  800140:	83 c4 0c             	add    $0xc,%esp
  800143:	68 00 02 00 00       	push   $0x200
  800148:	6a 00                	push   $0x0
  80014a:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800150:	53                   	push   %ebx
  800151:	e8 95 0d 00 00       	call   800eeb <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800156:	83 c4 0c             	add    $0xc,%esp
  800159:	68 00 02 00 00       	push   $0x200
  80015e:	53                   	push   %ebx
  80015f:	68 00 c0 cc cc       	push   $0xccccc000
  800164:	ff 15 10 30 80 00    	call   *0x803010
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	85 c0                	test   %eax,%eax
  80016f:	0f 88 9d 03 00 00    	js     800512 <umain+0x494>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 35 00 30 80 00    	pushl  0x803000
  80017e:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 c6 0c 00 00       	call   800e50 <strcmp>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	85 c0                	test   %eax,%eax
  80018f:	0f 85 8f 03 00 00    	jne    800524 <umain+0x4a6>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 f7 23 80 00       	push   $0x8023f7
  80019d:	e8 1e 06 00 00       	call   8007c0 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a2:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001a9:	ff 15 18 30 80 00    	call   *0x803018
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	0f 88 7e 03 00 00    	js     800538 <umain+0x4ba>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 19 24 80 00       	push   $0x802419
  8001c2:	e8 f9 05 00 00       	call   8007c0 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8001c7:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001cf:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8001d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001d7:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8001dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001df:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8001e7:	83 c4 08             	add    $0x8,%esp
  8001ea:	68 00 c0 cc cc       	push   $0xccccc000
  8001ef:	6a 00                	push   $0x0
  8001f1:	e8 32 10 00 00       	call   801228 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	68 00 02 00 00       	push   $0x200
  8001fe:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	ff 15 10 30 80 00    	call   *0x803010
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800215:	0f 85 2f 03 00 00    	jne    80054a <umain+0x4cc>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	68 2d 24 80 00       	push   $0x80242d
  800223:	e8 98 05 00 00       	call   8007c0 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800228:	ba 02 01 00 00       	mov    $0x102,%edx
  80022d:	b8 43 24 80 00       	mov    $0x802443,%eax
  800232:	e8 fc fd ff ff       	call   800033 <xopen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	85 c0                	test   %eax,%eax
  80023c:	0f 88 1a 03 00 00    	js     80055c <umain+0x4de>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800242:	8b 1d 14 30 80 00    	mov    0x803014,%ebx
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 35 00 30 80 00    	pushl  0x803000
  800251:	e8 1d 0b 00 00       	call   800d73 <strlen>
  800256:	83 c4 0c             	add    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	ff 35 00 30 80 00    	pushl  0x803000
  800260:	68 00 c0 cc cc       	push   $0xccccc000
  800265:	ff d3                	call   *%ebx
  800267:	89 c3                	mov    %eax,%ebx
  800269:	83 c4 04             	add    $0x4,%esp
  80026c:	ff 35 00 30 80 00    	pushl  0x803000
  800272:	e8 fc 0a 00 00       	call   800d73 <strlen>
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	39 d8                	cmp    %ebx,%eax
  80027c:	0f 85 ec 02 00 00    	jne    80056e <umain+0x4f0>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	68 75 24 80 00       	push   $0x802475
  80028a:	e8 31 05 00 00       	call   8007c0 <cprintf>

	FVA->fd_offset = 0;
  80028f:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800296:	00 00 00 
	memset(buf, 0, sizeof buf);
  800299:	83 c4 0c             	add    $0xc,%esp
  80029c:	68 00 02 00 00       	push   $0x200
  8002a1:	6a 00                	push   $0x0
  8002a3:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002a9:	53                   	push   %ebx
  8002aa:	e8 3c 0c 00 00       	call   800eeb <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002af:	83 c4 0c             	add    $0xc,%esp
  8002b2:	68 00 02 00 00       	push   $0x200
  8002b7:	53                   	push   %ebx
  8002b8:	68 00 c0 cc cc       	push   $0xccccc000
  8002bd:	ff 15 10 30 80 00    	call   *0x803010
  8002c3:	89 c3                	mov    %eax,%ebx
  8002c5:	83 c4 10             	add    $0x10,%esp
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	0f 88 b0 02 00 00    	js     800580 <umain+0x502>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 35 00 30 80 00    	pushl  0x803000
  8002d9:	e8 95 0a 00 00       	call   800d73 <strlen>
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	39 d8                	cmp    %ebx,%eax
  8002e3:	0f 85 a9 02 00 00    	jne    800592 <umain+0x514>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	ff 35 00 30 80 00    	pushl  0x803000
  8002f2:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 52 0b 00 00       	call   800e50 <strcmp>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	85 c0                	test   %eax,%eax
  800303:	0f 85 9b 02 00 00    	jne    8005a4 <umain+0x526>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	68 3c 26 80 00       	push   $0x80263c
  800311:	e8 aa 04 00 00       	call   8007c0 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800316:	83 c4 08             	add    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 40 23 80 00       	push   $0x802340
  800320:	e8 22 18 00 00       	call   801b47 <open>
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80032b:	74 08                	je     800335 <umain+0x2b7>
  80032d:	85 c0                	test   %eax,%eax
  80032f:	0f 88 83 02 00 00    	js     8005b8 <umain+0x53a>
		panic("open /not-found: %e", r);
	else if (r >= 0)
  800335:	85 c0                	test   %eax,%eax
  800337:	0f 89 8d 02 00 00    	jns    8005ca <umain+0x54c>
		panic("open /not-found succeeded!");

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	6a 00                	push   $0x0
  800342:	68 75 23 80 00       	push   $0x802375
  800347:	e8 fb 17 00 00       	call   801b47 <open>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	85 c0                	test   %eax,%eax
  800351:	0f 88 87 02 00 00    	js     8005de <umain+0x560>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800357:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80035a:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800361:	0f 85 89 02 00 00    	jne    8005f0 <umain+0x572>
  800367:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80036e:	0f 85 7c 02 00 00    	jne    8005f0 <umain+0x572>
  800374:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  80037a:	85 db                	test   %ebx,%ebx
  80037c:	0f 85 6e 02 00 00    	jne    8005f0 <umain+0x572>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 9c 23 80 00       	push   $0x80239c
  80038a:	e8 31 04 00 00       	call   8007c0 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	68 01 01 00 00       	push   $0x101
  800397:	68 a4 24 80 00       	push   $0x8024a4
  80039c:	e8 a6 17 00 00       	call   801b47 <open>
  8003a1:	89 c7                	mov    %eax,%edi
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	85 c0                	test   %eax,%eax
  8003a8:	0f 88 56 02 00 00    	js     800604 <umain+0x586>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8003ae:	83 ec 04             	sub    $0x4,%esp
  8003b1:	68 00 02 00 00       	push   $0x200
  8003b6:	6a 00                	push   $0x0
  8003b8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003be:	50                   	push   %eax
  8003bf:	e8 27 0b 00 00       	call   800eeb <memset>
  8003c4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003c7:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8003c9:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 00 02 00 00       	push   $0x200
  8003d7:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003dd:	50                   	push   %eax
  8003de:	57                   	push   %edi
  8003df:	e8 cc 13 00 00       	call   8017b0 <write>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	0f 88 27 02 00 00    	js     800616 <umain+0x598>
  8003ef:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003f5:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  8003fb:	75 cc                	jne    8003c9 <umain+0x34b>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	57                   	push   %edi
  800401:	e8 a0 11 00 00       	call   8015a6 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  800406:	83 c4 08             	add    $0x8,%esp
  800409:	6a 00                	push   $0x0
  80040b:	68 a4 24 80 00       	push   $0x8024a4
  800410:	e8 32 17 00 00       	call   801b47 <open>
  800415:	89 c6                	mov    %eax,%esi
  800417:	83 c4 10             	add    $0x10,%esp
  80041a:	85 c0                	test   %eax,%eax
  80041c:	0f 88 0a 02 00 00    	js     80062c <umain+0x5ae>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800422:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  800428:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  80042e:	83 ec 04             	sub    $0x4,%esp
  800431:	68 00 02 00 00       	push   $0x200
  800436:	57                   	push   %edi
  800437:	56                   	push   %esi
  800438:	e8 2c 13 00 00       	call   801769 <readn>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	85 c0                	test   %eax,%eax
  800442:	0f 88 f6 01 00 00    	js     80063e <umain+0x5c0>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  800448:	3d 00 02 00 00       	cmp    $0x200,%eax
  80044d:	0f 85 01 02 00 00    	jne    800654 <umain+0x5d6>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800453:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  800459:	39 d8                	cmp    %ebx,%eax
  80045b:	0f 85 0e 02 00 00    	jne    80066f <umain+0x5f1>
  800461:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800467:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  80046d:	75 b9                	jne    800428 <umain+0x3aa>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	56                   	push   %esi
  800473:	e8 2e 11 00 00       	call   8015a6 <close>
	cprintf("large file is good\n");
  800478:	c7 04 24 e9 24 80 00 	movl   $0x8024e9,(%esp)
  80047f:	e8 3c 03 00 00       	call   8007c0 <cprintf>
}
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    
		panic("serve_open /not-found: %e", r);
  80048f:	50                   	push   %eax
  800490:	68 4b 23 80 00       	push   $0x80234b
  800495:	6a 20                	push   $0x20
  800497:	68 65 23 80 00       	push   $0x802365
  80049c:	e8 44 02 00 00       	call   8006e5 <_panic>
		panic("serve_open /not-found succeeded!");
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 00 25 80 00       	push   $0x802500
  8004a9:	6a 22                	push   $0x22
  8004ab:	68 65 23 80 00       	push   $0x802365
  8004b0:	e8 30 02 00 00       	call   8006e5 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004b5:	50                   	push   %eax
  8004b6:	68 7e 23 80 00       	push   $0x80237e
  8004bb:	6a 25                	push   $0x25
  8004bd:	68 65 23 80 00       	push   $0x802365
  8004c2:	e8 1e 02 00 00       	call   8006e5 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004c7:	83 ec 04             	sub    $0x4,%esp
  8004ca:	68 24 25 80 00       	push   $0x802524
  8004cf:	6a 27                	push   $0x27
  8004d1:	68 65 23 80 00       	push   $0x802365
  8004d6:	e8 0a 02 00 00       	call   8006e5 <_panic>
		panic("file_stat: %e", r);
  8004db:	50                   	push   %eax
  8004dc:	68 aa 23 80 00       	push   $0x8023aa
  8004e1:	6a 2b                	push   $0x2b
  8004e3:	68 65 23 80 00       	push   $0x802365
  8004e8:	e8 f8 01 00 00       	call   8006e5 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8004ed:	83 ec 0c             	sub    $0xc,%esp
  8004f0:	ff 35 00 30 80 00    	pushl  0x803000
  8004f6:	e8 78 08 00 00       	call   800d73 <strlen>
  8004fb:	89 04 24             	mov    %eax,(%esp)
  8004fe:	ff 75 cc             	pushl  -0x34(%ebp)
  800501:	68 54 25 80 00       	push   $0x802554
  800506:	6a 2d                	push   $0x2d
  800508:	68 65 23 80 00       	push   $0x802365
  80050d:	e8 d3 01 00 00       	call   8006e5 <_panic>
		panic("file_read: %e", r);
  800512:	50                   	push   %eax
  800513:	68 cb 23 80 00       	push   $0x8023cb
  800518:	6a 32                	push   $0x32
  80051a:	68 65 23 80 00       	push   $0x802365
  80051f:	e8 c1 01 00 00       	call   8006e5 <_panic>
		panic("file_read returned wrong data");
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	68 d9 23 80 00       	push   $0x8023d9
  80052c:	6a 34                	push   $0x34
  80052e:	68 65 23 80 00       	push   $0x802365
  800533:	e8 ad 01 00 00       	call   8006e5 <_panic>
		panic("file_close: %e", r);
  800538:	50                   	push   %eax
  800539:	68 0a 24 80 00       	push   $0x80240a
  80053e:	6a 38                	push   $0x38
  800540:	68 65 23 80 00       	push   $0x802365
  800545:	e8 9b 01 00 00       	call   8006e5 <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80054a:	50                   	push   %eax
  80054b:	68 7c 25 80 00       	push   $0x80257c
  800550:	6a 43                	push   $0x43
  800552:	68 65 23 80 00       	push   $0x802365
  800557:	e8 89 01 00 00       	call   8006e5 <_panic>
		panic("serve_open /new-file: %e", r);
  80055c:	50                   	push   %eax
  80055d:	68 4d 24 80 00       	push   $0x80244d
  800562:	6a 48                	push   $0x48
  800564:	68 65 23 80 00       	push   $0x802365
  800569:	e8 77 01 00 00       	call   8006e5 <_panic>
		panic("file_write: %e", r);
  80056e:	53                   	push   %ebx
  80056f:	68 66 24 80 00       	push   $0x802466
  800574:	6a 4b                	push   $0x4b
  800576:	68 65 23 80 00       	push   $0x802365
  80057b:	e8 65 01 00 00       	call   8006e5 <_panic>
		panic("file_read after file_write: %e", r);
  800580:	50                   	push   %eax
  800581:	68 b4 25 80 00       	push   $0x8025b4
  800586:	6a 51                	push   $0x51
  800588:	68 65 23 80 00       	push   $0x802365
  80058d:	e8 53 01 00 00       	call   8006e5 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  800592:	53                   	push   %ebx
  800593:	68 d4 25 80 00       	push   $0x8025d4
  800598:	6a 53                	push   $0x53
  80059a:	68 65 23 80 00       	push   $0x802365
  80059f:	e8 41 01 00 00       	call   8006e5 <_panic>
		panic("file_read after file_write returned wrong data");
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	68 0c 26 80 00       	push   $0x80260c
  8005ac:	6a 55                	push   $0x55
  8005ae:	68 65 23 80 00       	push   $0x802365
  8005b3:	e8 2d 01 00 00       	call   8006e5 <_panic>
		panic("open /not-found: %e", r);
  8005b8:	50                   	push   %eax
  8005b9:	68 51 23 80 00       	push   $0x802351
  8005be:	6a 5a                	push   $0x5a
  8005c0:	68 65 23 80 00       	push   $0x802365
  8005c5:	e8 1b 01 00 00       	call   8006e5 <_panic>
		panic("open /not-found succeeded!");
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	68 89 24 80 00       	push   $0x802489
  8005d2:	6a 5c                	push   $0x5c
  8005d4:	68 65 23 80 00       	push   $0x802365
  8005d9:	e8 07 01 00 00       	call   8006e5 <_panic>
		panic("open /newmotd: %e", r);
  8005de:	50                   	push   %eax
  8005df:	68 84 23 80 00       	push   $0x802384
  8005e4:	6a 5f                	push   $0x5f
  8005e6:	68 65 23 80 00       	push   $0x802365
  8005eb:	e8 f5 00 00 00       	call   8006e5 <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 60 26 80 00       	push   $0x802660
  8005f8:	6a 62                	push   $0x62
  8005fa:	68 65 23 80 00       	push   $0x802365
  8005ff:	e8 e1 00 00 00       	call   8006e5 <_panic>
		panic("creat /big: %e", f);
  800604:	50                   	push   %eax
  800605:	68 a9 24 80 00       	push   $0x8024a9
  80060a:	6a 67                	push   $0x67
  80060c:	68 65 23 80 00       	push   $0x802365
  800611:	e8 cf 00 00 00       	call   8006e5 <_panic>
			panic("write /big@%d: %e", i, r);
  800616:	83 ec 0c             	sub    $0xc,%esp
  800619:	50                   	push   %eax
  80061a:	56                   	push   %esi
  80061b:	68 b8 24 80 00       	push   $0x8024b8
  800620:	6a 6c                	push   $0x6c
  800622:	68 65 23 80 00       	push   $0x802365
  800627:	e8 b9 00 00 00       	call   8006e5 <_panic>
		panic("open /big: %e", f);
  80062c:	50                   	push   %eax
  80062d:	68 ca 24 80 00       	push   $0x8024ca
  800632:	6a 71                	push   $0x71
  800634:	68 65 23 80 00       	push   $0x802365
  800639:	e8 a7 00 00 00       	call   8006e5 <_panic>
			panic("read /big@%d: %e", i, r);
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	50                   	push   %eax
  800642:	53                   	push   %ebx
  800643:	68 d8 24 80 00       	push   $0x8024d8
  800648:	6a 75                	push   $0x75
  80064a:	68 65 23 80 00       	push   $0x802365
  80064f:	e8 91 00 00 00       	call   8006e5 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	68 00 02 00 00       	push   $0x200
  80065c:	50                   	push   %eax
  80065d:	53                   	push   %ebx
  80065e:	68 88 26 80 00       	push   $0x802688
  800663:	6a 78                	push   $0x78
  800665:	68 65 23 80 00       	push   $0x802365
  80066a:	e8 76 00 00 00       	call   8006e5 <_panic>
			panic("read /big from %d returned bad data %d",
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	50                   	push   %eax
  800673:	53                   	push   %ebx
  800674:	68 b4 26 80 00       	push   $0x8026b4
  800679:	6a 7b                	push   $0x7b
  80067b:	68 65 23 80 00       	push   $0x802365
  800680:	e8 60 00 00 00       	call   8006e5 <_panic>

00800685 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	56                   	push   %esi
  800689:	53                   	push   %ebx
  80068a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80068d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800690:	e8 d0 0a 00 00       	call   801165 <sys_getenvid>
  800695:	25 ff 03 00 00       	and    $0x3ff,%eax
  80069a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80069d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a2:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a7:	85 db                	test   %ebx,%ebx
  8006a9:	7e 07                	jle    8006b2 <libmain+0x2d>
		binaryname = argv[0];
  8006ab:	8b 06                	mov    (%esi),%eax
  8006ad:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	56                   	push   %esi
  8006b6:	53                   	push   %ebx
  8006b7:	e8 c2 f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  8006bc:	e8 0a 00 00 00       	call   8006cb <exit>
}
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006c7:	5b                   	pop    %ebx
  8006c8:	5e                   	pop    %esi
  8006c9:	5d                   	pop    %ebp
  8006ca:	c3                   	ret    

008006cb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8006d1:	e8 fb 0e 00 00       	call   8015d1 <close_all>
	sys_env_destroy(0);
  8006d6:	83 ec 0c             	sub    $0xc,%esp
  8006d9:	6a 00                	push   $0x0
  8006db:	e8 44 0a 00 00       	call   801124 <sys_env_destroy>
}
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	56                   	push   %esi
  8006e9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8006ea:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006ed:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8006f3:	e8 6d 0a 00 00       	call   801165 <sys_getenvid>
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	ff 75 08             	pushl  0x8(%ebp)
  800701:	56                   	push   %esi
  800702:	50                   	push   %eax
  800703:	68 0c 27 80 00       	push   $0x80270c
  800708:	e8 b3 00 00 00       	call   8007c0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80070d:	83 c4 18             	add    $0x18,%esp
  800710:	53                   	push   %ebx
  800711:	ff 75 10             	pushl  0x10(%ebp)
  800714:	e8 56 00 00 00       	call   80076f <vcprintf>
	cprintf("\n");
  800719:	c7 04 24 83 2b 80 00 	movl   $0x802b83,(%esp)
  800720:	e8 9b 00 00 00       	call   8007c0 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800728:	cc                   	int3   
  800729:	eb fd                	jmp    800728 <_panic+0x43>

0080072b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	53                   	push   %ebx
  80072f:	83 ec 04             	sub    $0x4,%esp
  800732:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800735:	8b 13                	mov    (%ebx),%edx
  800737:	8d 42 01             	lea    0x1(%edx),%eax
  80073a:	89 03                	mov    %eax,(%ebx)
  80073c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80073f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800743:	3d ff 00 00 00       	cmp    $0xff,%eax
  800748:	74 09                	je     800753 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80074a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80074e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800751:	c9                   	leave  
  800752:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	68 ff 00 00 00       	push   $0xff
  80075b:	8d 43 08             	lea    0x8(%ebx),%eax
  80075e:	50                   	push   %eax
  80075f:	e8 83 09 00 00       	call   8010e7 <sys_cputs>
		b->idx = 0;
  800764:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80076a:	83 c4 10             	add    $0x10,%esp
  80076d:	eb db                	jmp    80074a <putch+0x1f>

0080076f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800778:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80077f:	00 00 00 
	b.cnt = 0;
  800782:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800789:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800798:	50                   	push   %eax
  800799:	68 2b 07 80 00       	push   $0x80072b
  80079e:	e8 1a 01 00 00       	call   8008bd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8007a3:	83 c4 08             	add    $0x8,%esp
  8007a6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8007ac:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007b2:	50                   	push   %eax
  8007b3:	e8 2f 09 00 00       	call   8010e7 <sys_cputs>

	return b.cnt;
}
  8007b8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007c9:	50                   	push   %eax
  8007ca:	ff 75 08             	pushl  0x8(%ebp)
  8007cd:	e8 9d ff ff ff       	call   80076f <vcprintf>
	va_end(ap);

	return cnt;
}
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    

008007d4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	57                   	push   %edi
  8007d8:	56                   	push   %esi
  8007d9:	53                   	push   %ebx
  8007da:	83 ec 1c             	sub    $0x1c,%esp
  8007dd:	89 c7                	mov    %eax,%edi
  8007df:	89 d6                	mov    %edx,%esi
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007f8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8007fb:	39 d3                	cmp    %edx,%ebx
  8007fd:	72 05                	jb     800804 <printnum+0x30>
  8007ff:	39 45 10             	cmp    %eax,0x10(%ebp)
  800802:	77 7a                	ja     80087e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800804:	83 ec 0c             	sub    $0xc,%esp
  800807:	ff 75 18             	pushl  0x18(%ebp)
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800810:	53                   	push   %ebx
  800811:	ff 75 10             	pushl  0x10(%ebp)
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 e4             	pushl  -0x1c(%ebp)
  80081a:	ff 75 e0             	pushl  -0x20(%ebp)
  80081d:	ff 75 dc             	pushl  -0x24(%ebp)
  800820:	ff 75 d8             	pushl  -0x28(%ebp)
  800823:	e8 d8 18 00 00       	call   802100 <__udivdi3>
  800828:	83 c4 18             	add    $0x18,%esp
  80082b:	52                   	push   %edx
  80082c:	50                   	push   %eax
  80082d:	89 f2                	mov    %esi,%edx
  80082f:	89 f8                	mov    %edi,%eax
  800831:	e8 9e ff ff ff       	call   8007d4 <printnum>
  800836:	83 c4 20             	add    $0x20,%esp
  800839:	eb 13                	jmp    80084e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	56                   	push   %esi
  80083f:	ff 75 18             	pushl  0x18(%ebp)
  800842:	ff d7                	call   *%edi
  800844:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800847:	83 eb 01             	sub    $0x1,%ebx
  80084a:	85 db                	test   %ebx,%ebx
  80084c:	7f ed                	jg     80083b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	56                   	push   %esi
  800852:	83 ec 04             	sub    $0x4,%esp
  800855:	ff 75 e4             	pushl  -0x1c(%ebp)
  800858:	ff 75 e0             	pushl  -0x20(%ebp)
  80085b:	ff 75 dc             	pushl  -0x24(%ebp)
  80085e:	ff 75 d8             	pushl  -0x28(%ebp)
  800861:	e8 ba 19 00 00       	call   802220 <__umoddi3>
  800866:	83 c4 14             	add    $0x14,%esp
  800869:	0f be 80 2f 27 80 00 	movsbl 0x80272f(%eax),%eax
  800870:	50                   	push   %eax
  800871:	ff d7                	call   *%edi
}
  800873:	83 c4 10             	add    $0x10,%esp
  800876:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800879:	5b                   	pop    %ebx
  80087a:	5e                   	pop    %esi
  80087b:	5f                   	pop    %edi
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    
  80087e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800881:	eb c4                	jmp    800847 <printnum+0x73>

00800883 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
  800886:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800889:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80088d:	8b 10                	mov    (%eax),%edx
  80088f:	3b 50 04             	cmp    0x4(%eax),%edx
  800892:	73 0a                	jae    80089e <sprintputch+0x1b>
		*b->buf++ = ch;
  800894:	8d 4a 01             	lea    0x1(%edx),%ecx
  800897:	89 08                	mov    %ecx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	88 02                	mov    %al,(%edx)
}
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    

008008a0 <printfmt>:
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008a6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008a9:	50                   	push   %eax
  8008aa:	ff 75 10             	pushl  0x10(%ebp)
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	ff 75 08             	pushl  0x8(%ebp)
  8008b3:	e8 05 00 00 00       	call   8008bd <vprintfmt>
}
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	c9                   	leave  
  8008bc:	c3                   	ret    

008008bd <vprintfmt>:
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	57                   	push   %edi
  8008c1:	56                   	push   %esi
  8008c2:	53                   	push   %ebx
  8008c3:	83 ec 2c             	sub    $0x2c,%esp
  8008c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008cc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008cf:	e9 8c 03 00 00       	jmp    800c60 <vprintfmt+0x3a3>
		padc = ' ';
  8008d4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8008d8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8008df:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8008e6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008ed:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008f2:	8d 47 01             	lea    0x1(%edi),%eax
  8008f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f8:	0f b6 17             	movzbl (%edi),%edx
  8008fb:	8d 42 dd             	lea    -0x23(%edx),%eax
  8008fe:	3c 55                	cmp    $0x55,%al
  800900:	0f 87 dd 03 00 00    	ja     800ce3 <vprintfmt+0x426>
  800906:	0f b6 c0             	movzbl %al,%eax
  800909:	ff 24 85 80 28 80 00 	jmp    *0x802880(,%eax,4)
  800910:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800913:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800917:	eb d9                	jmp    8008f2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800919:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80091c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800920:	eb d0                	jmp    8008f2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800922:	0f b6 d2             	movzbl %dl,%edx
  800925:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800928:	b8 00 00 00 00       	mov    $0x0,%eax
  80092d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800930:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800933:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800937:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80093a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80093d:	83 f9 09             	cmp    $0x9,%ecx
  800940:	77 55                	ja     800997 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800942:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800945:	eb e9                	jmp    800930 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	8d 40 04             	lea    0x4(%eax),%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800958:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80095b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80095f:	79 91                	jns    8008f2 <vprintfmt+0x35>
				width = precision, precision = -1;
  800961:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800964:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800967:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80096e:	eb 82                	jmp    8008f2 <vprintfmt+0x35>
  800970:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800973:	85 c0                	test   %eax,%eax
  800975:	ba 00 00 00 00       	mov    $0x0,%edx
  80097a:	0f 49 d0             	cmovns %eax,%edx
  80097d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800980:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800983:	e9 6a ff ff ff       	jmp    8008f2 <vprintfmt+0x35>
  800988:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80098b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800992:	e9 5b ff ff ff       	jmp    8008f2 <vprintfmt+0x35>
  800997:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80099a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80099d:	eb bc                	jmp    80095b <vprintfmt+0x9e>
			lflag++;
  80099f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009a5:	e9 48 ff ff ff       	jmp    8008f2 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	8d 78 04             	lea    0x4(%eax),%edi
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	53                   	push   %ebx
  8009b4:	ff 30                	pushl  (%eax)
  8009b6:	ff d6                	call   *%esi
			break;
  8009b8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8009bb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8009be:	e9 9a 02 00 00       	jmp    800c5d <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8009c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c6:	8d 78 04             	lea    0x4(%eax),%edi
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	99                   	cltd   
  8009cc:	31 d0                	xor    %edx,%eax
  8009ce:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009d0:	83 f8 0f             	cmp    $0xf,%eax
  8009d3:	7f 23                	jg     8009f8 <vprintfmt+0x13b>
  8009d5:	8b 14 85 e0 29 80 00 	mov    0x8029e0(,%eax,4),%edx
  8009dc:	85 d2                	test   %edx,%edx
  8009de:	74 18                	je     8009f8 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8009e0:	52                   	push   %edx
  8009e1:	68 51 2b 80 00       	push   $0x802b51
  8009e6:	53                   	push   %ebx
  8009e7:	56                   	push   %esi
  8009e8:	e8 b3 fe ff ff       	call   8008a0 <printfmt>
  8009ed:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8009f0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8009f3:	e9 65 02 00 00       	jmp    800c5d <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8009f8:	50                   	push   %eax
  8009f9:	68 47 27 80 00       	push   $0x802747
  8009fe:	53                   	push   %ebx
  8009ff:	56                   	push   %esi
  800a00:	e8 9b fe ff ff       	call   8008a0 <printfmt>
  800a05:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a08:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a0b:	e9 4d 02 00 00       	jmp    800c5d <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	83 c0 04             	add    $0x4,%eax
  800a16:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800a1e:	85 ff                	test   %edi,%edi
  800a20:	b8 40 27 80 00       	mov    $0x802740,%eax
  800a25:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2c:	0f 8e bd 00 00 00    	jle    800aef <vprintfmt+0x232>
  800a32:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800a36:	75 0e                	jne    800a46 <vprintfmt+0x189>
  800a38:	89 75 08             	mov    %esi,0x8(%ebp)
  800a3b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a3e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a41:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a44:	eb 6d                	jmp    800ab3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 d0             	pushl  -0x30(%ebp)
  800a4c:	57                   	push   %edi
  800a4d:	e8 39 03 00 00       	call   800d8b <strnlen>
  800a52:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a55:	29 c1                	sub    %eax,%ecx
  800a57:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800a5a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800a5d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800a61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a64:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800a67:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a69:	eb 0f                	jmp    800a7a <vprintfmt+0x1bd>
					putch(padc, putdat);
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	53                   	push   %ebx
  800a6f:	ff 75 e0             	pushl  -0x20(%ebp)
  800a72:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a74:	83 ef 01             	sub    $0x1,%edi
  800a77:	83 c4 10             	add    $0x10,%esp
  800a7a:	85 ff                	test   %edi,%edi
  800a7c:	7f ed                	jg     800a6b <vprintfmt+0x1ae>
  800a7e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800a81:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800a84:	85 c9                	test   %ecx,%ecx
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8b:	0f 49 c1             	cmovns %ecx,%eax
  800a8e:	29 c1                	sub    %eax,%ecx
  800a90:	89 75 08             	mov    %esi,0x8(%ebp)
  800a93:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a96:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a99:	89 cb                	mov    %ecx,%ebx
  800a9b:	eb 16                	jmp    800ab3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800a9d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800aa1:	75 31                	jne    800ad4 <vprintfmt+0x217>
					putch(ch, putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	50                   	push   %eax
  800aaa:	ff 55 08             	call   *0x8(%ebp)
  800aad:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab0:	83 eb 01             	sub    $0x1,%ebx
  800ab3:	83 c7 01             	add    $0x1,%edi
  800ab6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800aba:	0f be c2             	movsbl %dl,%eax
  800abd:	85 c0                	test   %eax,%eax
  800abf:	74 59                	je     800b1a <vprintfmt+0x25d>
  800ac1:	85 f6                	test   %esi,%esi
  800ac3:	78 d8                	js     800a9d <vprintfmt+0x1e0>
  800ac5:	83 ee 01             	sub    $0x1,%esi
  800ac8:	79 d3                	jns    800a9d <vprintfmt+0x1e0>
  800aca:	89 df                	mov    %ebx,%edi
  800acc:	8b 75 08             	mov    0x8(%ebp),%esi
  800acf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ad2:	eb 37                	jmp    800b0b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800ad4:	0f be d2             	movsbl %dl,%edx
  800ad7:	83 ea 20             	sub    $0x20,%edx
  800ada:	83 fa 5e             	cmp    $0x5e,%edx
  800add:	76 c4                	jbe    800aa3 <vprintfmt+0x1e6>
					putch('?', putdat);
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	6a 3f                	push   $0x3f
  800ae7:	ff 55 08             	call   *0x8(%ebp)
  800aea:	83 c4 10             	add    $0x10,%esp
  800aed:	eb c1                	jmp    800ab0 <vprintfmt+0x1f3>
  800aef:	89 75 08             	mov    %esi,0x8(%ebp)
  800af2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800af5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800af8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800afb:	eb b6                	jmp    800ab3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800afd:	83 ec 08             	sub    $0x8,%esp
  800b00:	53                   	push   %ebx
  800b01:	6a 20                	push   $0x20
  800b03:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b05:	83 ef 01             	sub    $0x1,%edi
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	85 ff                	test   %edi,%edi
  800b0d:	7f ee                	jg     800afd <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800b0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	e9 43 01 00 00       	jmp    800c5d <vprintfmt+0x3a0>
  800b1a:	89 df                	mov    %ebx,%edi
  800b1c:	8b 75 08             	mov    0x8(%ebp),%esi
  800b1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b22:	eb e7                	jmp    800b0b <vprintfmt+0x24e>
	if (lflag >= 2)
  800b24:	83 f9 01             	cmp    $0x1,%ecx
  800b27:	7e 3f                	jle    800b68 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800b29:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2c:	8b 50 04             	mov    0x4(%eax),%edx
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b34:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b37:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3a:	8d 40 08             	lea    0x8(%eax),%eax
  800b3d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800b40:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b44:	79 5c                	jns    800ba2 <vprintfmt+0x2e5>
				putch('-', putdat);
  800b46:	83 ec 08             	sub    $0x8,%esp
  800b49:	53                   	push   %ebx
  800b4a:	6a 2d                	push   $0x2d
  800b4c:	ff d6                	call   *%esi
				num = -(long long) num;
  800b4e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b51:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b54:	f7 da                	neg    %edx
  800b56:	83 d1 00             	adc    $0x0,%ecx
  800b59:	f7 d9                	neg    %ecx
  800b5b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b5e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b63:	e9 db 00 00 00       	jmp    800c43 <vprintfmt+0x386>
	else if (lflag)
  800b68:	85 c9                	test   %ecx,%ecx
  800b6a:	75 1b                	jne    800b87 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800b6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b74:	89 c1                	mov    %eax,%ecx
  800b76:	c1 f9 1f             	sar    $0x1f,%ecx
  800b79:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7f:	8d 40 04             	lea    0x4(%eax),%eax
  800b82:	89 45 14             	mov    %eax,0x14(%ebp)
  800b85:	eb b9                	jmp    800b40 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800b87:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8a:	8b 00                	mov    (%eax),%eax
  800b8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b8f:	89 c1                	mov    %eax,%ecx
  800b91:	c1 f9 1f             	sar    $0x1f,%ecx
  800b94:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b97:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9a:	8d 40 04             	lea    0x4(%eax),%eax
  800b9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba0:	eb 9e                	jmp    800b40 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800ba2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ba5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800ba8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bad:	e9 91 00 00 00       	jmp    800c43 <vprintfmt+0x386>
	if (lflag >= 2)
  800bb2:	83 f9 01             	cmp    $0x1,%ecx
  800bb5:	7e 15                	jle    800bcc <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bba:	8b 10                	mov    (%eax),%edx
  800bbc:	8b 48 04             	mov    0x4(%eax),%ecx
  800bbf:	8d 40 08             	lea    0x8(%eax),%eax
  800bc2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bc5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bca:	eb 77                	jmp    800c43 <vprintfmt+0x386>
	else if (lflag)
  800bcc:	85 c9                	test   %ecx,%ecx
  800bce:	75 17                	jne    800be7 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800bd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd3:	8b 10                	mov    (%eax),%edx
  800bd5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bda:	8d 40 04             	lea    0x4(%eax),%eax
  800bdd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800be0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be5:	eb 5c                	jmp    800c43 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800be7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bea:	8b 10                	mov    (%eax),%edx
  800bec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf1:	8d 40 04             	lea    0x4(%eax),%eax
  800bf4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bf7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfc:	eb 45                	jmp    800c43 <vprintfmt+0x386>
			putch('X', putdat);
  800bfe:	83 ec 08             	sub    $0x8,%esp
  800c01:	53                   	push   %ebx
  800c02:	6a 58                	push   $0x58
  800c04:	ff d6                	call   *%esi
			putch('X', putdat);
  800c06:	83 c4 08             	add    $0x8,%esp
  800c09:	53                   	push   %ebx
  800c0a:	6a 58                	push   $0x58
  800c0c:	ff d6                	call   *%esi
			putch('X', putdat);
  800c0e:	83 c4 08             	add    $0x8,%esp
  800c11:	53                   	push   %ebx
  800c12:	6a 58                	push   $0x58
  800c14:	ff d6                	call   *%esi
			break;
  800c16:	83 c4 10             	add    $0x10,%esp
  800c19:	eb 42                	jmp    800c5d <vprintfmt+0x3a0>
			putch('0', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	53                   	push   %ebx
  800c1f:	6a 30                	push   $0x30
  800c21:	ff d6                	call   *%esi
			putch('x', putdat);
  800c23:	83 c4 08             	add    $0x8,%esp
  800c26:	53                   	push   %ebx
  800c27:	6a 78                	push   $0x78
  800c29:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2e:	8b 10                	mov    (%eax),%edx
  800c30:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800c35:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c38:	8d 40 04             	lea    0x4(%eax),%eax
  800c3b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c3e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800c43:	83 ec 0c             	sub    $0xc,%esp
  800c46:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800c4a:	57                   	push   %edi
  800c4b:	ff 75 e0             	pushl  -0x20(%ebp)
  800c4e:	50                   	push   %eax
  800c4f:	51                   	push   %ecx
  800c50:	52                   	push   %edx
  800c51:	89 da                	mov    %ebx,%edx
  800c53:	89 f0                	mov    %esi,%eax
  800c55:	e8 7a fb ff ff       	call   8007d4 <printnum>
			break;
  800c5a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800c5d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c60:	83 c7 01             	add    $0x1,%edi
  800c63:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c67:	83 f8 25             	cmp    $0x25,%eax
  800c6a:	0f 84 64 fc ff ff    	je     8008d4 <vprintfmt+0x17>
			if (ch == '\0')
  800c70:	85 c0                	test   %eax,%eax
  800c72:	0f 84 8b 00 00 00    	je     800d03 <vprintfmt+0x446>
			putch(ch, putdat);
  800c78:	83 ec 08             	sub    $0x8,%esp
  800c7b:	53                   	push   %ebx
  800c7c:	50                   	push   %eax
  800c7d:	ff d6                	call   *%esi
  800c7f:	83 c4 10             	add    $0x10,%esp
  800c82:	eb dc                	jmp    800c60 <vprintfmt+0x3a3>
	if (lflag >= 2)
  800c84:	83 f9 01             	cmp    $0x1,%ecx
  800c87:	7e 15                	jle    800c9e <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  800c89:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8c:	8b 10                	mov    (%eax),%edx
  800c8e:	8b 48 04             	mov    0x4(%eax),%ecx
  800c91:	8d 40 08             	lea    0x8(%eax),%eax
  800c94:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c97:	b8 10 00 00 00       	mov    $0x10,%eax
  800c9c:	eb a5                	jmp    800c43 <vprintfmt+0x386>
	else if (lflag)
  800c9e:	85 c9                	test   %ecx,%ecx
  800ca0:	75 17                	jne    800cb9 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca5:	8b 10                	mov    (%eax),%edx
  800ca7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cac:	8d 40 04             	lea    0x4(%eax),%eax
  800caf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cb2:	b8 10 00 00 00       	mov    $0x10,%eax
  800cb7:	eb 8a                	jmp    800c43 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800cb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbc:	8b 10                	mov    (%eax),%edx
  800cbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc3:	8d 40 04             	lea    0x4(%eax),%eax
  800cc6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cc9:	b8 10 00 00 00       	mov    $0x10,%eax
  800cce:	e9 70 ff ff ff       	jmp    800c43 <vprintfmt+0x386>
			putch(ch, putdat);
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	53                   	push   %ebx
  800cd7:	6a 25                	push   $0x25
  800cd9:	ff d6                	call   *%esi
			break;
  800cdb:	83 c4 10             	add    $0x10,%esp
  800cde:	e9 7a ff ff ff       	jmp    800c5d <vprintfmt+0x3a0>
			putch('%', putdat);
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	53                   	push   %ebx
  800ce7:	6a 25                	push   $0x25
  800ce9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ceb:	83 c4 10             	add    $0x10,%esp
  800cee:	89 f8                	mov    %edi,%eax
  800cf0:	eb 03                	jmp    800cf5 <vprintfmt+0x438>
  800cf2:	83 e8 01             	sub    $0x1,%eax
  800cf5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800cf9:	75 f7                	jne    800cf2 <vprintfmt+0x435>
  800cfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cfe:	e9 5a ff ff ff       	jmp    800c5d <vprintfmt+0x3a0>
}
  800d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5f                   	pop    %edi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	83 ec 18             	sub    $0x18,%esp
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d17:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d1a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d1e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d28:	85 c0                	test   %eax,%eax
  800d2a:	74 26                	je     800d52 <vsnprintf+0x47>
  800d2c:	85 d2                	test   %edx,%edx
  800d2e:	7e 22                	jle    800d52 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d30:	ff 75 14             	pushl  0x14(%ebp)
  800d33:	ff 75 10             	pushl  0x10(%ebp)
  800d36:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d39:	50                   	push   %eax
  800d3a:	68 83 08 80 00       	push   $0x800883
  800d3f:	e8 79 fb ff ff       	call   8008bd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d47:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d4d:	83 c4 10             	add    $0x10,%esp
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    
		return -E_INVAL;
  800d52:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d57:	eb f7                	jmp    800d50 <vsnprintf+0x45>

00800d59 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d5f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d62:	50                   	push   %eax
  800d63:	ff 75 10             	pushl  0x10(%ebp)
  800d66:	ff 75 0c             	pushl  0xc(%ebp)
  800d69:	ff 75 08             	pushl  0x8(%ebp)
  800d6c:	e8 9a ff ff ff       	call   800d0b <vsnprintf>
	va_end(ap);

	return rc;
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d79:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7e:	eb 03                	jmp    800d83 <strlen+0x10>
		n++;
  800d80:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800d83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d87:	75 f7                	jne    800d80 <strlen+0xd>
	return n;
}
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d91:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	eb 03                	jmp    800d9e <strnlen+0x13>
		n++;
  800d9b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d9e:	39 d0                	cmp    %edx,%eax
  800da0:	74 06                	je     800da8 <strnlen+0x1d>
  800da2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800da6:	75 f3                	jne    800d9b <strnlen+0x10>
	return n;
}
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	53                   	push   %ebx
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800db4:	89 c2                	mov    %eax,%edx
  800db6:	83 c1 01             	add    $0x1,%ecx
  800db9:	83 c2 01             	add    $0x1,%edx
  800dbc:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800dc0:	88 5a ff             	mov    %bl,-0x1(%edx)
  800dc3:	84 db                	test   %bl,%bl
  800dc5:	75 ef                	jne    800db6 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800dc7:	5b                   	pop    %ebx
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <strcat>:

char *
strcat(char *dst, const char *src)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	53                   	push   %ebx
  800dce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800dd1:	53                   	push   %ebx
  800dd2:	e8 9c ff ff ff       	call   800d73 <strlen>
  800dd7:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800dda:	ff 75 0c             	pushl  0xc(%ebp)
  800ddd:	01 d8                	add    %ebx,%eax
  800ddf:	50                   	push   %eax
  800de0:	e8 c5 ff ff ff       	call   800daa <strcpy>
	return dst;
}
  800de5:	89 d8                	mov    %ebx,%eax
  800de7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	56                   	push   %esi
  800df0:	53                   	push   %ebx
  800df1:	8b 75 08             	mov    0x8(%ebp),%esi
  800df4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df7:	89 f3                	mov    %esi,%ebx
  800df9:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dfc:	89 f2                	mov    %esi,%edx
  800dfe:	eb 0f                	jmp    800e0f <strncpy+0x23>
		*dst++ = *src;
  800e00:	83 c2 01             	add    $0x1,%edx
  800e03:	0f b6 01             	movzbl (%ecx),%eax
  800e06:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e09:	80 39 01             	cmpb   $0x1,(%ecx)
  800e0c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800e0f:	39 da                	cmp    %ebx,%edx
  800e11:	75 ed                	jne    800e00 <strncpy+0x14>
	}
	return ret;
}
  800e13:	89 f0                	mov    %esi,%eax
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    

00800e19 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	56                   	push   %esi
  800e1d:	53                   	push   %ebx
  800e1e:	8b 75 08             	mov    0x8(%ebp),%esi
  800e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800e27:	89 f0                	mov    %esi,%eax
  800e29:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e2d:	85 c9                	test   %ecx,%ecx
  800e2f:	75 0b                	jne    800e3c <strlcpy+0x23>
  800e31:	eb 17                	jmp    800e4a <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800e33:	83 c2 01             	add    $0x1,%edx
  800e36:	83 c0 01             	add    $0x1,%eax
  800e39:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800e3c:	39 d8                	cmp    %ebx,%eax
  800e3e:	74 07                	je     800e47 <strlcpy+0x2e>
  800e40:	0f b6 0a             	movzbl (%edx),%ecx
  800e43:	84 c9                	test   %cl,%cl
  800e45:	75 ec                	jne    800e33 <strlcpy+0x1a>
		*dst = '\0';
  800e47:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e4a:	29 f0                	sub    %esi,%eax
}
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e59:	eb 06                	jmp    800e61 <strcmp+0x11>
		p++, q++;
  800e5b:	83 c1 01             	add    $0x1,%ecx
  800e5e:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800e61:	0f b6 01             	movzbl (%ecx),%eax
  800e64:	84 c0                	test   %al,%al
  800e66:	74 04                	je     800e6c <strcmp+0x1c>
  800e68:	3a 02                	cmp    (%edx),%al
  800e6a:	74 ef                	je     800e5b <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e6c:	0f b6 c0             	movzbl %al,%eax
  800e6f:	0f b6 12             	movzbl (%edx),%edx
  800e72:	29 d0                	sub    %edx,%eax
}
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	53                   	push   %ebx
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e80:	89 c3                	mov    %eax,%ebx
  800e82:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e85:	eb 06                	jmp    800e8d <strncmp+0x17>
		n--, p++, q++;
  800e87:	83 c0 01             	add    $0x1,%eax
  800e8a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e8d:	39 d8                	cmp    %ebx,%eax
  800e8f:	74 16                	je     800ea7 <strncmp+0x31>
  800e91:	0f b6 08             	movzbl (%eax),%ecx
  800e94:	84 c9                	test   %cl,%cl
  800e96:	74 04                	je     800e9c <strncmp+0x26>
  800e98:	3a 0a                	cmp    (%edx),%cl
  800e9a:	74 eb                	je     800e87 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e9c:	0f b6 00             	movzbl (%eax),%eax
  800e9f:	0f b6 12             	movzbl (%edx),%edx
  800ea2:	29 d0                	sub    %edx,%eax
}
  800ea4:	5b                   	pop    %ebx
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    
		return 0;
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eac:	eb f6                	jmp    800ea4 <strncmp+0x2e>

00800eae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800eb8:	0f b6 10             	movzbl (%eax),%edx
  800ebb:	84 d2                	test   %dl,%dl
  800ebd:	74 09                	je     800ec8 <strchr+0x1a>
		if (*s == c)
  800ebf:	38 ca                	cmp    %cl,%dl
  800ec1:	74 0a                	je     800ecd <strchr+0x1f>
	for (; *s; s++)
  800ec3:	83 c0 01             	add    $0x1,%eax
  800ec6:	eb f0                	jmp    800eb8 <strchr+0xa>
			return (char *) s;
	return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecd:	5d                   	pop    %ebp
  800ece:	c3                   	ret    

00800ecf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ed9:	eb 03                	jmp    800ede <strfind+0xf>
  800edb:	83 c0 01             	add    $0x1,%eax
  800ede:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ee1:	38 ca                	cmp    %cl,%dl
  800ee3:	74 04                	je     800ee9 <strfind+0x1a>
  800ee5:	84 d2                	test   %dl,%dl
  800ee7:	75 f2                	jne    800edb <strfind+0xc>
			break;
	return (char *) s;
}
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    

00800eeb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
  800ef1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ef4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ef7:	85 c9                	test   %ecx,%ecx
  800ef9:	74 13                	je     800f0e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800efb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f01:	75 05                	jne    800f08 <memset+0x1d>
  800f03:	f6 c1 03             	test   $0x3,%cl
  800f06:	74 0d                	je     800f15 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	fc                   	cld    
  800f0c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f0e:	89 f8                	mov    %edi,%eax
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5f                   	pop    %edi
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    
		c &= 0xFF;
  800f15:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f19:	89 d3                	mov    %edx,%ebx
  800f1b:	c1 e3 08             	shl    $0x8,%ebx
  800f1e:	89 d0                	mov    %edx,%eax
  800f20:	c1 e0 18             	shl    $0x18,%eax
  800f23:	89 d6                	mov    %edx,%esi
  800f25:	c1 e6 10             	shl    $0x10,%esi
  800f28:	09 f0                	or     %esi,%eax
  800f2a:	09 c2                	or     %eax,%edx
  800f2c:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800f2e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f31:	89 d0                	mov    %edx,%eax
  800f33:	fc                   	cld    
  800f34:	f3 ab                	rep stos %eax,%es:(%edi)
  800f36:	eb d6                	jmp    800f0e <memset+0x23>

00800f38 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	57                   	push   %edi
  800f3c:	56                   	push   %esi
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f43:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f46:	39 c6                	cmp    %eax,%esi
  800f48:	73 35                	jae    800f7f <memmove+0x47>
  800f4a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f4d:	39 c2                	cmp    %eax,%edx
  800f4f:	76 2e                	jbe    800f7f <memmove+0x47>
		s += n;
		d += n;
  800f51:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f54:	89 d6                	mov    %edx,%esi
  800f56:	09 fe                	or     %edi,%esi
  800f58:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f5e:	74 0c                	je     800f6c <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f60:	83 ef 01             	sub    $0x1,%edi
  800f63:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f66:	fd                   	std    
  800f67:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f69:	fc                   	cld    
  800f6a:	eb 21                	jmp    800f8d <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f6c:	f6 c1 03             	test   $0x3,%cl
  800f6f:	75 ef                	jne    800f60 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f71:	83 ef 04             	sub    $0x4,%edi
  800f74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f77:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f7a:	fd                   	std    
  800f7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f7d:	eb ea                	jmp    800f69 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f7f:	89 f2                	mov    %esi,%edx
  800f81:	09 c2                	or     %eax,%edx
  800f83:	f6 c2 03             	test   $0x3,%dl
  800f86:	74 09                	je     800f91 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f88:	89 c7                	mov    %eax,%edi
  800f8a:	fc                   	cld    
  800f8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f91:	f6 c1 03             	test   $0x3,%cl
  800f94:	75 f2                	jne    800f88 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f96:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f99:	89 c7                	mov    %eax,%edi
  800f9b:	fc                   	cld    
  800f9c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f9e:	eb ed                	jmp    800f8d <memmove+0x55>

00800fa0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800fa3:	ff 75 10             	pushl  0x10(%ebp)
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	ff 75 08             	pushl  0x8(%ebp)
  800fac:	e8 87 ff ff ff       	call   800f38 <memmove>
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	56                   	push   %esi
  800fb7:	53                   	push   %ebx
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbe:	89 c6                	mov    %eax,%esi
  800fc0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800fc3:	39 f0                	cmp    %esi,%eax
  800fc5:	74 1c                	je     800fe3 <memcmp+0x30>
		if (*s1 != *s2)
  800fc7:	0f b6 08             	movzbl (%eax),%ecx
  800fca:	0f b6 1a             	movzbl (%edx),%ebx
  800fcd:	38 d9                	cmp    %bl,%cl
  800fcf:	75 08                	jne    800fd9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800fd1:	83 c0 01             	add    $0x1,%eax
  800fd4:	83 c2 01             	add    $0x1,%edx
  800fd7:	eb ea                	jmp    800fc3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800fd9:	0f b6 c1             	movzbl %cl,%eax
  800fdc:	0f b6 db             	movzbl %bl,%ebx
  800fdf:	29 d8                	sub    %ebx,%eax
  800fe1:	eb 05                	jmp    800fe8 <memcmp+0x35>
	}

	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe8:	5b                   	pop    %ebx
  800fe9:	5e                   	pop    %esi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ff5:	89 c2                	mov    %eax,%edx
  800ff7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ffa:	39 d0                	cmp    %edx,%eax
  800ffc:	73 09                	jae    801007 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ffe:	38 08                	cmp    %cl,(%eax)
  801000:	74 05                	je     801007 <memfind+0x1b>
	for (; s < ends; s++)
  801002:	83 c0 01             	add    $0x1,%eax
  801005:	eb f3                	jmp    800ffa <memfind+0xe>
			break;
	return (void *) s;
}
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	57                   	push   %edi
  80100d:	56                   	push   %esi
  80100e:	53                   	push   %ebx
  80100f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801012:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801015:	eb 03                	jmp    80101a <strtol+0x11>
		s++;
  801017:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80101a:	0f b6 01             	movzbl (%ecx),%eax
  80101d:	3c 20                	cmp    $0x20,%al
  80101f:	74 f6                	je     801017 <strtol+0xe>
  801021:	3c 09                	cmp    $0x9,%al
  801023:	74 f2                	je     801017 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801025:	3c 2b                	cmp    $0x2b,%al
  801027:	74 2e                	je     801057 <strtol+0x4e>
	int neg = 0;
  801029:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80102e:	3c 2d                	cmp    $0x2d,%al
  801030:	74 2f                	je     801061 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801032:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801038:	75 05                	jne    80103f <strtol+0x36>
  80103a:	80 39 30             	cmpb   $0x30,(%ecx)
  80103d:	74 2c                	je     80106b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80103f:	85 db                	test   %ebx,%ebx
  801041:	75 0a                	jne    80104d <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801043:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801048:	80 39 30             	cmpb   $0x30,(%ecx)
  80104b:	74 28                	je     801075 <strtol+0x6c>
		base = 10;
  80104d:	b8 00 00 00 00       	mov    $0x0,%eax
  801052:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801055:	eb 50                	jmp    8010a7 <strtol+0x9e>
		s++;
  801057:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  80105a:	bf 00 00 00 00       	mov    $0x0,%edi
  80105f:	eb d1                	jmp    801032 <strtol+0x29>
		s++, neg = 1;
  801061:	83 c1 01             	add    $0x1,%ecx
  801064:	bf 01 00 00 00       	mov    $0x1,%edi
  801069:	eb c7                	jmp    801032 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80106b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80106f:	74 0e                	je     80107f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801071:	85 db                	test   %ebx,%ebx
  801073:	75 d8                	jne    80104d <strtol+0x44>
		s++, base = 8;
  801075:	83 c1 01             	add    $0x1,%ecx
  801078:	bb 08 00 00 00       	mov    $0x8,%ebx
  80107d:	eb ce                	jmp    80104d <strtol+0x44>
		s += 2, base = 16;
  80107f:	83 c1 02             	add    $0x2,%ecx
  801082:	bb 10 00 00 00       	mov    $0x10,%ebx
  801087:	eb c4                	jmp    80104d <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801089:	8d 72 9f             	lea    -0x61(%edx),%esi
  80108c:	89 f3                	mov    %esi,%ebx
  80108e:	80 fb 19             	cmp    $0x19,%bl
  801091:	77 29                	ja     8010bc <strtol+0xb3>
			dig = *s - 'a' + 10;
  801093:	0f be d2             	movsbl %dl,%edx
  801096:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801099:	3b 55 10             	cmp    0x10(%ebp),%edx
  80109c:	7d 30                	jge    8010ce <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80109e:	83 c1 01             	add    $0x1,%ecx
  8010a1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010a5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8010a7:	0f b6 11             	movzbl (%ecx),%edx
  8010aa:	8d 72 d0             	lea    -0x30(%edx),%esi
  8010ad:	89 f3                	mov    %esi,%ebx
  8010af:	80 fb 09             	cmp    $0x9,%bl
  8010b2:	77 d5                	ja     801089 <strtol+0x80>
			dig = *s - '0';
  8010b4:	0f be d2             	movsbl %dl,%edx
  8010b7:	83 ea 30             	sub    $0x30,%edx
  8010ba:	eb dd                	jmp    801099 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  8010bc:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010bf:	89 f3                	mov    %esi,%ebx
  8010c1:	80 fb 19             	cmp    $0x19,%bl
  8010c4:	77 08                	ja     8010ce <strtol+0xc5>
			dig = *s - 'A' + 10;
  8010c6:	0f be d2             	movsbl %dl,%edx
  8010c9:	83 ea 37             	sub    $0x37,%edx
  8010cc:	eb cb                	jmp    801099 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d2:	74 05                	je     8010d9 <strtol+0xd0>
		*endptr = (char *) s;
  8010d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010d7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010d9:	89 c2                	mov    %eax,%edx
  8010db:	f7 da                	neg    %edx
  8010dd:	85 ff                	test   %edi,%edi
  8010df:	0f 45 c2             	cmovne %edx,%eax
}
  8010e2:	5b                   	pop    %ebx
  8010e3:	5e                   	pop    %esi
  8010e4:	5f                   	pop    %edi
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    

008010e7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	57                   	push   %edi
  8010eb:	56                   	push   %esi
  8010ec:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f8:	89 c3                	mov    %eax,%ebx
  8010fa:	89 c7                	mov    %eax,%edi
  8010fc:	89 c6                	mov    %eax,%esi
  8010fe:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801100:	5b                   	pop    %ebx
  801101:	5e                   	pop    %esi
  801102:	5f                   	pop    %edi
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    

00801105 <sys_cgetc>:

int
sys_cgetc(void)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	57                   	push   %edi
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110b:	ba 00 00 00 00       	mov    $0x0,%edx
  801110:	b8 01 00 00 00       	mov    $0x1,%eax
  801115:	89 d1                	mov    %edx,%ecx
  801117:	89 d3                	mov    %edx,%ebx
  801119:	89 d7                	mov    %edx,%edi
  80111b:	89 d6                	mov    %edx,%esi
  80111d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80111f:	5b                   	pop    %ebx
  801120:	5e                   	pop    %esi
  801121:	5f                   	pop    %edi
  801122:	5d                   	pop    %ebp
  801123:	c3                   	ret    

00801124 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	57                   	push   %edi
  801128:	56                   	push   %esi
  801129:	53                   	push   %ebx
  80112a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80112d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801132:	8b 55 08             	mov    0x8(%ebp),%edx
  801135:	b8 03 00 00 00       	mov    $0x3,%eax
  80113a:	89 cb                	mov    %ecx,%ebx
  80113c:	89 cf                	mov    %ecx,%edi
  80113e:	89 ce                	mov    %ecx,%esi
  801140:	cd 30                	int    $0x30
	if(check && ret > 0)
  801142:	85 c0                	test   %eax,%eax
  801144:	7f 08                	jg     80114e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801146:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801149:	5b                   	pop    %ebx
  80114a:	5e                   	pop    %esi
  80114b:	5f                   	pop    %edi
  80114c:	5d                   	pop    %ebp
  80114d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114e:	83 ec 0c             	sub    $0xc,%esp
  801151:	50                   	push   %eax
  801152:	6a 03                	push   $0x3
  801154:	68 3f 2a 80 00       	push   $0x802a3f
  801159:	6a 23                	push   $0x23
  80115b:	68 5c 2a 80 00       	push   $0x802a5c
  801160:	e8 80 f5 ff ff       	call   8006e5 <_panic>

00801165 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	57                   	push   %edi
  801169:	56                   	push   %esi
  80116a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80116b:	ba 00 00 00 00       	mov    $0x0,%edx
  801170:	b8 02 00 00 00       	mov    $0x2,%eax
  801175:	89 d1                	mov    %edx,%ecx
  801177:	89 d3                	mov    %edx,%ebx
  801179:	89 d7                	mov    %edx,%edi
  80117b:	89 d6                	mov    %edx,%esi
  80117d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80117f:	5b                   	pop    %ebx
  801180:	5e                   	pop    %esi
  801181:	5f                   	pop    %edi
  801182:	5d                   	pop    %ebp
  801183:	c3                   	ret    

00801184 <sys_yield>:

void
sys_yield(void)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	57                   	push   %edi
  801188:	56                   	push   %esi
  801189:	53                   	push   %ebx
	asm volatile("int %1\n"
  80118a:	ba 00 00 00 00       	mov    $0x0,%edx
  80118f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801194:	89 d1                	mov    %edx,%ecx
  801196:	89 d3                	mov    %edx,%ebx
  801198:	89 d7                	mov    %edx,%edi
  80119a:	89 d6                	mov    %edx,%esi
  80119c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80119e:	5b                   	pop    %ebx
  80119f:	5e                   	pop    %esi
  8011a0:	5f                   	pop    %edi
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	57                   	push   %edi
  8011a7:	56                   	push   %esi
  8011a8:	53                   	push   %ebx
  8011a9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ac:	be 00 00 00 00       	mov    $0x0,%esi
  8011b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b7:	b8 04 00 00 00       	mov    $0x4,%eax
  8011bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011bf:	89 f7                	mov    %esi,%edi
  8011c1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	7f 08                	jg     8011cf <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ca:	5b                   	pop    %ebx
  8011cb:	5e                   	pop    %esi
  8011cc:	5f                   	pop    %edi
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011cf:	83 ec 0c             	sub    $0xc,%esp
  8011d2:	50                   	push   %eax
  8011d3:	6a 04                	push   $0x4
  8011d5:	68 3f 2a 80 00       	push   $0x802a3f
  8011da:	6a 23                	push   $0x23
  8011dc:	68 5c 2a 80 00       	push   $0x802a5c
  8011e1:	e8 ff f4 ff ff       	call   8006e5 <_panic>

008011e6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	57                   	push   %edi
  8011ea:	56                   	push   %esi
  8011eb:	53                   	push   %ebx
  8011ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f5:	b8 05 00 00 00       	mov    $0x5,%eax
  8011fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011fd:	8b 7d 14             	mov    0x14(%ebp),%edi
  801200:	8b 75 18             	mov    0x18(%ebp),%esi
  801203:	cd 30                	int    $0x30
	if(check && ret > 0)
  801205:	85 c0                	test   %eax,%eax
  801207:	7f 08                	jg     801211 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120c:	5b                   	pop    %ebx
  80120d:	5e                   	pop    %esi
  80120e:	5f                   	pop    %edi
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801211:	83 ec 0c             	sub    $0xc,%esp
  801214:	50                   	push   %eax
  801215:	6a 05                	push   $0x5
  801217:	68 3f 2a 80 00       	push   $0x802a3f
  80121c:	6a 23                	push   $0x23
  80121e:	68 5c 2a 80 00       	push   $0x802a5c
  801223:	e8 bd f4 ff ff       	call   8006e5 <_panic>

00801228 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	57                   	push   %edi
  80122c:	56                   	push   %esi
  80122d:	53                   	push   %ebx
  80122e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801231:	bb 00 00 00 00       	mov    $0x0,%ebx
  801236:	8b 55 08             	mov    0x8(%ebp),%edx
  801239:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123c:	b8 06 00 00 00       	mov    $0x6,%eax
  801241:	89 df                	mov    %ebx,%edi
  801243:	89 de                	mov    %ebx,%esi
  801245:	cd 30                	int    $0x30
	if(check && ret > 0)
  801247:	85 c0                	test   %eax,%eax
  801249:	7f 08                	jg     801253 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80124b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124e:	5b                   	pop    %ebx
  80124f:	5e                   	pop    %esi
  801250:	5f                   	pop    %edi
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801253:	83 ec 0c             	sub    $0xc,%esp
  801256:	50                   	push   %eax
  801257:	6a 06                	push   $0x6
  801259:	68 3f 2a 80 00       	push   $0x802a3f
  80125e:	6a 23                	push   $0x23
  801260:	68 5c 2a 80 00       	push   $0x802a5c
  801265:	e8 7b f4 ff ff       	call   8006e5 <_panic>

0080126a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	57                   	push   %edi
  80126e:	56                   	push   %esi
  80126f:	53                   	push   %ebx
  801270:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801273:	bb 00 00 00 00       	mov    $0x0,%ebx
  801278:	8b 55 08             	mov    0x8(%ebp),%edx
  80127b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127e:	b8 08 00 00 00       	mov    $0x8,%eax
  801283:	89 df                	mov    %ebx,%edi
  801285:	89 de                	mov    %ebx,%esi
  801287:	cd 30                	int    $0x30
	if(check && ret > 0)
  801289:	85 c0                	test   %eax,%eax
  80128b:	7f 08                	jg     801295 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80128d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801290:	5b                   	pop    %ebx
  801291:	5e                   	pop    %esi
  801292:	5f                   	pop    %edi
  801293:	5d                   	pop    %ebp
  801294:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	50                   	push   %eax
  801299:	6a 08                	push   $0x8
  80129b:	68 3f 2a 80 00       	push   $0x802a3f
  8012a0:	6a 23                	push   $0x23
  8012a2:	68 5c 2a 80 00       	push   $0x802a5c
  8012a7:	e8 39 f4 ff ff       	call   8006e5 <_panic>

008012ac <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	57                   	push   %edi
  8012b0:	56                   	push   %esi
  8012b1:	53                   	push   %ebx
  8012b2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8012bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c0:	b8 09 00 00 00       	mov    $0x9,%eax
  8012c5:	89 df                	mov    %ebx,%edi
  8012c7:	89 de                	mov    %ebx,%esi
  8012c9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	7f 08                	jg     8012d7 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5f                   	pop    %edi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d7:	83 ec 0c             	sub    $0xc,%esp
  8012da:	50                   	push   %eax
  8012db:	6a 09                	push   $0x9
  8012dd:	68 3f 2a 80 00       	push   $0x802a3f
  8012e2:	6a 23                	push   $0x23
  8012e4:	68 5c 2a 80 00       	push   $0x802a5c
  8012e9:	e8 f7 f3 ff ff       	call   8006e5 <_panic>

008012ee <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	57                   	push   %edi
  8012f2:	56                   	push   %esi
  8012f3:	53                   	push   %ebx
  8012f4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801302:	b8 0a 00 00 00       	mov    $0xa,%eax
  801307:	89 df                	mov    %ebx,%edi
  801309:	89 de                	mov    %ebx,%esi
  80130b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80130d:	85 c0                	test   %eax,%eax
  80130f:	7f 08                	jg     801319 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801311:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801314:	5b                   	pop    %ebx
  801315:	5e                   	pop    %esi
  801316:	5f                   	pop    %edi
  801317:	5d                   	pop    %ebp
  801318:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801319:	83 ec 0c             	sub    $0xc,%esp
  80131c:	50                   	push   %eax
  80131d:	6a 0a                	push   $0xa
  80131f:	68 3f 2a 80 00       	push   $0x802a3f
  801324:	6a 23                	push   $0x23
  801326:	68 5c 2a 80 00       	push   $0x802a5c
  80132b:	e8 b5 f3 ff ff       	call   8006e5 <_panic>

00801330 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	57                   	push   %edi
  801334:	56                   	push   %esi
  801335:	53                   	push   %ebx
	asm volatile("int %1\n"
  801336:	8b 55 08             	mov    0x8(%ebp),%edx
  801339:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80133c:	b8 0c 00 00 00       	mov    $0xc,%eax
  801341:	be 00 00 00 00       	mov    $0x0,%esi
  801346:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801349:	8b 7d 14             	mov    0x14(%ebp),%edi
  80134c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80134e:	5b                   	pop    %ebx
  80134f:	5e                   	pop    %esi
  801350:	5f                   	pop    %edi
  801351:	5d                   	pop    %ebp
  801352:	c3                   	ret    

00801353 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	57                   	push   %edi
  801357:	56                   	push   %esi
  801358:	53                   	push   %ebx
  801359:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80135c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801361:	8b 55 08             	mov    0x8(%ebp),%edx
  801364:	b8 0d 00 00 00       	mov    $0xd,%eax
  801369:	89 cb                	mov    %ecx,%ebx
  80136b:	89 cf                	mov    %ecx,%edi
  80136d:	89 ce                	mov    %ecx,%esi
  80136f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801371:	85 c0                	test   %eax,%eax
  801373:	7f 08                	jg     80137d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801375:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801378:	5b                   	pop    %ebx
  801379:	5e                   	pop    %esi
  80137a:	5f                   	pop    %edi
  80137b:	5d                   	pop    %ebp
  80137c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80137d:	83 ec 0c             	sub    $0xc,%esp
  801380:	50                   	push   %eax
  801381:	6a 0d                	push   $0xd
  801383:	68 3f 2a 80 00       	push   $0x802a3f
  801388:	6a 23                	push   $0x23
  80138a:	68 5c 2a 80 00       	push   $0x802a5c
  80138f:	e8 51 f3 ff ff       	call   8006e5 <_panic>

00801394 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  80139a:	68 6a 2a 80 00       	push   $0x802a6a
  80139f:	6a 1a                	push   $0x1a
  8013a1:	68 83 2a 80 00       	push   $0x802a83
  8013a6:	e8 3a f3 ff ff       	call   8006e5 <_panic>

008013ab <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  8013b1:	68 8d 2a 80 00       	push   $0x802a8d
  8013b6:	6a 2a                	push   $0x2a
  8013b8:	68 83 2a 80 00       	push   $0x802a83
  8013bd:	e8 23 f3 ff ff       	call   8006e5 <_panic>

008013c2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8013c8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8013cd:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8013d0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8013d6:	8b 52 50             	mov    0x50(%edx),%edx
  8013d9:	39 ca                	cmp    %ecx,%edx
  8013db:	74 11                	je     8013ee <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8013dd:	83 c0 01             	add    $0x1,%eax
  8013e0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013e5:	75 e6                	jne    8013cd <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8013e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ec:	eb 0b                	jmp    8013f9 <ipc_find_env+0x37>
			return envs[i].env_id;
  8013ee:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013f1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013f6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8013f9:	5d                   	pop    %ebp
  8013fa:	c3                   	ret    

008013fb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	05 00 00 00 30       	add    $0x30000000,%eax
  801406:	c1 e8 0c             	shr    $0xc,%eax
}
  801409:	5d                   	pop    %ebp
  80140a:	c3                   	ret    

0080140b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801416:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80141b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    

00801422 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801428:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80142d:	89 c2                	mov    %eax,%edx
  80142f:	c1 ea 16             	shr    $0x16,%edx
  801432:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801439:	f6 c2 01             	test   $0x1,%dl
  80143c:	74 2a                	je     801468 <fd_alloc+0x46>
  80143e:	89 c2                	mov    %eax,%edx
  801440:	c1 ea 0c             	shr    $0xc,%edx
  801443:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80144a:	f6 c2 01             	test   $0x1,%dl
  80144d:	74 19                	je     801468 <fd_alloc+0x46>
  80144f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801454:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801459:	75 d2                	jne    80142d <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80145b:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801461:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801466:	eb 07                	jmp    80146f <fd_alloc+0x4d>
			*fd_store = fd;
  801468:	89 01                	mov    %eax,(%ecx)
			return 0;
  80146a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146f:	5d                   	pop    %ebp
  801470:	c3                   	ret    

00801471 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801477:	83 f8 1f             	cmp    $0x1f,%eax
  80147a:	77 36                	ja     8014b2 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80147c:	c1 e0 0c             	shl    $0xc,%eax
  80147f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801484:	89 c2                	mov    %eax,%edx
  801486:	c1 ea 16             	shr    $0x16,%edx
  801489:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801490:	f6 c2 01             	test   $0x1,%dl
  801493:	74 24                	je     8014b9 <fd_lookup+0x48>
  801495:	89 c2                	mov    %eax,%edx
  801497:	c1 ea 0c             	shr    $0xc,%edx
  80149a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a1:	f6 c2 01             	test   $0x1,%dl
  8014a4:	74 1a                	je     8014c0 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a9:	89 02                	mov    %eax,(%edx)
	return 0;
  8014ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b0:	5d                   	pop    %ebp
  8014b1:	c3                   	ret    
		return -E_INVAL;
  8014b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b7:	eb f7                	jmp    8014b0 <fd_lookup+0x3f>
		return -E_INVAL;
  8014b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014be:	eb f0                	jmp    8014b0 <fd_lookup+0x3f>
  8014c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c5:	eb e9                	jmp    8014b0 <fd_lookup+0x3f>

008014c7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 08             	sub    $0x8,%esp
  8014cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d0:	ba 28 2b 80 00       	mov    $0x802b28,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014d5:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014da:	39 08                	cmp    %ecx,(%eax)
  8014dc:	74 33                	je     801511 <dev_lookup+0x4a>
  8014de:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8014e1:	8b 02                	mov    (%edx),%eax
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	75 f3                	jne    8014da <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014e7:	a1 04 40 80 00       	mov    0x804004,%eax
  8014ec:	8b 40 48             	mov    0x48(%eax),%eax
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	51                   	push   %ecx
  8014f3:	50                   	push   %eax
  8014f4:	68 a8 2a 80 00       	push   $0x802aa8
  8014f9:	e8 c2 f2 ff ff       	call   8007c0 <cprintf>
	*dev = 0;
  8014fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    
			*dev = devtab[i];
  801511:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801514:	89 01                	mov    %eax,(%ecx)
			return 0;
  801516:	b8 00 00 00 00       	mov    $0x0,%eax
  80151b:	eb f2                	jmp    80150f <dev_lookup+0x48>

0080151d <fd_close>:
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	57                   	push   %edi
  801521:	56                   	push   %esi
  801522:	53                   	push   %ebx
  801523:	83 ec 1c             	sub    $0x1c,%esp
  801526:	8b 75 08             	mov    0x8(%ebp),%esi
  801529:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80152c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80152f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801530:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801536:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801539:	50                   	push   %eax
  80153a:	e8 32 ff ff ff       	call   801471 <fd_lookup>
  80153f:	89 c3                	mov    %eax,%ebx
  801541:	83 c4 08             	add    $0x8,%esp
  801544:	85 c0                	test   %eax,%eax
  801546:	78 05                	js     80154d <fd_close+0x30>
	    || fd != fd2)
  801548:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80154b:	74 16                	je     801563 <fd_close+0x46>
		return (must_exist ? r : 0);
  80154d:	89 f8                	mov    %edi,%eax
  80154f:	84 c0                	test   %al,%al
  801551:	b8 00 00 00 00       	mov    $0x0,%eax
  801556:	0f 44 d8             	cmove  %eax,%ebx
}
  801559:	89 d8                	mov    %ebx,%eax
  80155b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155e:	5b                   	pop    %ebx
  80155f:	5e                   	pop    %esi
  801560:	5f                   	pop    %edi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801569:	50                   	push   %eax
  80156a:	ff 36                	pushl  (%esi)
  80156c:	e8 56 ff ff ff       	call   8014c7 <dev_lookup>
  801571:	89 c3                	mov    %eax,%ebx
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	78 15                	js     80158f <fd_close+0x72>
		if (dev->dev_close)
  80157a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157d:	8b 40 10             	mov    0x10(%eax),%eax
  801580:	85 c0                	test   %eax,%eax
  801582:	74 1b                	je     80159f <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801584:	83 ec 0c             	sub    $0xc,%esp
  801587:	56                   	push   %esi
  801588:	ff d0                	call   *%eax
  80158a:	89 c3                	mov    %eax,%ebx
  80158c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80158f:	83 ec 08             	sub    $0x8,%esp
  801592:	56                   	push   %esi
  801593:	6a 00                	push   $0x0
  801595:	e8 8e fc ff ff       	call   801228 <sys_page_unmap>
	return r;
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	eb ba                	jmp    801559 <fd_close+0x3c>
			r = 0;
  80159f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a4:	eb e9                	jmp    80158f <fd_close+0x72>

008015a6 <close>:

int
close(int fdnum)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	ff 75 08             	pushl  0x8(%ebp)
  8015b3:	e8 b9 fe ff ff       	call   801471 <fd_lookup>
  8015b8:	83 c4 08             	add    $0x8,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	78 10                	js     8015cf <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8015bf:	83 ec 08             	sub    $0x8,%esp
  8015c2:	6a 01                	push   $0x1
  8015c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c7:	e8 51 ff ff ff       	call   80151d <fd_close>
  8015cc:	83 c4 10             	add    $0x10,%esp
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <close_all>:

void
close_all(void)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	53                   	push   %ebx
  8015d5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015d8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	53                   	push   %ebx
  8015e1:	e8 c0 ff ff ff       	call   8015a6 <close>
	for (i = 0; i < MAXFD; i++)
  8015e6:	83 c3 01             	add    $0x1,%ebx
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	83 fb 20             	cmp    $0x20,%ebx
  8015ef:	75 ec                	jne    8015dd <close_all+0xc>
}
  8015f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	57                   	push   %edi
  8015fa:	56                   	push   %esi
  8015fb:	53                   	push   %ebx
  8015fc:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801602:	50                   	push   %eax
  801603:	ff 75 08             	pushl  0x8(%ebp)
  801606:	e8 66 fe ff ff       	call   801471 <fd_lookup>
  80160b:	89 c3                	mov    %eax,%ebx
  80160d:	83 c4 08             	add    $0x8,%esp
  801610:	85 c0                	test   %eax,%eax
  801612:	0f 88 81 00 00 00    	js     801699 <dup+0xa3>
		return r;
	close(newfdnum);
  801618:	83 ec 0c             	sub    $0xc,%esp
  80161b:	ff 75 0c             	pushl  0xc(%ebp)
  80161e:	e8 83 ff ff ff       	call   8015a6 <close>

	newfd = INDEX2FD(newfdnum);
  801623:	8b 75 0c             	mov    0xc(%ebp),%esi
  801626:	c1 e6 0c             	shl    $0xc,%esi
  801629:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80162f:	83 c4 04             	add    $0x4,%esp
  801632:	ff 75 e4             	pushl  -0x1c(%ebp)
  801635:	e8 d1 fd ff ff       	call   80140b <fd2data>
  80163a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80163c:	89 34 24             	mov    %esi,(%esp)
  80163f:	e8 c7 fd ff ff       	call   80140b <fd2data>
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801649:	89 d8                	mov    %ebx,%eax
  80164b:	c1 e8 16             	shr    $0x16,%eax
  80164e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801655:	a8 01                	test   $0x1,%al
  801657:	74 11                	je     80166a <dup+0x74>
  801659:	89 d8                	mov    %ebx,%eax
  80165b:	c1 e8 0c             	shr    $0xc,%eax
  80165e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801665:	f6 c2 01             	test   $0x1,%dl
  801668:	75 39                	jne    8016a3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80166a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80166d:	89 d0                	mov    %edx,%eax
  80166f:	c1 e8 0c             	shr    $0xc,%eax
  801672:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	25 07 0e 00 00       	and    $0xe07,%eax
  801681:	50                   	push   %eax
  801682:	56                   	push   %esi
  801683:	6a 00                	push   $0x0
  801685:	52                   	push   %edx
  801686:	6a 00                	push   $0x0
  801688:	e8 59 fb ff ff       	call   8011e6 <sys_page_map>
  80168d:	89 c3                	mov    %eax,%ebx
  80168f:	83 c4 20             	add    $0x20,%esp
  801692:	85 c0                	test   %eax,%eax
  801694:	78 31                	js     8016c7 <dup+0xd1>
		goto err;

	return newfdnum;
  801696:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801699:	89 d8                	mov    %ebx,%eax
  80169b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80169e:	5b                   	pop    %ebx
  80169f:	5e                   	pop    %esi
  8016a0:	5f                   	pop    %edi
  8016a1:	5d                   	pop    %ebp
  8016a2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016a3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016aa:	83 ec 0c             	sub    $0xc,%esp
  8016ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8016b2:	50                   	push   %eax
  8016b3:	57                   	push   %edi
  8016b4:	6a 00                	push   $0x0
  8016b6:	53                   	push   %ebx
  8016b7:	6a 00                	push   $0x0
  8016b9:	e8 28 fb ff ff       	call   8011e6 <sys_page_map>
  8016be:	89 c3                	mov    %eax,%ebx
  8016c0:	83 c4 20             	add    $0x20,%esp
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	79 a3                	jns    80166a <dup+0x74>
	sys_page_unmap(0, newfd);
  8016c7:	83 ec 08             	sub    $0x8,%esp
  8016ca:	56                   	push   %esi
  8016cb:	6a 00                	push   $0x0
  8016cd:	e8 56 fb ff ff       	call   801228 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016d2:	83 c4 08             	add    $0x8,%esp
  8016d5:	57                   	push   %edi
  8016d6:	6a 00                	push   $0x0
  8016d8:	e8 4b fb ff ff       	call   801228 <sys_page_unmap>
	return r;
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	eb b7                	jmp    801699 <dup+0xa3>

008016e2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	53                   	push   %ebx
  8016e6:	83 ec 14             	sub    $0x14,%esp
  8016e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ef:	50                   	push   %eax
  8016f0:	53                   	push   %ebx
  8016f1:	e8 7b fd ff ff       	call   801471 <fd_lookup>
  8016f6:	83 c4 08             	add    $0x8,%esp
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	78 3f                	js     80173c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801703:	50                   	push   %eax
  801704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801707:	ff 30                	pushl  (%eax)
  801709:	e8 b9 fd ff ff       	call   8014c7 <dev_lookup>
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	78 27                	js     80173c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801715:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801718:	8b 42 08             	mov    0x8(%edx),%eax
  80171b:	83 e0 03             	and    $0x3,%eax
  80171e:	83 f8 01             	cmp    $0x1,%eax
  801721:	74 1e                	je     801741 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801726:	8b 40 08             	mov    0x8(%eax),%eax
  801729:	85 c0                	test   %eax,%eax
  80172b:	74 35                	je     801762 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80172d:	83 ec 04             	sub    $0x4,%esp
  801730:	ff 75 10             	pushl  0x10(%ebp)
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	52                   	push   %edx
  801737:	ff d0                	call   *%eax
  801739:	83 c4 10             	add    $0x10,%esp
}
  80173c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173f:	c9                   	leave  
  801740:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801741:	a1 04 40 80 00       	mov    0x804004,%eax
  801746:	8b 40 48             	mov    0x48(%eax),%eax
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	53                   	push   %ebx
  80174d:	50                   	push   %eax
  80174e:	68 ec 2a 80 00       	push   $0x802aec
  801753:	e8 68 f0 ff ff       	call   8007c0 <cprintf>
		return -E_INVAL;
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801760:	eb da                	jmp    80173c <read+0x5a>
		return -E_NOT_SUPP;
  801762:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801767:	eb d3                	jmp    80173c <read+0x5a>

00801769 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	57                   	push   %edi
  80176d:	56                   	push   %esi
  80176e:	53                   	push   %ebx
  80176f:	83 ec 0c             	sub    $0xc,%esp
  801772:	8b 7d 08             	mov    0x8(%ebp),%edi
  801775:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801778:	bb 00 00 00 00       	mov    $0x0,%ebx
  80177d:	39 f3                	cmp    %esi,%ebx
  80177f:	73 25                	jae    8017a6 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	89 f0                	mov    %esi,%eax
  801786:	29 d8                	sub    %ebx,%eax
  801788:	50                   	push   %eax
  801789:	89 d8                	mov    %ebx,%eax
  80178b:	03 45 0c             	add    0xc(%ebp),%eax
  80178e:	50                   	push   %eax
  80178f:	57                   	push   %edi
  801790:	e8 4d ff ff ff       	call   8016e2 <read>
		if (m < 0)
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	85 c0                	test   %eax,%eax
  80179a:	78 08                	js     8017a4 <readn+0x3b>
			return m;
		if (m == 0)
  80179c:	85 c0                	test   %eax,%eax
  80179e:	74 06                	je     8017a6 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8017a0:	01 c3                	add    %eax,%ebx
  8017a2:	eb d9                	jmp    80177d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017a4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017a6:	89 d8                	mov    %ebx,%eax
  8017a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ab:	5b                   	pop    %ebx
  8017ac:	5e                   	pop    %esi
  8017ad:	5f                   	pop    %edi
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 14             	sub    $0x14,%esp
  8017b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017bd:	50                   	push   %eax
  8017be:	53                   	push   %ebx
  8017bf:	e8 ad fc ff ff       	call   801471 <fd_lookup>
  8017c4:	83 c4 08             	add    $0x8,%esp
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 3a                	js     801805 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d1:	50                   	push   %eax
  8017d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d5:	ff 30                	pushl  (%eax)
  8017d7:	e8 eb fc ff ff       	call   8014c7 <dev_lookup>
  8017dc:	83 c4 10             	add    $0x10,%esp
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 22                	js     801805 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ea:	74 1e                	je     80180a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ef:	8b 52 0c             	mov    0xc(%edx),%edx
  8017f2:	85 d2                	test   %edx,%edx
  8017f4:	74 35                	je     80182b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	ff 75 10             	pushl  0x10(%ebp)
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	50                   	push   %eax
  801800:	ff d2                	call   *%edx
  801802:	83 c4 10             	add    $0x10,%esp
}
  801805:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801808:	c9                   	leave  
  801809:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80180a:	a1 04 40 80 00       	mov    0x804004,%eax
  80180f:	8b 40 48             	mov    0x48(%eax),%eax
  801812:	83 ec 04             	sub    $0x4,%esp
  801815:	53                   	push   %ebx
  801816:	50                   	push   %eax
  801817:	68 08 2b 80 00       	push   $0x802b08
  80181c:	e8 9f ef ff ff       	call   8007c0 <cprintf>
		return -E_INVAL;
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801829:	eb da                	jmp    801805 <write+0x55>
		return -E_NOT_SUPP;
  80182b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801830:	eb d3                	jmp    801805 <write+0x55>

00801832 <seek>:

int
seek(int fdnum, off_t offset)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801838:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80183b:	50                   	push   %eax
  80183c:	ff 75 08             	pushl  0x8(%ebp)
  80183f:	e8 2d fc ff ff       	call   801471 <fd_lookup>
  801844:	83 c4 08             	add    $0x8,%esp
  801847:	85 c0                	test   %eax,%eax
  801849:	78 0e                	js     801859 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80184b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801851:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801854:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	53                   	push   %ebx
  80185f:	83 ec 14             	sub    $0x14,%esp
  801862:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801865:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801868:	50                   	push   %eax
  801869:	53                   	push   %ebx
  80186a:	e8 02 fc ff ff       	call   801471 <fd_lookup>
  80186f:	83 c4 08             	add    $0x8,%esp
  801872:	85 c0                	test   %eax,%eax
  801874:	78 37                	js     8018ad <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801876:	83 ec 08             	sub    $0x8,%esp
  801879:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187c:	50                   	push   %eax
  80187d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801880:	ff 30                	pushl  (%eax)
  801882:	e8 40 fc ff ff       	call   8014c7 <dev_lookup>
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	85 c0                	test   %eax,%eax
  80188c:	78 1f                	js     8018ad <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80188e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801891:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801895:	74 1b                	je     8018b2 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189a:	8b 52 18             	mov    0x18(%edx),%edx
  80189d:	85 d2                	test   %edx,%edx
  80189f:	74 32                	je     8018d3 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	50                   	push   %eax
  8018a8:	ff d2                	call   *%edx
  8018aa:	83 c4 10             	add    $0x10,%esp
}
  8018ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018b2:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018b7:	8b 40 48             	mov    0x48(%eax),%eax
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	53                   	push   %ebx
  8018be:	50                   	push   %eax
  8018bf:	68 c8 2a 80 00       	push   $0x802ac8
  8018c4:	e8 f7 ee ff ff       	call   8007c0 <cprintf>
		return -E_INVAL;
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d1:	eb da                	jmp    8018ad <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d8:	eb d3                	jmp    8018ad <ftruncate+0x52>

008018da <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 14             	sub    $0x14,%esp
  8018e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e7:	50                   	push   %eax
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	e8 81 fb ff ff       	call   801471 <fd_lookup>
  8018f0:	83 c4 08             	add    $0x8,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 4b                	js     801942 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fd:	50                   	push   %eax
  8018fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801901:	ff 30                	pushl  (%eax)
  801903:	e8 bf fb ff ff       	call   8014c7 <dev_lookup>
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	78 33                	js     801942 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80190f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801912:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801916:	74 2f                	je     801947 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801918:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80191b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801922:	00 00 00 
	stat->st_isdir = 0;
  801925:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80192c:	00 00 00 
	stat->st_dev = dev;
  80192f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	53                   	push   %ebx
  801939:	ff 75 f0             	pushl  -0x10(%ebp)
  80193c:	ff 50 14             	call   *0x14(%eax)
  80193f:	83 c4 10             	add    $0x10,%esp
}
  801942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801945:	c9                   	leave  
  801946:	c3                   	ret    
		return -E_NOT_SUPP;
  801947:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80194c:	eb f4                	jmp    801942 <fstat+0x68>

0080194e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	56                   	push   %esi
  801952:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801953:	83 ec 08             	sub    $0x8,%esp
  801956:	6a 00                	push   $0x0
  801958:	ff 75 08             	pushl  0x8(%ebp)
  80195b:	e8 e7 01 00 00       	call   801b47 <open>
  801960:	89 c3                	mov    %eax,%ebx
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	78 1b                	js     801984 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801969:	83 ec 08             	sub    $0x8,%esp
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	50                   	push   %eax
  801970:	e8 65 ff ff ff       	call   8018da <fstat>
  801975:	89 c6                	mov    %eax,%esi
	close(fd);
  801977:	89 1c 24             	mov    %ebx,(%esp)
  80197a:	e8 27 fc ff ff       	call   8015a6 <close>
	return r;
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	89 f3                	mov    %esi,%ebx
}
  801984:	89 d8                	mov    %ebx,%eax
  801986:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801989:	5b                   	pop    %ebx
  80198a:	5e                   	pop    %esi
  80198b:	5d                   	pop    %ebp
  80198c:	c3                   	ret    

0080198d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	56                   	push   %esi
  801991:	53                   	push   %ebx
  801992:	89 c6                	mov    %eax,%esi
  801994:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801996:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80199d:	74 27                	je     8019c6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80199f:	6a 07                	push   $0x7
  8019a1:	68 00 50 80 00       	push   $0x805000
  8019a6:	56                   	push   %esi
  8019a7:	ff 35 00 40 80 00    	pushl  0x804000
  8019ad:	e8 f9 f9 ff ff       	call   8013ab <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019b2:	83 c4 0c             	add    $0xc,%esp
  8019b5:	6a 00                	push   $0x0
  8019b7:	53                   	push   %ebx
  8019b8:	6a 00                	push   $0x0
  8019ba:	e8 d5 f9 ff ff       	call   801394 <ipc_recv>
}
  8019bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c2:	5b                   	pop    %ebx
  8019c3:	5e                   	pop    %esi
  8019c4:	5d                   	pop    %ebp
  8019c5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019c6:	83 ec 0c             	sub    $0xc,%esp
  8019c9:	6a 01                	push   $0x1
  8019cb:	e8 f2 f9 ff ff       	call   8013c2 <ipc_find_env>
  8019d0:	a3 00 40 80 00       	mov    %eax,0x804000
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	eb c5                	jmp    80199f <fsipc+0x12>

008019da <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ee:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f8:	b8 02 00 00 00       	mov    $0x2,%eax
  8019fd:	e8 8b ff ff ff       	call   80198d <fsipc>
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <devfile_flush>:
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a10:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a15:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1a:	b8 06 00 00 00       	mov    $0x6,%eax
  801a1f:	e8 69 ff ff ff       	call   80198d <fsipc>
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <devfile_stat>:
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	53                   	push   %ebx
  801a2a:	83 ec 04             	sub    $0x4,%esp
  801a2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	8b 40 0c             	mov    0xc(%eax),%eax
  801a36:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a40:	b8 05 00 00 00       	mov    $0x5,%eax
  801a45:	e8 43 ff ff ff       	call   80198d <fsipc>
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	78 2c                	js     801a7a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a4e:	83 ec 08             	sub    $0x8,%esp
  801a51:	68 00 50 80 00       	push   $0x805000
  801a56:	53                   	push   %ebx
  801a57:	e8 4e f3 ff ff       	call   800daa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a5c:	a1 80 50 80 00       	mov    0x805080,%eax
  801a61:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a67:	a1 84 50 80 00       	mov    0x805084,%eax
  801a6c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a72:	83 c4 10             	add    $0x10,%esp
  801a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <devfile_write>:
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 0c             	sub    $0xc,%esp
  801a85:	8b 45 10             	mov    0x10(%ebp),%eax
  801a88:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a8d:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a92:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a95:	8b 55 08             	mov    0x8(%ebp),%edx
  801a98:	8b 52 0c             	mov    0xc(%edx),%edx
  801a9b:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801aa1:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  801aa6:	50                   	push   %eax
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	68 08 50 80 00       	push   $0x805008
  801aaf:	e8 84 f4 ff ff       	call   800f38 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab9:	b8 04 00 00 00       	mov    $0x4,%eax
  801abe:	e8 ca fe ff ff       	call   80198d <fsipc>
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <devfile_read>:
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	56                   	push   %esi
  801ac9:	53                   	push   %ebx
  801aca:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ad8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ade:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ae8:	e8 a0 fe ff ff       	call   80198d <fsipc>
  801aed:	89 c3                	mov    %eax,%ebx
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 1f                	js     801b12 <devfile_read+0x4d>
	assert(r <= n);
  801af3:	39 f0                	cmp    %esi,%eax
  801af5:	77 24                	ja     801b1b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801af7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801afc:	7f 33                	jg     801b31 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801afe:	83 ec 04             	sub    $0x4,%esp
  801b01:	50                   	push   %eax
  801b02:	68 00 50 80 00       	push   $0x805000
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	e8 29 f4 ff ff       	call   800f38 <memmove>
	return r;
  801b0f:	83 c4 10             	add    $0x10,%esp
}
  801b12:	89 d8                	mov    %ebx,%eax
  801b14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b17:	5b                   	pop    %ebx
  801b18:	5e                   	pop    %esi
  801b19:	5d                   	pop    %ebp
  801b1a:	c3                   	ret    
	assert(r <= n);
  801b1b:	68 38 2b 80 00       	push   $0x802b38
  801b20:	68 3f 2b 80 00       	push   $0x802b3f
  801b25:	6a 7c                	push   $0x7c
  801b27:	68 54 2b 80 00       	push   $0x802b54
  801b2c:	e8 b4 eb ff ff       	call   8006e5 <_panic>
	assert(r <= PGSIZE);
  801b31:	68 5f 2b 80 00       	push   $0x802b5f
  801b36:	68 3f 2b 80 00       	push   $0x802b3f
  801b3b:	6a 7d                	push   $0x7d
  801b3d:	68 54 2b 80 00       	push   $0x802b54
  801b42:	e8 9e eb ff ff       	call   8006e5 <_panic>

00801b47 <open>:
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	56                   	push   %esi
  801b4b:	53                   	push   %ebx
  801b4c:	83 ec 1c             	sub    $0x1c,%esp
  801b4f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b52:	56                   	push   %esi
  801b53:	e8 1b f2 ff ff       	call   800d73 <strlen>
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b60:	7f 6c                	jg     801bce <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b62:	83 ec 0c             	sub    $0xc,%esp
  801b65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b68:	50                   	push   %eax
  801b69:	e8 b4 f8 ff ff       	call   801422 <fd_alloc>
  801b6e:	89 c3                	mov    %eax,%ebx
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	85 c0                	test   %eax,%eax
  801b75:	78 3c                	js     801bb3 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b77:	83 ec 08             	sub    $0x8,%esp
  801b7a:	56                   	push   %esi
  801b7b:	68 00 50 80 00       	push   $0x805000
  801b80:	e8 25 f2 ff ff       	call   800daa <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b88:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b90:	b8 01 00 00 00       	mov    $0x1,%eax
  801b95:	e8 f3 fd ff ff       	call   80198d <fsipc>
  801b9a:	89 c3                	mov    %eax,%ebx
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	78 19                	js     801bbc <open+0x75>
	return fd2num(fd);
  801ba3:	83 ec 0c             	sub    $0xc,%esp
  801ba6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba9:	e8 4d f8 ff ff       	call   8013fb <fd2num>
  801bae:	89 c3                	mov    %eax,%ebx
  801bb0:	83 c4 10             	add    $0x10,%esp
}
  801bb3:	89 d8                	mov    %ebx,%eax
  801bb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb8:	5b                   	pop    %ebx
  801bb9:	5e                   	pop    %esi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
		fd_close(fd, 0);
  801bbc:	83 ec 08             	sub    $0x8,%esp
  801bbf:	6a 00                	push   $0x0
  801bc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc4:	e8 54 f9 ff ff       	call   80151d <fd_close>
		return r;
  801bc9:	83 c4 10             	add    $0x10,%esp
  801bcc:	eb e5                	jmp    801bb3 <open+0x6c>
		return -E_BAD_PATH;
  801bce:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bd3:	eb de                	jmp    801bb3 <open+0x6c>

00801bd5 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  801be0:	b8 08 00 00 00       	mov    $0x8,%eax
  801be5:	e8 a3 fd ff ff       	call   80198d <fsipc>
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	56                   	push   %esi
  801bf0:	53                   	push   %ebx
  801bf1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bf4:	83 ec 0c             	sub    $0xc,%esp
  801bf7:	ff 75 08             	pushl  0x8(%ebp)
  801bfa:	e8 0c f8 ff ff       	call   80140b <fd2data>
  801bff:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c01:	83 c4 08             	add    $0x8,%esp
  801c04:	68 6b 2b 80 00       	push   $0x802b6b
  801c09:	53                   	push   %ebx
  801c0a:	e8 9b f1 ff ff       	call   800daa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c0f:	8b 46 04             	mov    0x4(%esi),%eax
  801c12:	2b 06                	sub    (%esi),%eax
  801c14:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c1a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c21:	00 00 00 
	stat->st_dev = &devpipe;
  801c24:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801c2b:	30 80 00 
	return 0;
}
  801c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c36:	5b                   	pop    %ebx
  801c37:	5e                   	pop    %esi
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    

00801c3a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	53                   	push   %ebx
  801c3e:	83 ec 0c             	sub    $0xc,%esp
  801c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c44:	53                   	push   %ebx
  801c45:	6a 00                	push   $0x0
  801c47:	e8 dc f5 ff ff       	call   801228 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c4c:	89 1c 24             	mov    %ebx,(%esp)
  801c4f:	e8 b7 f7 ff ff       	call   80140b <fd2data>
  801c54:	83 c4 08             	add    $0x8,%esp
  801c57:	50                   	push   %eax
  801c58:	6a 00                	push   $0x0
  801c5a:	e8 c9 f5 ff ff       	call   801228 <sys_page_unmap>
}
  801c5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <_pipeisclosed>:
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	57                   	push   %edi
  801c68:	56                   	push   %esi
  801c69:	53                   	push   %ebx
  801c6a:	83 ec 1c             	sub    $0x1c,%esp
  801c6d:	89 c7                	mov    %eax,%edi
  801c6f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c71:	a1 04 40 80 00       	mov    0x804004,%eax
  801c76:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c79:	83 ec 0c             	sub    $0xc,%esp
  801c7c:	57                   	push   %edi
  801c7d:	e8 34 04 00 00       	call   8020b6 <pageref>
  801c82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c85:	89 34 24             	mov    %esi,(%esp)
  801c88:	e8 29 04 00 00       	call   8020b6 <pageref>
		nn = thisenv->env_runs;
  801c8d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c93:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	39 cb                	cmp    %ecx,%ebx
  801c9b:	74 1b                	je     801cb8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c9d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ca0:	75 cf                	jne    801c71 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ca2:	8b 42 58             	mov    0x58(%edx),%eax
  801ca5:	6a 01                	push   $0x1
  801ca7:	50                   	push   %eax
  801ca8:	53                   	push   %ebx
  801ca9:	68 72 2b 80 00       	push   $0x802b72
  801cae:	e8 0d eb ff ff       	call   8007c0 <cprintf>
  801cb3:	83 c4 10             	add    $0x10,%esp
  801cb6:	eb b9                	jmp    801c71 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cb8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cbb:	0f 94 c0             	sete   %al
  801cbe:	0f b6 c0             	movzbl %al,%eax
}
  801cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc4:	5b                   	pop    %ebx
  801cc5:	5e                   	pop    %esi
  801cc6:	5f                   	pop    %edi
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    

00801cc9 <devpipe_write>:
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	57                   	push   %edi
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 28             	sub    $0x28,%esp
  801cd2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cd5:	56                   	push   %esi
  801cd6:	e8 30 f7 ff ff       	call   80140b <fd2data>
  801cdb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ce5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ce8:	74 4f                	je     801d39 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cea:	8b 43 04             	mov    0x4(%ebx),%eax
  801ced:	8b 0b                	mov    (%ebx),%ecx
  801cef:	8d 51 20             	lea    0x20(%ecx),%edx
  801cf2:	39 d0                	cmp    %edx,%eax
  801cf4:	72 14                	jb     801d0a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801cf6:	89 da                	mov    %ebx,%edx
  801cf8:	89 f0                	mov    %esi,%eax
  801cfa:	e8 65 ff ff ff       	call   801c64 <_pipeisclosed>
  801cff:	85 c0                	test   %eax,%eax
  801d01:	75 3a                	jne    801d3d <devpipe_write+0x74>
			sys_yield();
  801d03:	e8 7c f4 ff ff       	call   801184 <sys_yield>
  801d08:	eb e0                	jmp    801cea <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d0d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d11:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	c1 fa 1f             	sar    $0x1f,%edx
  801d19:	89 d1                	mov    %edx,%ecx
  801d1b:	c1 e9 1b             	shr    $0x1b,%ecx
  801d1e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d21:	83 e2 1f             	and    $0x1f,%edx
  801d24:	29 ca                	sub    %ecx,%edx
  801d26:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d2a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d2e:	83 c0 01             	add    $0x1,%eax
  801d31:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d34:	83 c7 01             	add    $0x1,%edi
  801d37:	eb ac                	jmp    801ce5 <devpipe_write+0x1c>
	return i;
  801d39:	89 f8                	mov    %edi,%eax
  801d3b:	eb 05                	jmp    801d42 <devpipe_write+0x79>
				return 0;
  801d3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d45:	5b                   	pop    %ebx
  801d46:	5e                   	pop    %esi
  801d47:	5f                   	pop    %edi
  801d48:	5d                   	pop    %ebp
  801d49:	c3                   	ret    

00801d4a <devpipe_read>:
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	57                   	push   %edi
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	83 ec 18             	sub    $0x18,%esp
  801d53:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d56:	57                   	push   %edi
  801d57:	e8 af f6 ff ff       	call   80140b <fd2data>
  801d5c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d5e:	83 c4 10             	add    $0x10,%esp
  801d61:	be 00 00 00 00       	mov    $0x0,%esi
  801d66:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d69:	74 47                	je     801db2 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801d6b:	8b 03                	mov    (%ebx),%eax
  801d6d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d70:	75 22                	jne    801d94 <devpipe_read+0x4a>
			if (i > 0)
  801d72:	85 f6                	test   %esi,%esi
  801d74:	75 14                	jne    801d8a <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801d76:	89 da                	mov    %ebx,%edx
  801d78:	89 f8                	mov    %edi,%eax
  801d7a:	e8 e5 fe ff ff       	call   801c64 <_pipeisclosed>
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	75 33                	jne    801db6 <devpipe_read+0x6c>
			sys_yield();
  801d83:	e8 fc f3 ff ff       	call   801184 <sys_yield>
  801d88:	eb e1                	jmp    801d6b <devpipe_read+0x21>
				return i;
  801d8a:	89 f0                	mov    %esi,%eax
}
  801d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5f                   	pop    %edi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d94:	99                   	cltd   
  801d95:	c1 ea 1b             	shr    $0x1b,%edx
  801d98:	01 d0                	add    %edx,%eax
  801d9a:	83 e0 1f             	and    $0x1f,%eax
  801d9d:	29 d0                	sub    %edx,%eax
  801d9f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801da4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801da7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801daa:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dad:	83 c6 01             	add    $0x1,%esi
  801db0:	eb b4                	jmp    801d66 <devpipe_read+0x1c>
	return i;
  801db2:	89 f0                	mov    %esi,%eax
  801db4:	eb d6                	jmp    801d8c <devpipe_read+0x42>
				return 0;
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbb:	eb cf                	jmp    801d8c <devpipe_read+0x42>

00801dbd <pipe>:
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	56                   	push   %esi
  801dc1:	53                   	push   %ebx
  801dc2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801dc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc8:	50                   	push   %eax
  801dc9:	e8 54 f6 ff ff       	call   801422 <fd_alloc>
  801dce:	89 c3                	mov    %eax,%ebx
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	78 5b                	js     801e32 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd7:	83 ec 04             	sub    $0x4,%esp
  801dda:	68 07 04 00 00       	push   $0x407
  801ddf:	ff 75 f4             	pushl  -0xc(%ebp)
  801de2:	6a 00                	push   $0x0
  801de4:	e8 ba f3 ff ff       	call   8011a3 <sys_page_alloc>
  801de9:	89 c3                	mov    %eax,%ebx
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	85 c0                	test   %eax,%eax
  801df0:	78 40                	js     801e32 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801df2:	83 ec 0c             	sub    $0xc,%esp
  801df5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801df8:	50                   	push   %eax
  801df9:	e8 24 f6 ff ff       	call   801422 <fd_alloc>
  801dfe:	89 c3                	mov    %eax,%ebx
  801e00:	83 c4 10             	add    $0x10,%esp
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 1b                	js     801e22 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e07:	83 ec 04             	sub    $0x4,%esp
  801e0a:	68 07 04 00 00       	push   $0x407
  801e0f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e12:	6a 00                	push   $0x0
  801e14:	e8 8a f3 ff ff       	call   8011a3 <sys_page_alloc>
  801e19:	89 c3                	mov    %eax,%ebx
  801e1b:	83 c4 10             	add    $0x10,%esp
  801e1e:	85 c0                	test   %eax,%eax
  801e20:	79 19                	jns    801e3b <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801e22:	83 ec 08             	sub    $0x8,%esp
  801e25:	ff 75 f4             	pushl  -0xc(%ebp)
  801e28:	6a 00                	push   $0x0
  801e2a:	e8 f9 f3 ff ff       	call   801228 <sys_page_unmap>
  801e2f:	83 c4 10             	add    $0x10,%esp
}
  801e32:	89 d8                	mov    %ebx,%eax
  801e34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5d                   	pop    %ebp
  801e3a:	c3                   	ret    
	va = fd2data(fd0);
  801e3b:	83 ec 0c             	sub    $0xc,%esp
  801e3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e41:	e8 c5 f5 ff ff       	call   80140b <fd2data>
  801e46:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e48:	83 c4 0c             	add    $0xc,%esp
  801e4b:	68 07 04 00 00       	push   $0x407
  801e50:	50                   	push   %eax
  801e51:	6a 00                	push   $0x0
  801e53:	e8 4b f3 ff ff       	call   8011a3 <sys_page_alloc>
  801e58:	89 c3                	mov    %eax,%ebx
  801e5a:	83 c4 10             	add    $0x10,%esp
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	0f 88 8c 00 00 00    	js     801ef1 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e65:	83 ec 0c             	sub    $0xc,%esp
  801e68:	ff 75 f0             	pushl  -0x10(%ebp)
  801e6b:	e8 9b f5 ff ff       	call   80140b <fd2data>
  801e70:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e77:	50                   	push   %eax
  801e78:	6a 00                	push   $0x0
  801e7a:	56                   	push   %esi
  801e7b:	6a 00                	push   $0x0
  801e7d:	e8 64 f3 ff ff       	call   8011e6 <sys_page_map>
  801e82:	89 c3                	mov    %eax,%ebx
  801e84:	83 c4 20             	add    $0x20,%esp
  801e87:	85 c0                	test   %eax,%eax
  801e89:	78 58                	js     801ee3 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8e:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801e94:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea3:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801ea9:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eae:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801eb5:	83 ec 0c             	sub    $0xc,%esp
  801eb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebb:	e8 3b f5 ff ff       	call   8013fb <fd2num>
  801ec0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ec3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ec5:	83 c4 04             	add    $0x4,%esp
  801ec8:	ff 75 f0             	pushl  -0x10(%ebp)
  801ecb:	e8 2b f5 ff ff       	call   8013fb <fd2num>
  801ed0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ed3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ed6:	83 c4 10             	add    $0x10,%esp
  801ed9:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ede:	e9 4f ff ff ff       	jmp    801e32 <pipe+0x75>
	sys_page_unmap(0, va);
  801ee3:	83 ec 08             	sub    $0x8,%esp
  801ee6:	56                   	push   %esi
  801ee7:	6a 00                	push   $0x0
  801ee9:	e8 3a f3 ff ff       	call   801228 <sys_page_unmap>
  801eee:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ef1:	83 ec 08             	sub    $0x8,%esp
  801ef4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef7:	6a 00                	push   $0x0
  801ef9:	e8 2a f3 ff ff       	call   801228 <sys_page_unmap>
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	e9 1c ff ff ff       	jmp    801e22 <pipe+0x65>

00801f06 <pipeisclosed>:
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f0f:	50                   	push   %eax
  801f10:	ff 75 08             	pushl  0x8(%ebp)
  801f13:	e8 59 f5 ff ff       	call   801471 <fd_lookup>
  801f18:	83 c4 10             	add    $0x10,%esp
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	78 18                	js     801f37 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f1f:	83 ec 0c             	sub    $0xc,%esp
  801f22:	ff 75 f4             	pushl  -0xc(%ebp)
  801f25:	e8 e1 f4 ff ff       	call   80140b <fd2data>
	return _pipeisclosed(fd, p);
  801f2a:	89 c2                	mov    %eax,%edx
  801f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2f:	e8 30 fd ff ff       	call   801c64 <_pipeisclosed>
  801f34:	83 c4 10             	add    $0x10,%esp
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f41:	5d                   	pop    %ebp
  801f42:	c3                   	ret    

00801f43 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f49:	68 8a 2b 80 00       	push   $0x802b8a
  801f4e:	ff 75 0c             	pushl  0xc(%ebp)
  801f51:	e8 54 ee ff ff       	call   800daa <strcpy>
	return 0;
}
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <devcons_write>:
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	57                   	push   %edi
  801f61:	56                   	push   %esi
  801f62:	53                   	push   %ebx
  801f63:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f69:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f6e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f74:	eb 2f                	jmp    801fa5 <devcons_write+0x48>
		m = n - tot;
  801f76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f79:	29 f3                	sub    %esi,%ebx
  801f7b:	83 fb 7f             	cmp    $0x7f,%ebx
  801f7e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f83:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	53                   	push   %ebx
  801f8a:	89 f0                	mov    %esi,%eax
  801f8c:	03 45 0c             	add    0xc(%ebp),%eax
  801f8f:	50                   	push   %eax
  801f90:	57                   	push   %edi
  801f91:	e8 a2 ef ff ff       	call   800f38 <memmove>
		sys_cputs(buf, m);
  801f96:	83 c4 08             	add    $0x8,%esp
  801f99:	53                   	push   %ebx
  801f9a:	57                   	push   %edi
  801f9b:	e8 47 f1 ff ff       	call   8010e7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fa0:	01 de                	add    %ebx,%esi
  801fa2:	83 c4 10             	add    $0x10,%esp
  801fa5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fa8:	72 cc                	jb     801f76 <devcons_write+0x19>
}
  801faa:	89 f0                	mov    %esi,%eax
  801fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801faf:	5b                   	pop    %ebx
  801fb0:	5e                   	pop    %esi
  801fb1:	5f                   	pop    %edi
  801fb2:	5d                   	pop    %ebp
  801fb3:	c3                   	ret    

00801fb4 <devcons_read>:
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 08             	sub    $0x8,%esp
  801fba:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fc3:	75 07                	jne    801fcc <devcons_read+0x18>
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    
		sys_yield();
  801fc7:	e8 b8 f1 ff ff       	call   801184 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801fcc:	e8 34 f1 ff ff       	call   801105 <sys_cgetc>
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	74 f2                	je     801fc7 <devcons_read+0x13>
	if (c < 0)
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	78 ec                	js     801fc5 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801fd9:	83 f8 04             	cmp    $0x4,%eax
  801fdc:	74 0c                	je     801fea <devcons_read+0x36>
	*(char*)vbuf = c;
  801fde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe1:	88 02                	mov    %al,(%edx)
	return 1;
  801fe3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe8:	eb db                	jmp    801fc5 <devcons_read+0x11>
		return 0;
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
  801fef:	eb d4                	jmp    801fc5 <devcons_read+0x11>

00801ff1 <cputchar>:
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ffd:	6a 01                	push   $0x1
  801fff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802002:	50                   	push   %eax
  802003:	e8 df f0 ff ff       	call   8010e7 <sys_cputs>
}
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <getchar>:
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802013:	6a 01                	push   $0x1
  802015:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802018:	50                   	push   %eax
  802019:	6a 00                	push   $0x0
  80201b:	e8 c2 f6 ff ff       	call   8016e2 <read>
	if (r < 0)
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	85 c0                	test   %eax,%eax
  802025:	78 08                	js     80202f <getchar+0x22>
	if (r < 1)
  802027:	85 c0                	test   %eax,%eax
  802029:	7e 06                	jle    802031 <getchar+0x24>
	return c;
  80202b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    
		return -E_EOF;
  802031:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802036:	eb f7                	jmp    80202f <getchar+0x22>

00802038 <iscons>:
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80203e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802041:	50                   	push   %eax
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	e8 27 f4 ff ff       	call   801471 <fd_lookup>
  80204a:	83 c4 10             	add    $0x10,%esp
  80204d:	85 c0                	test   %eax,%eax
  80204f:	78 11                	js     802062 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802054:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80205a:	39 10                	cmp    %edx,(%eax)
  80205c:	0f 94 c0             	sete   %al
  80205f:	0f b6 c0             	movzbl %al,%eax
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <opencons>:
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80206a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80206d:	50                   	push   %eax
  80206e:	e8 af f3 ff ff       	call   801422 <fd_alloc>
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	85 c0                	test   %eax,%eax
  802078:	78 3a                	js     8020b4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80207a:	83 ec 04             	sub    $0x4,%esp
  80207d:	68 07 04 00 00       	push   $0x407
  802082:	ff 75 f4             	pushl  -0xc(%ebp)
  802085:	6a 00                	push   $0x0
  802087:	e8 17 f1 ff ff       	call   8011a3 <sys_page_alloc>
  80208c:	83 c4 10             	add    $0x10,%esp
  80208f:	85 c0                	test   %eax,%eax
  802091:	78 21                	js     8020b4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80209c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020a8:	83 ec 0c             	sub    $0xc,%esp
  8020ab:	50                   	push   %eax
  8020ac:	e8 4a f3 ff ff       	call   8013fb <fd2num>
  8020b1:	83 c4 10             	add    $0x10,%esp
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020bc:	89 d0                	mov    %edx,%eax
  8020be:	c1 e8 16             	shr    $0x16,%eax
  8020c1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020c8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020cd:	f6 c1 01             	test   $0x1,%cl
  8020d0:	74 1d                	je     8020ef <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020d2:	c1 ea 0c             	shr    $0xc,%edx
  8020d5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020dc:	f6 c2 01             	test   $0x1,%dl
  8020df:	74 0e                	je     8020ef <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020e1:	c1 ea 0c             	shr    $0xc,%edx
  8020e4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020eb:	ef 
  8020ec:	0f b7 c0             	movzwl %ax,%eax
}
  8020ef:	5d                   	pop    %ebp
  8020f0:	c3                   	ret    
  8020f1:	66 90                	xchg   %ax,%ax
  8020f3:	66 90                	xchg   %ax,%ax
  8020f5:	66 90                	xchg   %ax,%ax
  8020f7:	66 90                	xchg   %ax,%ax
  8020f9:	66 90                	xchg   %ax,%ax
  8020fb:	66 90                	xchg   %ax,%ax
  8020fd:	66 90                	xchg   %ax,%ax
  8020ff:	90                   	nop

00802100 <__udivdi3>:
  802100:	55                   	push   %ebp
  802101:	57                   	push   %edi
  802102:	56                   	push   %esi
  802103:	53                   	push   %ebx
  802104:	83 ec 1c             	sub    $0x1c,%esp
  802107:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80210b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80210f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802113:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802117:	85 d2                	test   %edx,%edx
  802119:	75 35                	jne    802150 <__udivdi3+0x50>
  80211b:	39 f3                	cmp    %esi,%ebx
  80211d:	0f 87 bd 00 00 00    	ja     8021e0 <__udivdi3+0xe0>
  802123:	85 db                	test   %ebx,%ebx
  802125:	89 d9                	mov    %ebx,%ecx
  802127:	75 0b                	jne    802134 <__udivdi3+0x34>
  802129:	b8 01 00 00 00       	mov    $0x1,%eax
  80212e:	31 d2                	xor    %edx,%edx
  802130:	f7 f3                	div    %ebx
  802132:	89 c1                	mov    %eax,%ecx
  802134:	31 d2                	xor    %edx,%edx
  802136:	89 f0                	mov    %esi,%eax
  802138:	f7 f1                	div    %ecx
  80213a:	89 c6                	mov    %eax,%esi
  80213c:	89 e8                	mov    %ebp,%eax
  80213e:	89 f7                	mov    %esi,%edi
  802140:	f7 f1                	div    %ecx
  802142:	89 fa                	mov    %edi,%edx
  802144:	83 c4 1c             	add    $0x1c,%esp
  802147:	5b                   	pop    %ebx
  802148:	5e                   	pop    %esi
  802149:	5f                   	pop    %edi
  80214a:	5d                   	pop    %ebp
  80214b:	c3                   	ret    
  80214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802150:	39 f2                	cmp    %esi,%edx
  802152:	77 7c                	ja     8021d0 <__udivdi3+0xd0>
  802154:	0f bd fa             	bsr    %edx,%edi
  802157:	83 f7 1f             	xor    $0x1f,%edi
  80215a:	0f 84 98 00 00 00    	je     8021f8 <__udivdi3+0xf8>
  802160:	89 f9                	mov    %edi,%ecx
  802162:	b8 20 00 00 00       	mov    $0x20,%eax
  802167:	29 f8                	sub    %edi,%eax
  802169:	d3 e2                	shl    %cl,%edx
  80216b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80216f:	89 c1                	mov    %eax,%ecx
  802171:	89 da                	mov    %ebx,%edx
  802173:	d3 ea                	shr    %cl,%edx
  802175:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802179:	09 d1                	or     %edx,%ecx
  80217b:	89 f2                	mov    %esi,%edx
  80217d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802181:	89 f9                	mov    %edi,%ecx
  802183:	d3 e3                	shl    %cl,%ebx
  802185:	89 c1                	mov    %eax,%ecx
  802187:	d3 ea                	shr    %cl,%edx
  802189:	89 f9                	mov    %edi,%ecx
  80218b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80218f:	d3 e6                	shl    %cl,%esi
  802191:	89 eb                	mov    %ebp,%ebx
  802193:	89 c1                	mov    %eax,%ecx
  802195:	d3 eb                	shr    %cl,%ebx
  802197:	09 de                	or     %ebx,%esi
  802199:	89 f0                	mov    %esi,%eax
  80219b:	f7 74 24 08          	divl   0x8(%esp)
  80219f:	89 d6                	mov    %edx,%esi
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	f7 64 24 0c          	mull   0xc(%esp)
  8021a7:	39 d6                	cmp    %edx,%esi
  8021a9:	72 0c                	jb     8021b7 <__udivdi3+0xb7>
  8021ab:	89 f9                	mov    %edi,%ecx
  8021ad:	d3 e5                	shl    %cl,%ebp
  8021af:	39 c5                	cmp    %eax,%ebp
  8021b1:	73 5d                	jae    802210 <__udivdi3+0x110>
  8021b3:	39 d6                	cmp    %edx,%esi
  8021b5:	75 59                	jne    802210 <__udivdi3+0x110>
  8021b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021ba:	31 ff                	xor    %edi,%edi
  8021bc:	89 fa                	mov    %edi,%edx
  8021be:	83 c4 1c             	add    $0x1c,%esp
  8021c1:	5b                   	pop    %ebx
  8021c2:	5e                   	pop    %esi
  8021c3:	5f                   	pop    %edi
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    
  8021c6:	8d 76 00             	lea    0x0(%esi),%esi
  8021c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021d0:	31 ff                	xor    %edi,%edi
  8021d2:	31 c0                	xor    %eax,%eax
  8021d4:	89 fa                	mov    %edi,%edx
  8021d6:	83 c4 1c             	add    $0x1c,%esp
  8021d9:	5b                   	pop    %ebx
  8021da:	5e                   	pop    %esi
  8021db:	5f                   	pop    %edi
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    
  8021de:	66 90                	xchg   %ax,%ax
  8021e0:	31 ff                	xor    %edi,%edi
  8021e2:	89 e8                	mov    %ebp,%eax
  8021e4:	89 f2                	mov    %esi,%edx
  8021e6:	f7 f3                	div    %ebx
  8021e8:	89 fa                	mov    %edi,%edx
  8021ea:	83 c4 1c             	add    $0x1c,%esp
  8021ed:	5b                   	pop    %ebx
  8021ee:	5e                   	pop    %esi
  8021ef:	5f                   	pop    %edi
  8021f0:	5d                   	pop    %ebp
  8021f1:	c3                   	ret    
  8021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021f8:	39 f2                	cmp    %esi,%edx
  8021fa:	72 06                	jb     802202 <__udivdi3+0x102>
  8021fc:	31 c0                	xor    %eax,%eax
  8021fe:	39 eb                	cmp    %ebp,%ebx
  802200:	77 d2                	ja     8021d4 <__udivdi3+0xd4>
  802202:	b8 01 00 00 00       	mov    $0x1,%eax
  802207:	eb cb                	jmp    8021d4 <__udivdi3+0xd4>
  802209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802210:	89 d8                	mov    %ebx,%eax
  802212:	31 ff                	xor    %edi,%edi
  802214:	eb be                	jmp    8021d4 <__udivdi3+0xd4>
  802216:	66 90                	xchg   %ax,%ax
  802218:	66 90                	xchg   %ax,%ax
  80221a:	66 90                	xchg   %ax,%ax
  80221c:	66 90                	xchg   %ax,%ax
  80221e:	66 90                	xchg   %ax,%ax

00802220 <__umoddi3>:
  802220:	55                   	push   %ebp
  802221:	57                   	push   %edi
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	83 ec 1c             	sub    $0x1c,%esp
  802227:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80222b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80222f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802233:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802237:	85 ed                	test   %ebp,%ebp
  802239:	89 f0                	mov    %esi,%eax
  80223b:	89 da                	mov    %ebx,%edx
  80223d:	75 19                	jne    802258 <__umoddi3+0x38>
  80223f:	39 df                	cmp    %ebx,%edi
  802241:	0f 86 b1 00 00 00    	jbe    8022f8 <__umoddi3+0xd8>
  802247:	f7 f7                	div    %edi
  802249:	89 d0                	mov    %edx,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	39 dd                	cmp    %ebx,%ebp
  80225a:	77 f1                	ja     80224d <__umoddi3+0x2d>
  80225c:	0f bd cd             	bsr    %ebp,%ecx
  80225f:	83 f1 1f             	xor    $0x1f,%ecx
  802262:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802266:	0f 84 b4 00 00 00    	je     802320 <__umoddi3+0x100>
  80226c:	b8 20 00 00 00       	mov    $0x20,%eax
  802271:	89 c2                	mov    %eax,%edx
  802273:	8b 44 24 04          	mov    0x4(%esp),%eax
  802277:	29 c2                	sub    %eax,%edx
  802279:	89 c1                	mov    %eax,%ecx
  80227b:	89 f8                	mov    %edi,%eax
  80227d:	d3 e5                	shl    %cl,%ebp
  80227f:	89 d1                	mov    %edx,%ecx
  802281:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802285:	d3 e8                	shr    %cl,%eax
  802287:	09 c5                	or     %eax,%ebp
  802289:	8b 44 24 04          	mov    0x4(%esp),%eax
  80228d:	89 c1                	mov    %eax,%ecx
  80228f:	d3 e7                	shl    %cl,%edi
  802291:	89 d1                	mov    %edx,%ecx
  802293:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802297:	89 df                	mov    %ebx,%edi
  802299:	d3 ef                	shr    %cl,%edi
  80229b:	89 c1                	mov    %eax,%ecx
  80229d:	89 f0                	mov    %esi,%eax
  80229f:	d3 e3                	shl    %cl,%ebx
  8022a1:	89 d1                	mov    %edx,%ecx
  8022a3:	89 fa                	mov    %edi,%edx
  8022a5:	d3 e8                	shr    %cl,%eax
  8022a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022ac:	09 d8                	or     %ebx,%eax
  8022ae:	f7 f5                	div    %ebp
  8022b0:	d3 e6                	shl    %cl,%esi
  8022b2:	89 d1                	mov    %edx,%ecx
  8022b4:	f7 64 24 08          	mull   0x8(%esp)
  8022b8:	39 d1                	cmp    %edx,%ecx
  8022ba:	89 c3                	mov    %eax,%ebx
  8022bc:	89 d7                	mov    %edx,%edi
  8022be:	72 06                	jb     8022c6 <__umoddi3+0xa6>
  8022c0:	75 0e                	jne    8022d0 <__umoddi3+0xb0>
  8022c2:	39 c6                	cmp    %eax,%esi
  8022c4:	73 0a                	jae    8022d0 <__umoddi3+0xb0>
  8022c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8022ca:	19 ea                	sbb    %ebp,%edx
  8022cc:	89 d7                	mov    %edx,%edi
  8022ce:	89 c3                	mov    %eax,%ebx
  8022d0:	89 ca                	mov    %ecx,%edx
  8022d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022d7:	29 de                	sub    %ebx,%esi
  8022d9:	19 fa                	sbb    %edi,%edx
  8022db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022df:	89 d0                	mov    %edx,%eax
  8022e1:	d3 e0                	shl    %cl,%eax
  8022e3:	89 d9                	mov    %ebx,%ecx
  8022e5:	d3 ee                	shr    %cl,%esi
  8022e7:	d3 ea                	shr    %cl,%edx
  8022e9:	09 f0                	or     %esi,%eax
  8022eb:	83 c4 1c             	add    $0x1c,%esp
  8022ee:	5b                   	pop    %ebx
  8022ef:	5e                   	pop    %esi
  8022f0:	5f                   	pop    %edi
  8022f1:	5d                   	pop    %ebp
  8022f2:	c3                   	ret    
  8022f3:	90                   	nop
  8022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022f8:	85 ff                	test   %edi,%edi
  8022fa:	89 f9                	mov    %edi,%ecx
  8022fc:	75 0b                	jne    802309 <__umoddi3+0xe9>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f7                	div    %edi
  802307:	89 c1                	mov    %eax,%ecx
  802309:	89 d8                	mov    %ebx,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	f7 f1                	div    %ecx
  80230f:	89 f0                	mov    %esi,%eax
  802311:	f7 f1                	div    %ecx
  802313:	e9 31 ff ff ff       	jmp    802249 <__umoddi3+0x29>
  802318:	90                   	nop
  802319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802320:	39 dd                	cmp    %ebx,%ebp
  802322:	72 08                	jb     80232c <__umoddi3+0x10c>
  802324:	39 f7                	cmp    %esi,%edi
  802326:	0f 87 21 ff ff ff    	ja     80224d <__umoddi3+0x2d>
  80232c:	89 da                	mov    %ebx,%edx
  80232e:	89 f0                	mov    %esi,%eax
  802330:	29 f8                	sub    %edi,%eax
  802332:	19 ea                	sbb    %ebp,%edx
  802334:	e9 14 ff ff ff       	jmp    80224d <__umoddi3+0x2d>
