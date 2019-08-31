
obj/user/init.debug：     文件格式 elf32-i386


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
  80002c:	e8 6f 03 00 00       	call   8003a0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800043:	ba 00 00 00 00       	mov    $0x0,%edx
  800048:	eb 0c                	jmp    800056 <sum+0x23>
		tot ^= i * s[i];
  80004a:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80004e:	0f af ca             	imul   %edx,%ecx
  800051:	31 c8                	xor    %ecx,%eax
	for (i = 0; i < n; i++)
  800053:	83 c2 01             	add    $0x1,%edx
  800056:	39 da                	cmp    %ebx,%edx
  800058:	7c f0                	jl     80004a <sum+0x17>
	return tot;
}
  80005a:	5b                   	pop    %ebx
  80005b:	5e                   	pop    %esi
  80005c:	5d                   	pop    %ebp
  80005d:	c3                   	ret    

0080005e <umain>:

void
umain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	57                   	push   %edi
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	81 ec 18 01 00 00    	sub    $0x118,%esp
  80006a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80006d:	68 40 25 80 00       	push   $0x802540
  800072:	e8 64 04 00 00       	call   8004db <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800077:	83 c4 08             	add    $0x8,%esp
  80007a:	68 70 17 00 00       	push   $0x1770
  80007f:	68 00 30 80 00       	push   $0x803000
  800084:	e8 aa ff ff ff       	call   800033 <sum>
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  800091:	0f 84 99 00 00 00    	je     800130 <umain+0xd2>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 9e 98 0f 00       	push   $0xf989e
  80009f:	50                   	push   %eax
  8000a0:	68 08 26 80 00       	push   $0x802608
  8000a5:	e8 31 04 00 00       	call   8004db <cprintf>
  8000aa:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	68 70 17 00 00       	push   $0x1770
  8000b5:	68 20 50 80 00       	push   $0x805020
  8000ba:	e8 74 ff ff ff       	call   800033 <sum>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	74 7f                	je     800145 <umain+0xe7>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	50                   	push   %eax
  8000ca:	68 44 26 80 00       	push   $0x802644
  8000cf:	e8 07 04 00 00       	call   8004db <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	68 7c 25 80 00       	push   $0x80257c
  8000df:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000e5:	50                   	push   %eax
  8000e6:	e8 fa 09 00 00       	call   800ae5 <strcat>
	for (i = 0; i < argc; i++) {
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000f3:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  8000f9:	39 fb                	cmp    %edi,%ebx
  8000fb:	7d 5a                	jge    800157 <umain+0xf9>
		strcat(args, " '");
  8000fd:	83 ec 08             	sub    $0x8,%esp
  800100:	68 88 25 80 00       	push   $0x802588
  800105:	56                   	push   %esi
  800106:	e8 da 09 00 00       	call   800ae5 <strcat>
		strcat(args, argv[i]);
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	ff 34 98             	pushl  (%eax,%ebx,4)
  800114:	56                   	push   %esi
  800115:	e8 cb 09 00 00       	call   800ae5 <strcat>
		strcat(args, "'");
  80011a:	83 c4 08             	add    $0x8,%esp
  80011d:	68 89 25 80 00       	push   $0x802589
  800122:	56                   	push   %esi
  800123:	e8 bd 09 00 00       	call   800ae5 <strcat>
	for (i = 0; i < argc; i++) {
  800128:	83 c3 01             	add    $0x1,%ebx
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	eb c9                	jmp    8000f9 <umain+0x9b>
		cprintf("init: data seems okay\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 4f 25 80 00       	push   $0x80254f
  800138:	e8 9e 03 00 00       	call   8004db <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
  800140:	e9 68 ff ff ff       	jmp    8000ad <umain+0x4f>
		cprintf("init: bss seems okay\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 66 25 80 00       	push   $0x802566
  80014d:	e8 89 03 00 00       	call   8004db <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	eb 80                	jmp    8000d7 <umain+0x79>
	}
	cprintf("%s\n", args);
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800160:	50                   	push   %eax
  800161:	68 8b 25 80 00       	push   $0x80258b
  800166:	e8 70 03 00 00       	call   8004db <cprintf>

	cprintf("init: running sh\n");
  80016b:	c7 04 24 8f 25 80 00 	movl   $0x80258f,(%esp)
  800172:	e8 64 03 00 00       	call   8004db <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 d7 10 00 00       	call   80125a <close>
	if ((r = opencons()) < 0)
  800183:	e8 c6 01 00 00       	call   80034e <opencons>
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	85 c0                	test   %eax,%eax
  80018d:	78 16                	js     8001a5 <umain+0x147>
		panic("opencons: %e", r);
	if (r != 0)
  80018f:	85 c0                	test   %eax,%eax
  800191:	74 24                	je     8001b7 <umain+0x159>
		panic("first opencons used fd %d", r);
  800193:	50                   	push   %eax
  800194:	68 ba 25 80 00       	push   $0x8025ba
  800199:	6a 39                	push   $0x39
  80019b:	68 ae 25 80 00       	push   $0x8025ae
  8001a0:	e8 5b 02 00 00       	call   800400 <_panic>
		panic("opencons: %e", r);
  8001a5:	50                   	push   %eax
  8001a6:	68 a1 25 80 00       	push   $0x8025a1
  8001ab:	6a 37                	push   $0x37
  8001ad:	68 ae 25 80 00       	push   $0x8025ae
  8001b2:	e8 49 02 00 00       	call   800400 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	6a 01                	push   $0x1
  8001bc:	6a 00                	push   $0x0
  8001be:	e8 e7 10 00 00       	call   8012aa <dup>
  8001c3:	83 c4 10             	add    $0x10,%esp
  8001c6:	85 c0                	test   %eax,%eax
  8001c8:	79 23                	jns    8001ed <umain+0x18f>
		panic("dup: %e", r);
  8001ca:	50                   	push   %eax
  8001cb:	68 d4 25 80 00       	push   $0x8025d4
  8001d0:	6a 3b                	push   $0x3b
  8001d2:	68 ae 25 80 00       	push   $0x8025ae
  8001d7:	e8 24 02 00 00       	call   800400 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	50                   	push   %eax
  8001e0:	68 f3 25 80 00       	push   $0x8025f3
  8001e5:	e8 f1 02 00 00       	call   8004db <cprintf>
			continue;
  8001ea:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	68 dc 25 80 00       	push   $0x8025dc
  8001f5:	e8 e1 02 00 00       	call   8004db <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001fa:	83 c4 0c             	add    $0xc,%esp
  8001fd:	6a 00                	push   $0x0
  8001ff:	68 f0 25 80 00       	push   $0x8025f0
  800204:	68 ef 25 80 00       	push   $0x8025ef
  800209:	e8 2b 1c 00 00       	call   801e39 <spawnl>
		if (r < 0) {
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	85 c0                	test   %eax,%eax
  800213:	78 c7                	js     8001dc <umain+0x17e>
		}
		wait(r);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	e8 e5 1f 00 00       	call   802203 <wait>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	eb ca                	jmp    8001ed <umain+0x18f>

00800223 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800226:	b8 00 00 00 00       	mov    $0x0,%eax
  80022b:	5d                   	pop    %ebp
  80022c:	c3                   	ret    

0080022d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800233:	68 73 26 80 00       	push   $0x802673
  800238:	ff 75 0c             	pushl  0xc(%ebp)
  80023b:	e8 85 08 00 00       	call   800ac5 <strcpy>
	return 0;
}
  800240:	b8 00 00 00 00       	mov    $0x0,%eax
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <devcons_write>:
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800253:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800258:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80025e:	eb 2f                	jmp    80028f <devcons_write+0x48>
		m = n - tot;
  800260:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800263:	29 f3                	sub    %esi,%ebx
  800265:	83 fb 7f             	cmp    $0x7f,%ebx
  800268:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80026d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	53                   	push   %ebx
  800274:	89 f0                	mov    %esi,%eax
  800276:	03 45 0c             	add    0xc(%ebp),%eax
  800279:	50                   	push   %eax
  80027a:	57                   	push   %edi
  80027b:	e8 d3 09 00 00       	call   800c53 <memmove>
		sys_cputs(buf, m);
  800280:	83 c4 08             	add    $0x8,%esp
  800283:	53                   	push   %ebx
  800284:	57                   	push   %edi
  800285:	e8 78 0b 00 00       	call   800e02 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80028a:	01 de                	add    %ebx,%esi
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	3b 75 10             	cmp    0x10(%ebp),%esi
  800292:	72 cc                	jb     800260 <devcons_write+0x19>
}
  800294:	89 f0                	mov    %esi,%eax
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <devcons_read>:
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	83 ec 08             	sub    $0x8,%esp
  8002a4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8002a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002ad:	75 07                	jne    8002b6 <devcons_read+0x18>
}
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    
		sys_yield();
  8002b1:	e8 e9 0b 00 00       	call   800e9f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8002b6:	e8 65 0b 00 00       	call   800e20 <sys_cgetc>
  8002bb:	85 c0                	test   %eax,%eax
  8002bd:	74 f2                	je     8002b1 <devcons_read+0x13>
	if (c < 0)
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	78 ec                	js     8002af <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8002c3:	83 f8 04             	cmp    $0x4,%eax
  8002c6:	74 0c                	je     8002d4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8002c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cb:	88 02                	mov    %al,(%edx)
	return 1;
  8002cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8002d2:	eb db                	jmp    8002af <devcons_read+0x11>
		return 0;
  8002d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d9:	eb d4                	jmp    8002af <devcons_read+0x11>

008002db <cputchar>:
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002e7:	6a 01                	push   $0x1
  8002e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002ec:	50                   	push   %eax
  8002ed:	e8 10 0b 00 00       	call   800e02 <sys_cputs>
}
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <getchar>:
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8002fd:	6a 01                	push   $0x1
  8002ff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	6a 00                	push   $0x0
  800305:	e8 8c 10 00 00       	call   801396 <read>
	if (r < 0)
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	85 c0                	test   %eax,%eax
  80030f:	78 08                	js     800319 <getchar+0x22>
	if (r < 1)
  800311:	85 c0                	test   %eax,%eax
  800313:	7e 06                	jle    80031b <getchar+0x24>
	return c;
  800315:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    
		return -E_EOF;
  80031b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800320:	eb f7                	jmp    800319 <getchar+0x22>

00800322 <iscons>:
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800328:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80032b:	50                   	push   %eax
  80032c:	ff 75 08             	pushl  0x8(%ebp)
  80032f:	e8 f1 0d 00 00       	call   801125 <fd_lookup>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	85 c0                	test   %eax,%eax
  800339:	78 11                	js     80034c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80033b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80033e:	8b 15 70 47 80 00    	mov    0x804770,%edx
  800344:	39 10                	cmp    %edx,(%eax)
  800346:	0f 94 c0             	sete   %al
  800349:	0f b6 c0             	movzbl %al,%eax
}
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <opencons>:
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800354:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800357:	50                   	push   %eax
  800358:	e8 79 0d 00 00       	call   8010d6 <fd_alloc>
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	85 c0                	test   %eax,%eax
  800362:	78 3a                	js     80039e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800364:	83 ec 04             	sub    $0x4,%esp
  800367:	68 07 04 00 00       	push   $0x407
  80036c:	ff 75 f4             	pushl  -0xc(%ebp)
  80036f:	6a 00                	push   $0x0
  800371:	e8 48 0b 00 00       	call   800ebe <sys_page_alloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	85 c0                	test   %eax,%eax
  80037b:	78 21                	js     80039e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80037d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800380:	8b 15 70 47 80 00    	mov    0x804770,%edx
  800386:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800392:	83 ec 0c             	sub    $0xc,%esp
  800395:	50                   	push   %eax
  800396:	e8 14 0d 00 00       	call   8010af <fd2num>
  80039b:	83 c4 10             	add    $0x10,%esp
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	56                   	push   %esi
  8003a4:	53                   	push   %ebx
  8003a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8003ab:	e8 d0 0a 00 00       	call   800e80 <sys_getenvid>
  8003b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003bd:	a3 90 67 80 00       	mov    %eax,0x806790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c2:	85 db                	test   %ebx,%ebx
  8003c4:	7e 07                	jle    8003cd <libmain+0x2d>
		binaryname = argv[0];
  8003c6:	8b 06                	mov    (%esi),%eax
  8003c8:	a3 8c 47 80 00       	mov    %eax,0x80478c

	// call user main routine
	umain(argc, argv);
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	56                   	push   %esi
  8003d1:	53                   	push   %ebx
  8003d2:	e8 87 fc ff ff       	call   80005e <umain>

	// exit gracefully
	exit();
  8003d7:	e8 0a 00 00 00       	call   8003e6 <exit>
}
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003e2:	5b                   	pop    %ebx
  8003e3:	5e                   	pop    %esi
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8003ec:	e8 94 0e 00 00       	call   801285 <close_all>
	sys_env_destroy(0);
  8003f1:	83 ec 0c             	sub    $0xc,%esp
  8003f4:	6a 00                	push   $0x0
  8003f6:	e8 44 0a 00 00       	call   800e3f <sys_env_destroy>
}
  8003fb:	83 c4 10             	add    $0x10,%esp
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	56                   	push   %esi
  800404:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800405:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800408:	8b 35 8c 47 80 00    	mov    0x80478c,%esi
  80040e:	e8 6d 0a 00 00       	call   800e80 <sys_getenvid>
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	ff 75 0c             	pushl  0xc(%ebp)
  800419:	ff 75 08             	pushl  0x8(%ebp)
  80041c:	56                   	push   %esi
  80041d:	50                   	push   %eax
  80041e:	68 8c 26 80 00       	push   $0x80268c
  800423:	e8 b3 00 00 00       	call   8004db <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800428:	83 c4 18             	add    $0x18,%esp
  80042b:	53                   	push   %ebx
  80042c:	ff 75 10             	pushl  0x10(%ebp)
  80042f:	e8 56 00 00 00       	call   80048a <vcprintf>
	cprintf("\n");
  800434:	c7 04 24 78 2b 80 00 	movl   $0x802b78,(%esp)
  80043b:	e8 9b 00 00 00       	call   8004db <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800443:	cc                   	int3   
  800444:	eb fd                	jmp    800443 <_panic+0x43>

00800446 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	53                   	push   %ebx
  80044a:	83 ec 04             	sub    $0x4,%esp
  80044d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800450:	8b 13                	mov    (%ebx),%edx
  800452:	8d 42 01             	lea    0x1(%edx),%eax
  800455:	89 03                	mov    %eax,(%ebx)
  800457:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80045a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80045e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800463:	74 09                	je     80046e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800465:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800469:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	68 ff 00 00 00       	push   $0xff
  800476:	8d 43 08             	lea    0x8(%ebx),%eax
  800479:	50                   	push   %eax
  80047a:	e8 83 09 00 00       	call   800e02 <sys_cputs>
		b->idx = 0;
  80047f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	eb db                	jmp    800465 <putch+0x1f>

0080048a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800493:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80049a:	00 00 00 
	b.cnt = 0;
  80049d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004a4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004a7:	ff 75 0c             	pushl  0xc(%ebp)
  8004aa:	ff 75 08             	pushl  0x8(%ebp)
  8004ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b3:	50                   	push   %eax
  8004b4:	68 46 04 80 00       	push   $0x800446
  8004b9:	e8 1a 01 00 00       	call   8005d8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004be:	83 c4 08             	add    $0x8,%esp
  8004c1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004c7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 2f 09 00 00       	call   800e02 <sys_cputs>

	return b.cnt;
}
  8004d3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004e1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004e4:	50                   	push   %eax
  8004e5:	ff 75 08             	pushl  0x8(%ebp)
  8004e8:	e8 9d ff ff ff       	call   80048a <vcprintf>
	va_end(ap);

	return cnt;
}
  8004ed:	c9                   	leave  
  8004ee:	c3                   	ret    

008004ef <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	57                   	push   %edi
  8004f3:	56                   	push   %esi
  8004f4:	53                   	push   %ebx
  8004f5:	83 ec 1c             	sub    $0x1c,%esp
  8004f8:	89 c7                	mov    %eax,%edi
  8004fa:	89 d6                	mov    %edx,%esi
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800505:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800508:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80050b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800510:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800513:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800516:	39 d3                	cmp    %edx,%ebx
  800518:	72 05                	jb     80051f <printnum+0x30>
  80051a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80051d:	77 7a                	ja     800599 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	ff 75 18             	pushl  0x18(%ebp)
  800525:	8b 45 14             	mov    0x14(%ebp),%eax
  800528:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80052b:	53                   	push   %ebx
  80052c:	ff 75 10             	pushl  0x10(%ebp)
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	ff 75 e4             	pushl  -0x1c(%ebp)
  800535:	ff 75 e0             	pushl  -0x20(%ebp)
  800538:	ff 75 dc             	pushl  -0x24(%ebp)
  80053b:	ff 75 d8             	pushl  -0x28(%ebp)
  80053e:	e8 bd 1d 00 00       	call   802300 <__udivdi3>
  800543:	83 c4 18             	add    $0x18,%esp
  800546:	52                   	push   %edx
  800547:	50                   	push   %eax
  800548:	89 f2                	mov    %esi,%edx
  80054a:	89 f8                	mov    %edi,%eax
  80054c:	e8 9e ff ff ff       	call   8004ef <printnum>
  800551:	83 c4 20             	add    $0x20,%esp
  800554:	eb 13                	jmp    800569 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	56                   	push   %esi
  80055a:	ff 75 18             	pushl  0x18(%ebp)
  80055d:	ff d7                	call   *%edi
  80055f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800562:	83 eb 01             	sub    $0x1,%ebx
  800565:	85 db                	test   %ebx,%ebx
  800567:	7f ed                	jg     800556 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	56                   	push   %esi
  80056d:	83 ec 04             	sub    $0x4,%esp
  800570:	ff 75 e4             	pushl  -0x1c(%ebp)
  800573:	ff 75 e0             	pushl  -0x20(%ebp)
  800576:	ff 75 dc             	pushl  -0x24(%ebp)
  800579:	ff 75 d8             	pushl  -0x28(%ebp)
  80057c:	e8 9f 1e 00 00       	call   802420 <__umoddi3>
  800581:	83 c4 14             	add    $0x14,%esp
  800584:	0f be 80 af 26 80 00 	movsbl 0x8026af(%eax),%eax
  80058b:	50                   	push   %eax
  80058c:	ff d7                	call   *%edi
}
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800594:	5b                   	pop    %ebx
  800595:	5e                   	pop    %esi
  800596:	5f                   	pop    %edi
  800597:	5d                   	pop    %ebp
  800598:	c3                   	ret    
  800599:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80059c:	eb c4                	jmp    800562 <printnum+0x73>

0080059e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005a4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005a8:	8b 10                	mov    (%eax),%edx
  8005aa:	3b 50 04             	cmp    0x4(%eax),%edx
  8005ad:	73 0a                	jae    8005b9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005b2:	89 08                	mov    %ecx,(%eax)
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	88 02                	mov    %al,(%edx)
}
  8005b9:	5d                   	pop    %ebp
  8005ba:	c3                   	ret    

008005bb <printfmt>:
{
  8005bb:	55                   	push   %ebp
  8005bc:	89 e5                	mov    %esp,%ebp
  8005be:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005c1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005c4:	50                   	push   %eax
  8005c5:	ff 75 10             	pushl  0x10(%ebp)
  8005c8:	ff 75 0c             	pushl  0xc(%ebp)
  8005cb:	ff 75 08             	pushl  0x8(%ebp)
  8005ce:	e8 05 00 00 00       	call   8005d8 <vprintfmt>
}
  8005d3:	83 c4 10             	add    $0x10,%esp
  8005d6:	c9                   	leave  
  8005d7:	c3                   	ret    

008005d8 <vprintfmt>:
{
  8005d8:	55                   	push   %ebp
  8005d9:	89 e5                	mov    %esp,%ebp
  8005db:	57                   	push   %edi
  8005dc:	56                   	push   %esi
  8005dd:	53                   	push   %ebx
  8005de:	83 ec 2c             	sub    $0x2c,%esp
  8005e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005e7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8005ea:	e9 8c 03 00 00       	jmp    80097b <vprintfmt+0x3a3>
		padc = ' ';
  8005ef:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8005f3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8005fa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800601:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800608:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80060d:	8d 47 01             	lea    0x1(%edi),%eax
  800610:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800613:	0f b6 17             	movzbl (%edi),%edx
  800616:	8d 42 dd             	lea    -0x23(%edx),%eax
  800619:	3c 55                	cmp    $0x55,%al
  80061b:	0f 87 dd 03 00 00    	ja     8009fe <vprintfmt+0x426>
  800621:	0f b6 c0             	movzbl %al,%eax
  800624:	ff 24 85 00 28 80 00 	jmp    *0x802800(,%eax,4)
  80062b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80062e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800632:	eb d9                	jmp    80060d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800634:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800637:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80063b:	eb d0                	jmp    80060d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80063d:	0f b6 d2             	movzbl %dl,%edx
  800640:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800643:	b8 00 00 00 00       	mov    $0x0,%eax
  800648:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80064b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80064e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800652:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800655:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800658:	83 f9 09             	cmp    $0x9,%ecx
  80065b:	77 55                	ja     8006b2 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80065d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800660:	eb e9                	jmp    80064b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8d 40 04             	lea    0x4(%eax),%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800673:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800676:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067a:	79 91                	jns    80060d <vprintfmt+0x35>
				width = precision, precision = -1;
  80067c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80067f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800682:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800689:	eb 82                	jmp    80060d <vprintfmt+0x35>
  80068b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80068e:	85 c0                	test   %eax,%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
  800695:	0f 49 d0             	cmovns %eax,%edx
  800698:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80069b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80069e:	e9 6a ff ff ff       	jmp    80060d <vprintfmt+0x35>
  8006a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006a6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8006ad:	e9 5b ff ff ff       	jmp    80060d <vprintfmt+0x35>
  8006b2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006b8:	eb bc                	jmp    800676 <vprintfmt+0x9e>
			lflag++;
  8006ba:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006c0:	e9 48 ff ff ff       	jmp    80060d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8d 78 04             	lea    0x4(%eax),%edi
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	53                   	push   %ebx
  8006cf:	ff 30                	pushl  (%eax)
  8006d1:	ff d6                	call   *%esi
			break;
  8006d3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8006d6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8006d9:	e9 9a 02 00 00       	jmp    800978 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 78 04             	lea    0x4(%eax),%edi
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	99                   	cltd   
  8006e7:	31 d0                	xor    %edx,%eax
  8006e9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006eb:	83 f8 0f             	cmp    $0xf,%eax
  8006ee:	7f 23                	jg     800713 <vprintfmt+0x13b>
  8006f0:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  8006f7:	85 d2                	test   %edx,%edx
  8006f9:	74 18                	je     800713 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8006fb:	52                   	push   %edx
  8006fc:	68 91 2a 80 00       	push   $0x802a91
  800701:	53                   	push   %ebx
  800702:	56                   	push   %esi
  800703:	e8 b3 fe ff ff       	call   8005bb <printfmt>
  800708:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80070b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80070e:	e9 65 02 00 00       	jmp    800978 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800713:	50                   	push   %eax
  800714:	68 c7 26 80 00       	push   $0x8026c7
  800719:	53                   	push   %ebx
  80071a:	56                   	push   %esi
  80071b:	e8 9b fe ff ff       	call   8005bb <printfmt>
  800720:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800723:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800726:	e9 4d 02 00 00       	jmp    800978 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	83 c0 04             	add    $0x4,%eax
  800731:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800739:	85 ff                	test   %edi,%edi
  80073b:	b8 c0 26 80 00       	mov    $0x8026c0,%eax
  800740:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800743:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800747:	0f 8e bd 00 00 00    	jle    80080a <vprintfmt+0x232>
  80074d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800751:	75 0e                	jne    800761 <vprintfmt+0x189>
  800753:	89 75 08             	mov    %esi,0x8(%ebp)
  800756:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800759:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80075c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80075f:	eb 6d                	jmp    8007ce <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 d0             	pushl  -0x30(%ebp)
  800767:	57                   	push   %edi
  800768:	e8 39 03 00 00       	call   800aa6 <strnlen>
  80076d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800770:	29 c1                	sub    %eax,%ecx
  800772:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800775:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800778:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80077c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80077f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800782:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800784:	eb 0f                	jmp    800795 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	ff 75 e0             	pushl  -0x20(%ebp)
  80078d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80078f:	83 ef 01             	sub    $0x1,%edi
  800792:	83 c4 10             	add    $0x10,%esp
  800795:	85 ff                	test   %edi,%edi
  800797:	7f ed                	jg     800786 <vprintfmt+0x1ae>
  800799:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80079c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80079f:	85 c9                	test   %ecx,%ecx
  8007a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a6:	0f 49 c1             	cmovns %ecx,%eax
  8007a9:	29 c1                	sub    %eax,%ecx
  8007ab:	89 75 08             	mov    %esi,0x8(%ebp)
  8007ae:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8007b1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8007b4:	89 cb                	mov    %ecx,%ebx
  8007b6:	eb 16                	jmp    8007ce <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8007b8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007bc:	75 31                	jne    8007ef <vprintfmt+0x217>
					putch(ch, putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	ff 75 0c             	pushl  0xc(%ebp)
  8007c4:	50                   	push   %eax
  8007c5:	ff 55 08             	call   *0x8(%ebp)
  8007c8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007cb:	83 eb 01             	sub    $0x1,%ebx
  8007ce:	83 c7 01             	add    $0x1,%edi
  8007d1:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8007d5:	0f be c2             	movsbl %dl,%eax
  8007d8:	85 c0                	test   %eax,%eax
  8007da:	74 59                	je     800835 <vprintfmt+0x25d>
  8007dc:	85 f6                	test   %esi,%esi
  8007de:	78 d8                	js     8007b8 <vprintfmt+0x1e0>
  8007e0:	83 ee 01             	sub    $0x1,%esi
  8007e3:	79 d3                	jns    8007b8 <vprintfmt+0x1e0>
  8007e5:	89 df                	mov    %ebx,%edi
  8007e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007ed:	eb 37                	jmp    800826 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8007ef:	0f be d2             	movsbl %dl,%edx
  8007f2:	83 ea 20             	sub    $0x20,%edx
  8007f5:	83 fa 5e             	cmp    $0x5e,%edx
  8007f8:	76 c4                	jbe    8007be <vprintfmt+0x1e6>
					putch('?', putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 0c             	pushl  0xc(%ebp)
  800800:	6a 3f                	push   $0x3f
  800802:	ff 55 08             	call   *0x8(%ebp)
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	eb c1                	jmp    8007cb <vprintfmt+0x1f3>
  80080a:	89 75 08             	mov    %esi,0x8(%ebp)
  80080d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800810:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800813:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800816:	eb b6                	jmp    8007ce <vprintfmt+0x1f6>
				putch(' ', putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	6a 20                	push   $0x20
  80081e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800820:	83 ef 01             	sub    $0x1,%edi
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	85 ff                	test   %edi,%edi
  800828:	7f ee                	jg     800818 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80082a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
  800830:	e9 43 01 00 00       	jmp    800978 <vprintfmt+0x3a0>
  800835:	89 df                	mov    %ebx,%edi
  800837:	8b 75 08             	mov    0x8(%ebp),%esi
  80083a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80083d:	eb e7                	jmp    800826 <vprintfmt+0x24e>
	if (lflag >= 2)
  80083f:	83 f9 01             	cmp    $0x1,%ecx
  800842:	7e 3f                	jle    800883 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 50 04             	mov    0x4(%eax),%edx
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8d 40 08             	lea    0x8(%eax),%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80085b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80085f:	79 5c                	jns    8008bd <vprintfmt+0x2e5>
				putch('-', putdat);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	53                   	push   %ebx
  800865:	6a 2d                	push   $0x2d
  800867:	ff d6                	call   *%esi
				num = -(long long) num;
  800869:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80086c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80086f:	f7 da                	neg    %edx
  800871:	83 d1 00             	adc    $0x0,%ecx
  800874:	f7 d9                	neg    %ecx
  800876:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800879:	b8 0a 00 00 00       	mov    $0xa,%eax
  80087e:	e9 db 00 00 00       	jmp    80095e <vprintfmt+0x386>
	else if (lflag)
  800883:	85 c9                	test   %ecx,%ecx
  800885:	75 1b                	jne    8008a2 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088f:	89 c1                	mov    %eax,%ecx
  800891:	c1 f9 1f             	sar    $0x1f,%ecx
  800894:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 40 04             	lea    0x4(%eax),%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a0:	eb b9                	jmp    80085b <vprintfmt+0x283>
		return va_arg(*ap, long);
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008aa:	89 c1                	mov    %eax,%ecx
  8008ac:	c1 f9 1f             	sar    $0x1f,%ecx
  8008af:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	8d 40 04             	lea    0x4(%eax),%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bb:	eb 9e                	jmp    80085b <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8008bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008c0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8008c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c8:	e9 91 00 00 00       	jmp    80095e <vprintfmt+0x386>
	if (lflag >= 2)
  8008cd:	83 f9 01             	cmp    $0x1,%ecx
  8008d0:	7e 15                	jle    8008e7 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 10                	mov    (%eax),%edx
  8008d7:	8b 48 04             	mov    0x4(%eax),%ecx
  8008da:	8d 40 08             	lea    0x8(%eax),%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e5:	eb 77                	jmp    80095e <vprintfmt+0x386>
	else if (lflag)
  8008e7:	85 c9                	test   %ecx,%ecx
  8008e9:	75 17                	jne    800902 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	8b 10                	mov    (%eax),%edx
  8008f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008f5:	8d 40 04             	lea    0x4(%eax),%eax
  8008f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800900:	eb 5c                	jmp    80095e <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8b 10                	mov    (%eax),%edx
  800907:	b9 00 00 00 00       	mov    $0x0,%ecx
  80090c:	8d 40 04             	lea    0x4(%eax),%eax
  80090f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800912:	b8 0a 00 00 00       	mov    $0xa,%eax
  800917:	eb 45                	jmp    80095e <vprintfmt+0x386>
			putch('X', putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	53                   	push   %ebx
  80091d:	6a 58                	push   $0x58
  80091f:	ff d6                	call   *%esi
			putch('X', putdat);
  800921:	83 c4 08             	add    $0x8,%esp
  800924:	53                   	push   %ebx
  800925:	6a 58                	push   $0x58
  800927:	ff d6                	call   *%esi
			putch('X', putdat);
  800929:	83 c4 08             	add    $0x8,%esp
  80092c:	53                   	push   %ebx
  80092d:	6a 58                	push   $0x58
  80092f:	ff d6                	call   *%esi
			break;
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	eb 42                	jmp    800978 <vprintfmt+0x3a0>
			putch('0', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	53                   	push   %ebx
  80093a:	6a 30                	push   $0x30
  80093c:	ff d6                	call   *%esi
			putch('x', putdat);
  80093e:	83 c4 08             	add    $0x8,%esp
  800941:	53                   	push   %ebx
  800942:	6a 78                	push   $0x78
  800944:	ff d6                	call   *%esi
			num = (unsigned long long)
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	8b 10                	mov    (%eax),%edx
  80094b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800950:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800953:	8d 40 04             	lea    0x4(%eax),%eax
  800956:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800959:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80095e:	83 ec 0c             	sub    $0xc,%esp
  800961:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800965:	57                   	push   %edi
  800966:	ff 75 e0             	pushl  -0x20(%ebp)
  800969:	50                   	push   %eax
  80096a:	51                   	push   %ecx
  80096b:	52                   	push   %edx
  80096c:	89 da                	mov    %ebx,%edx
  80096e:	89 f0                	mov    %esi,%eax
  800970:	e8 7a fb ff ff       	call   8004ef <printnum>
			break;
  800975:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800978:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097b:	83 c7 01             	add    $0x1,%edi
  80097e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800982:	83 f8 25             	cmp    $0x25,%eax
  800985:	0f 84 64 fc ff ff    	je     8005ef <vprintfmt+0x17>
			if (ch == '\0')
  80098b:	85 c0                	test   %eax,%eax
  80098d:	0f 84 8b 00 00 00    	je     800a1e <vprintfmt+0x446>
			putch(ch, putdat);
  800993:	83 ec 08             	sub    $0x8,%esp
  800996:	53                   	push   %ebx
  800997:	50                   	push   %eax
  800998:	ff d6                	call   *%esi
  80099a:	83 c4 10             	add    $0x10,%esp
  80099d:	eb dc                	jmp    80097b <vprintfmt+0x3a3>
	if (lflag >= 2)
  80099f:	83 f9 01             	cmp    $0x1,%ecx
  8009a2:	7e 15                	jle    8009b9 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	8b 10                	mov    (%eax),%edx
  8009a9:	8b 48 04             	mov    0x4(%eax),%ecx
  8009ac:	8d 40 08             	lea    0x8(%eax),%eax
  8009af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009b2:	b8 10 00 00 00       	mov    $0x10,%eax
  8009b7:	eb a5                	jmp    80095e <vprintfmt+0x386>
	else if (lflag)
  8009b9:	85 c9                	test   %ecx,%ecx
  8009bb:	75 17                	jne    8009d4 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	8b 10                	mov    (%eax),%edx
  8009c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009c7:	8d 40 04             	lea    0x4(%eax),%eax
  8009ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009cd:	b8 10 00 00 00       	mov    $0x10,%eax
  8009d2:	eb 8a                	jmp    80095e <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	8b 10                	mov    (%eax),%edx
  8009d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009de:	8d 40 04             	lea    0x4(%eax),%eax
  8009e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009e4:	b8 10 00 00 00       	mov    $0x10,%eax
  8009e9:	e9 70 ff ff ff       	jmp    80095e <vprintfmt+0x386>
			putch(ch, putdat);
  8009ee:	83 ec 08             	sub    $0x8,%esp
  8009f1:	53                   	push   %ebx
  8009f2:	6a 25                	push   $0x25
  8009f4:	ff d6                	call   *%esi
			break;
  8009f6:	83 c4 10             	add    $0x10,%esp
  8009f9:	e9 7a ff ff ff       	jmp    800978 <vprintfmt+0x3a0>
			putch('%', putdat);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	53                   	push   %ebx
  800a02:	6a 25                	push   $0x25
  800a04:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a06:	83 c4 10             	add    $0x10,%esp
  800a09:	89 f8                	mov    %edi,%eax
  800a0b:	eb 03                	jmp    800a10 <vprintfmt+0x438>
  800a0d:	83 e8 01             	sub    $0x1,%eax
  800a10:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a14:	75 f7                	jne    800a0d <vprintfmt+0x435>
  800a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a19:	e9 5a ff ff ff       	jmp    800978 <vprintfmt+0x3a0>
}
  800a1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a21:	5b                   	pop    %ebx
  800a22:	5e                   	pop    %esi
  800a23:	5f                   	pop    %edi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	83 ec 18             	sub    $0x18,%esp
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a32:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a35:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a39:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a43:	85 c0                	test   %eax,%eax
  800a45:	74 26                	je     800a6d <vsnprintf+0x47>
  800a47:	85 d2                	test   %edx,%edx
  800a49:	7e 22                	jle    800a6d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a4b:	ff 75 14             	pushl  0x14(%ebp)
  800a4e:	ff 75 10             	pushl  0x10(%ebp)
  800a51:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a54:	50                   	push   %eax
  800a55:	68 9e 05 80 00       	push   $0x80059e
  800a5a:	e8 79 fb ff ff       	call   8005d8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a68:	83 c4 10             	add    $0x10,%esp
}
  800a6b:	c9                   	leave  
  800a6c:	c3                   	ret    
		return -E_INVAL;
  800a6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a72:	eb f7                	jmp    800a6b <vsnprintf+0x45>

00800a74 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a7a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a7d:	50                   	push   %eax
  800a7e:	ff 75 10             	pushl  0x10(%ebp)
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	ff 75 08             	pushl  0x8(%ebp)
  800a87:	e8 9a ff ff ff       	call   800a26 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a8c:	c9                   	leave  
  800a8d:	c3                   	ret    

00800a8e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a94:	b8 00 00 00 00       	mov    $0x0,%eax
  800a99:	eb 03                	jmp    800a9e <strlen+0x10>
		n++;
  800a9b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800a9e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800aa2:	75 f7                	jne    800a9b <strlen+0xd>
	return n;
}
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aac:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab4:	eb 03                	jmp    800ab9 <strnlen+0x13>
		n++;
  800ab6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab9:	39 d0                	cmp    %edx,%eax
  800abb:	74 06                	je     800ac3 <strnlen+0x1d>
  800abd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ac1:	75 f3                	jne    800ab6 <strnlen+0x10>
	return n;
}
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	53                   	push   %ebx
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	83 c1 01             	add    $0x1,%ecx
  800ad4:	83 c2 01             	add    $0x1,%edx
  800ad7:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800adb:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ade:	84 db                	test   %bl,%bl
  800ae0:	75 ef                	jne    800ad1 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ae2:	5b                   	pop    %ebx
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	53                   	push   %ebx
  800ae9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800aec:	53                   	push   %ebx
  800aed:	e8 9c ff ff ff       	call   800a8e <strlen>
  800af2:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	01 d8                	add    %ebx,%eax
  800afa:	50                   	push   %eax
  800afb:	e8 c5 ff ff ff       	call   800ac5 <strcpy>
	return dst;
}
  800b00:	89 d8                	mov    %ebx,%eax
  800b02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	56                   	push   %esi
  800b0b:	53                   	push   %ebx
  800b0c:	8b 75 08             	mov    0x8(%ebp),%esi
  800b0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b12:	89 f3                	mov    %esi,%ebx
  800b14:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b17:	89 f2                	mov    %esi,%edx
  800b19:	eb 0f                	jmp    800b2a <strncpy+0x23>
		*dst++ = *src;
  800b1b:	83 c2 01             	add    $0x1,%edx
  800b1e:	0f b6 01             	movzbl (%ecx),%eax
  800b21:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b24:	80 39 01             	cmpb   $0x1,(%ecx)
  800b27:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800b2a:	39 da                	cmp    %ebx,%edx
  800b2c:	75 ed                	jne    800b1b <strncpy+0x14>
	}
	return ret;
}
  800b2e:	89 f0                	mov    %esi,%eax
  800b30:	5b                   	pop    %ebx
  800b31:	5e                   	pop    %esi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	56                   	push   %esi
  800b38:	53                   	push   %ebx
  800b39:	8b 75 08             	mov    0x8(%ebp),%esi
  800b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b42:	89 f0                	mov    %esi,%eax
  800b44:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b48:	85 c9                	test   %ecx,%ecx
  800b4a:	75 0b                	jne    800b57 <strlcpy+0x23>
  800b4c:	eb 17                	jmp    800b65 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b4e:	83 c2 01             	add    $0x1,%edx
  800b51:	83 c0 01             	add    $0x1,%eax
  800b54:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800b57:	39 d8                	cmp    %ebx,%eax
  800b59:	74 07                	je     800b62 <strlcpy+0x2e>
  800b5b:	0f b6 0a             	movzbl (%edx),%ecx
  800b5e:	84 c9                	test   %cl,%cl
  800b60:	75 ec                	jne    800b4e <strlcpy+0x1a>
		*dst = '\0';
  800b62:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b65:	29 f0                	sub    %esi,%eax
}
  800b67:	5b                   	pop    %ebx
  800b68:	5e                   	pop    %esi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b71:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b74:	eb 06                	jmp    800b7c <strcmp+0x11>
		p++, q++;
  800b76:	83 c1 01             	add    $0x1,%ecx
  800b79:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800b7c:	0f b6 01             	movzbl (%ecx),%eax
  800b7f:	84 c0                	test   %al,%al
  800b81:	74 04                	je     800b87 <strcmp+0x1c>
  800b83:	3a 02                	cmp    (%edx),%al
  800b85:	74 ef                	je     800b76 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b87:	0f b6 c0             	movzbl %al,%eax
  800b8a:	0f b6 12             	movzbl (%edx),%edx
  800b8d:	29 d0                	sub    %edx,%eax
}
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	53                   	push   %ebx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9b:	89 c3                	mov    %eax,%ebx
  800b9d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ba0:	eb 06                	jmp    800ba8 <strncmp+0x17>
		n--, p++, q++;
  800ba2:	83 c0 01             	add    $0x1,%eax
  800ba5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ba8:	39 d8                	cmp    %ebx,%eax
  800baa:	74 16                	je     800bc2 <strncmp+0x31>
  800bac:	0f b6 08             	movzbl (%eax),%ecx
  800baf:	84 c9                	test   %cl,%cl
  800bb1:	74 04                	je     800bb7 <strncmp+0x26>
  800bb3:	3a 0a                	cmp    (%edx),%cl
  800bb5:	74 eb                	je     800ba2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb7:	0f b6 00             	movzbl (%eax),%eax
  800bba:	0f b6 12             	movzbl (%edx),%edx
  800bbd:	29 d0                	sub    %edx,%eax
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5d                   	pop    %ebp
  800bc1:	c3                   	ret    
		return 0;
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc7:	eb f6                	jmp    800bbf <strncmp+0x2e>

00800bc9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd3:	0f b6 10             	movzbl (%eax),%edx
  800bd6:	84 d2                	test   %dl,%dl
  800bd8:	74 09                	je     800be3 <strchr+0x1a>
		if (*s == c)
  800bda:	38 ca                	cmp    %cl,%dl
  800bdc:	74 0a                	je     800be8 <strchr+0x1f>
	for (; *s; s++)
  800bde:	83 c0 01             	add    $0x1,%eax
  800be1:	eb f0                	jmp    800bd3 <strchr+0xa>
			return (char *) s;
	return 0;
  800be3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bf4:	eb 03                	jmp    800bf9 <strfind+0xf>
  800bf6:	83 c0 01             	add    $0x1,%eax
  800bf9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bfc:	38 ca                	cmp    %cl,%dl
  800bfe:	74 04                	je     800c04 <strfind+0x1a>
  800c00:	84 d2                	test   %dl,%dl
  800c02:	75 f2                	jne    800bf6 <strfind+0xc>
			break;
	return (char *) s;
}
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	57                   	push   %edi
  800c0a:	56                   	push   %esi
  800c0b:	53                   	push   %ebx
  800c0c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c12:	85 c9                	test   %ecx,%ecx
  800c14:	74 13                	je     800c29 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c16:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c1c:	75 05                	jne    800c23 <memset+0x1d>
  800c1e:	f6 c1 03             	test   $0x3,%cl
  800c21:	74 0d                	je     800c30 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	fc                   	cld    
  800c27:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c29:	89 f8                	mov    %edi,%eax
  800c2b:	5b                   	pop    %ebx
  800c2c:	5e                   	pop    %esi
  800c2d:	5f                   	pop    %edi
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    
		c &= 0xFF;
  800c30:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c34:	89 d3                	mov    %edx,%ebx
  800c36:	c1 e3 08             	shl    $0x8,%ebx
  800c39:	89 d0                	mov    %edx,%eax
  800c3b:	c1 e0 18             	shl    $0x18,%eax
  800c3e:	89 d6                	mov    %edx,%esi
  800c40:	c1 e6 10             	shl    $0x10,%esi
  800c43:	09 f0                	or     %esi,%eax
  800c45:	09 c2                	or     %eax,%edx
  800c47:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800c49:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c4c:	89 d0                	mov    %edx,%eax
  800c4e:	fc                   	cld    
  800c4f:	f3 ab                	rep stos %eax,%es:(%edi)
  800c51:	eb d6                	jmp    800c29 <memset+0x23>

00800c53 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c61:	39 c6                	cmp    %eax,%esi
  800c63:	73 35                	jae    800c9a <memmove+0x47>
  800c65:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c68:	39 c2                	cmp    %eax,%edx
  800c6a:	76 2e                	jbe    800c9a <memmove+0x47>
		s += n;
		d += n;
  800c6c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c6f:	89 d6                	mov    %edx,%esi
  800c71:	09 fe                	or     %edi,%esi
  800c73:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c79:	74 0c                	je     800c87 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c7b:	83 ef 01             	sub    $0x1,%edi
  800c7e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c81:	fd                   	std    
  800c82:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c84:	fc                   	cld    
  800c85:	eb 21                	jmp    800ca8 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c87:	f6 c1 03             	test   $0x3,%cl
  800c8a:	75 ef                	jne    800c7b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c8c:	83 ef 04             	sub    $0x4,%edi
  800c8f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c92:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c95:	fd                   	std    
  800c96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c98:	eb ea                	jmp    800c84 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c9a:	89 f2                	mov    %esi,%edx
  800c9c:	09 c2                	or     %eax,%edx
  800c9e:	f6 c2 03             	test   $0x3,%dl
  800ca1:	74 09                	je     800cac <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ca3:	89 c7                	mov    %eax,%edi
  800ca5:	fc                   	cld    
  800ca6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cac:	f6 c1 03             	test   $0x3,%cl
  800caf:	75 f2                	jne    800ca3 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cb1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cb4:	89 c7                	mov    %eax,%edi
  800cb6:	fc                   	cld    
  800cb7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cb9:	eb ed                	jmp    800ca8 <memmove+0x55>

00800cbb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800cbe:	ff 75 10             	pushl  0x10(%ebp)
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	ff 75 08             	pushl  0x8(%ebp)
  800cc7:	e8 87 ff ff ff       	call   800c53 <memmove>
}
  800ccc:	c9                   	leave  
  800ccd:	c3                   	ret    

00800cce <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd9:	89 c6                	mov    %eax,%esi
  800cdb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cde:	39 f0                	cmp    %esi,%eax
  800ce0:	74 1c                	je     800cfe <memcmp+0x30>
		if (*s1 != *s2)
  800ce2:	0f b6 08             	movzbl (%eax),%ecx
  800ce5:	0f b6 1a             	movzbl (%edx),%ebx
  800ce8:	38 d9                	cmp    %bl,%cl
  800cea:	75 08                	jne    800cf4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cec:	83 c0 01             	add    $0x1,%eax
  800cef:	83 c2 01             	add    $0x1,%edx
  800cf2:	eb ea                	jmp    800cde <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cf4:	0f b6 c1             	movzbl %cl,%eax
  800cf7:	0f b6 db             	movzbl %bl,%ebx
  800cfa:	29 d8                	sub    %ebx,%eax
  800cfc:	eb 05                	jmp    800d03 <memcmp+0x35>
	}

	return 0;
  800cfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d10:	89 c2                	mov    %eax,%edx
  800d12:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d15:	39 d0                	cmp    %edx,%eax
  800d17:	73 09                	jae    800d22 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d19:	38 08                	cmp    %cl,(%eax)
  800d1b:	74 05                	je     800d22 <memfind+0x1b>
	for (; s < ends; s++)
  800d1d:	83 c0 01             	add    $0x1,%eax
  800d20:	eb f3                	jmp    800d15 <memfind+0xe>
			break;
	return (void *) s;
}
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
  800d2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d30:	eb 03                	jmp    800d35 <strtol+0x11>
		s++;
  800d32:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d35:	0f b6 01             	movzbl (%ecx),%eax
  800d38:	3c 20                	cmp    $0x20,%al
  800d3a:	74 f6                	je     800d32 <strtol+0xe>
  800d3c:	3c 09                	cmp    $0x9,%al
  800d3e:	74 f2                	je     800d32 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d40:	3c 2b                	cmp    $0x2b,%al
  800d42:	74 2e                	je     800d72 <strtol+0x4e>
	int neg = 0;
  800d44:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d49:	3c 2d                	cmp    $0x2d,%al
  800d4b:	74 2f                	je     800d7c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d4d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d53:	75 05                	jne    800d5a <strtol+0x36>
  800d55:	80 39 30             	cmpb   $0x30,(%ecx)
  800d58:	74 2c                	je     800d86 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d5a:	85 db                	test   %ebx,%ebx
  800d5c:	75 0a                	jne    800d68 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d5e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800d63:	80 39 30             	cmpb   $0x30,(%ecx)
  800d66:	74 28                	je     800d90 <strtol+0x6c>
		base = 10;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d70:	eb 50                	jmp    800dc2 <strtol+0x9e>
		s++;
  800d72:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d75:	bf 00 00 00 00       	mov    $0x0,%edi
  800d7a:	eb d1                	jmp    800d4d <strtol+0x29>
		s++, neg = 1;
  800d7c:	83 c1 01             	add    $0x1,%ecx
  800d7f:	bf 01 00 00 00       	mov    $0x1,%edi
  800d84:	eb c7                	jmp    800d4d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d86:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d8a:	74 0e                	je     800d9a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d8c:	85 db                	test   %ebx,%ebx
  800d8e:	75 d8                	jne    800d68 <strtol+0x44>
		s++, base = 8;
  800d90:	83 c1 01             	add    $0x1,%ecx
  800d93:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d98:	eb ce                	jmp    800d68 <strtol+0x44>
		s += 2, base = 16;
  800d9a:	83 c1 02             	add    $0x2,%ecx
  800d9d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800da2:	eb c4                	jmp    800d68 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800da4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800da7:	89 f3                	mov    %esi,%ebx
  800da9:	80 fb 19             	cmp    $0x19,%bl
  800dac:	77 29                	ja     800dd7 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800dae:	0f be d2             	movsbl %dl,%edx
  800db1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800db4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800db7:	7d 30                	jge    800de9 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800db9:	83 c1 01             	add    $0x1,%ecx
  800dbc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dc0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dc2:	0f b6 11             	movzbl (%ecx),%edx
  800dc5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800dc8:	89 f3                	mov    %esi,%ebx
  800dca:	80 fb 09             	cmp    $0x9,%bl
  800dcd:	77 d5                	ja     800da4 <strtol+0x80>
			dig = *s - '0';
  800dcf:	0f be d2             	movsbl %dl,%edx
  800dd2:	83 ea 30             	sub    $0x30,%edx
  800dd5:	eb dd                	jmp    800db4 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800dd7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800dda:	89 f3                	mov    %esi,%ebx
  800ddc:	80 fb 19             	cmp    $0x19,%bl
  800ddf:	77 08                	ja     800de9 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800de1:	0f be d2             	movsbl %dl,%edx
  800de4:	83 ea 37             	sub    $0x37,%edx
  800de7:	eb cb                	jmp    800db4 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800de9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ded:	74 05                	je     800df4 <strtol+0xd0>
		*endptr = (char *) s;
  800def:	8b 75 0c             	mov    0xc(%ebp),%esi
  800df2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800df4:	89 c2                	mov    %eax,%edx
  800df6:	f7 da                	neg    %edx
  800df8:	85 ff                	test   %edi,%edi
  800dfa:	0f 45 c2             	cmovne %edx,%eax
}
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e08:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e13:	89 c3                	mov    %eax,%ebx
  800e15:	89 c7                	mov    %eax,%edi
  800e17:	89 c6                	mov    %eax,%esi
  800e19:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	57                   	push   %edi
  800e24:	56                   	push   %esi
  800e25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e26:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2b:	b8 01 00 00 00       	mov    $0x1,%eax
  800e30:	89 d1                	mov    %edx,%ecx
  800e32:	89 d3                	mov    %edx,%ebx
  800e34:	89 d7                	mov    %edx,%edi
  800e36:	89 d6                	mov    %edx,%esi
  800e38:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	57                   	push   %edi
  800e43:	56                   	push   %esi
  800e44:	53                   	push   %ebx
  800e45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e50:	b8 03 00 00 00       	mov    $0x3,%eax
  800e55:	89 cb                	mov    %ecx,%ebx
  800e57:	89 cf                	mov    %ecx,%edi
  800e59:	89 ce                	mov    %ecx,%esi
  800e5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	7f 08                	jg     800e69 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e64:	5b                   	pop    %ebx
  800e65:	5e                   	pop    %esi
  800e66:	5f                   	pop    %edi
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e69:	83 ec 0c             	sub    $0xc,%esp
  800e6c:	50                   	push   %eax
  800e6d:	6a 03                	push   $0x3
  800e6f:	68 bf 29 80 00       	push   $0x8029bf
  800e74:	6a 23                	push   $0x23
  800e76:	68 dc 29 80 00       	push   $0x8029dc
  800e7b:	e8 80 f5 ff ff       	call   800400 <_panic>

00800e80 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e86:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8b:	b8 02 00 00 00       	mov    $0x2,%eax
  800e90:	89 d1                	mov    %edx,%ecx
  800e92:	89 d3                	mov    %edx,%ebx
  800e94:	89 d7                	mov    %edx,%edi
  800e96:	89 d6                	mov    %edx,%esi
  800e98:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_yield>:

void
sys_yield(void)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eaa:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eaf:	89 d1                	mov    %edx,%ecx
  800eb1:	89 d3                	mov    %edx,%ebx
  800eb3:	89 d7                	mov    %edx,%edi
  800eb5:	89 d6                	mov    %edx,%esi
  800eb7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800eb9:	5b                   	pop    %ebx
  800eba:	5e                   	pop    %esi
  800ebb:	5f                   	pop    %edi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    

00800ebe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec7:	be 00 00 00 00       	mov    $0x0,%esi
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ed7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eda:	89 f7                	mov    %esi,%edi
  800edc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	7f 08                	jg     800eea <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ee2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eea:	83 ec 0c             	sub    $0xc,%esp
  800eed:	50                   	push   %eax
  800eee:	6a 04                	push   $0x4
  800ef0:	68 bf 29 80 00       	push   $0x8029bf
  800ef5:	6a 23                	push   $0x23
  800ef7:	68 dc 29 80 00       	push   $0x8029dc
  800efc:	e8 ff f4 ff ff       	call   800400 <_panic>

00800f01 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	57                   	push   %edi
  800f05:	56                   	push   %esi
  800f06:	53                   	push   %ebx
  800f07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f10:	b8 05 00 00 00       	mov    $0x5,%eax
  800f15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f18:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f1b:	8b 75 18             	mov    0x18(%ebp),%esi
  800f1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	7f 08                	jg     800f2c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2c:	83 ec 0c             	sub    $0xc,%esp
  800f2f:	50                   	push   %eax
  800f30:	6a 05                	push   $0x5
  800f32:	68 bf 29 80 00       	push   $0x8029bf
  800f37:	6a 23                	push   $0x23
  800f39:	68 dc 29 80 00       	push   $0x8029dc
  800f3e:	e8 bd f4 ff ff       	call   800400 <_panic>

00800f43 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	57                   	push   %edi
  800f47:	56                   	push   %esi
  800f48:	53                   	push   %ebx
  800f49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f57:	b8 06 00 00 00       	mov    $0x6,%eax
  800f5c:	89 df                	mov    %ebx,%edi
  800f5e:	89 de                	mov    %ebx,%esi
  800f60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f62:	85 c0                	test   %eax,%eax
  800f64:	7f 08                	jg     800f6e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f69:	5b                   	pop    %ebx
  800f6a:	5e                   	pop    %esi
  800f6b:	5f                   	pop    %edi
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6e:	83 ec 0c             	sub    $0xc,%esp
  800f71:	50                   	push   %eax
  800f72:	6a 06                	push   $0x6
  800f74:	68 bf 29 80 00       	push   $0x8029bf
  800f79:	6a 23                	push   $0x23
  800f7b:	68 dc 29 80 00       	push   $0x8029dc
  800f80:	e8 7b f4 ff ff       	call   800400 <_panic>

00800f85 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
  800f8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f93:	8b 55 08             	mov    0x8(%ebp),%edx
  800f96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f99:	b8 08 00 00 00       	mov    $0x8,%eax
  800f9e:	89 df                	mov    %ebx,%edi
  800fa0:	89 de                	mov    %ebx,%esi
  800fa2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	7f 08                	jg     800fb0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb0:	83 ec 0c             	sub    $0xc,%esp
  800fb3:	50                   	push   %eax
  800fb4:	6a 08                	push   $0x8
  800fb6:	68 bf 29 80 00       	push   $0x8029bf
  800fbb:	6a 23                	push   $0x23
  800fbd:	68 dc 29 80 00       	push   $0x8029dc
  800fc2:	e8 39 f4 ff ff       	call   800400 <_panic>

00800fc7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
  800fcd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdb:	b8 09 00 00 00       	mov    $0x9,%eax
  800fe0:	89 df                	mov    %ebx,%edi
  800fe2:	89 de                	mov    %ebx,%esi
  800fe4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	7f 08                	jg     800ff2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fed:	5b                   	pop    %ebx
  800fee:	5e                   	pop    %esi
  800fef:	5f                   	pop    %edi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff2:	83 ec 0c             	sub    $0xc,%esp
  800ff5:	50                   	push   %eax
  800ff6:	6a 09                	push   $0x9
  800ff8:	68 bf 29 80 00       	push   $0x8029bf
  800ffd:	6a 23                	push   $0x23
  800fff:	68 dc 29 80 00       	push   $0x8029dc
  801004:	e8 f7 f3 ff ff       	call   800400 <_panic>

00801009 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	57                   	push   %edi
  80100d:	56                   	push   %esi
  80100e:	53                   	push   %ebx
  80100f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801012:	bb 00 00 00 00       	mov    $0x0,%ebx
  801017:	8b 55 08             	mov    0x8(%ebp),%edx
  80101a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801022:	89 df                	mov    %ebx,%edi
  801024:	89 de                	mov    %ebx,%esi
  801026:	cd 30                	int    $0x30
	if(check && ret > 0)
  801028:	85 c0                	test   %eax,%eax
  80102a:	7f 08                	jg     801034 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80102c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801034:	83 ec 0c             	sub    $0xc,%esp
  801037:	50                   	push   %eax
  801038:	6a 0a                	push   $0xa
  80103a:	68 bf 29 80 00       	push   $0x8029bf
  80103f:	6a 23                	push   $0x23
  801041:	68 dc 29 80 00       	push   $0x8029dc
  801046:	e8 b5 f3 ff ff       	call   800400 <_panic>

0080104b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	57                   	push   %edi
  80104f:	56                   	push   %esi
  801050:	53                   	push   %ebx
	asm volatile("int %1\n"
  801051:	8b 55 08             	mov    0x8(%ebp),%edx
  801054:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801057:	b8 0c 00 00 00       	mov    $0xc,%eax
  80105c:	be 00 00 00 00       	mov    $0x0,%esi
  801061:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801064:	8b 7d 14             	mov    0x14(%ebp),%edi
  801067:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801069:	5b                   	pop    %ebx
  80106a:	5e                   	pop    %esi
  80106b:	5f                   	pop    %edi
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    

0080106e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	57                   	push   %edi
  801072:	56                   	push   %esi
  801073:	53                   	push   %ebx
  801074:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801077:	b9 00 00 00 00       	mov    $0x0,%ecx
  80107c:	8b 55 08             	mov    0x8(%ebp),%edx
  80107f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801084:	89 cb                	mov    %ecx,%ebx
  801086:	89 cf                	mov    %ecx,%edi
  801088:	89 ce                	mov    %ecx,%esi
  80108a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	7f 08                	jg     801098 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801090:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801093:	5b                   	pop    %ebx
  801094:	5e                   	pop    %esi
  801095:	5f                   	pop    %edi
  801096:	5d                   	pop    %ebp
  801097:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801098:	83 ec 0c             	sub    $0xc,%esp
  80109b:	50                   	push   %eax
  80109c:	6a 0d                	push   $0xd
  80109e:	68 bf 29 80 00       	push   $0x8029bf
  8010a3:	6a 23                	push   $0x23
  8010a5:	68 dc 29 80 00       	push   $0x8029dc
  8010aa:	e8 51 f3 ff ff       	call   800400 <_panic>

008010af <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	05 00 00 00 30       	add    $0x30000000,%eax
  8010ba:	c1 e8 0c             	shr    $0xc,%eax
}
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    

008010bf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010cf:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010dc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	c1 ea 16             	shr    $0x16,%edx
  8010e6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ed:	f6 c2 01             	test   $0x1,%dl
  8010f0:	74 2a                	je     80111c <fd_alloc+0x46>
  8010f2:	89 c2                	mov    %eax,%edx
  8010f4:	c1 ea 0c             	shr    $0xc,%edx
  8010f7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010fe:	f6 c2 01             	test   $0x1,%dl
  801101:	74 19                	je     80111c <fd_alloc+0x46>
  801103:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801108:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80110d:	75 d2                	jne    8010e1 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80110f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801115:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80111a:	eb 07                	jmp    801123 <fd_alloc+0x4d>
			*fd_store = fd;
  80111c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80111e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    

00801125 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80112b:	83 f8 1f             	cmp    $0x1f,%eax
  80112e:	77 36                	ja     801166 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801130:	c1 e0 0c             	shl    $0xc,%eax
  801133:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801138:	89 c2                	mov    %eax,%edx
  80113a:	c1 ea 16             	shr    $0x16,%edx
  80113d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801144:	f6 c2 01             	test   $0x1,%dl
  801147:	74 24                	je     80116d <fd_lookup+0x48>
  801149:	89 c2                	mov    %eax,%edx
  80114b:	c1 ea 0c             	shr    $0xc,%edx
  80114e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801155:	f6 c2 01             	test   $0x1,%dl
  801158:	74 1a                	je     801174 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80115a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115d:	89 02                	mov    %eax,(%edx)
	return 0;
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    
		return -E_INVAL;
  801166:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116b:	eb f7                	jmp    801164 <fd_lookup+0x3f>
		return -E_INVAL;
  80116d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801172:	eb f0                	jmp    801164 <fd_lookup+0x3f>
  801174:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801179:	eb e9                	jmp    801164 <fd_lookup+0x3f>

0080117b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 08             	sub    $0x8,%esp
  801181:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801184:	ba 68 2a 80 00       	mov    $0x802a68,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801189:	b8 90 47 80 00       	mov    $0x804790,%eax
		if (devtab[i]->dev_id == dev_id) {
  80118e:	39 08                	cmp    %ecx,(%eax)
  801190:	74 33                	je     8011c5 <dev_lookup+0x4a>
  801192:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801195:	8b 02                	mov    (%edx),%eax
  801197:	85 c0                	test   %eax,%eax
  801199:	75 f3                	jne    80118e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80119b:	a1 90 67 80 00       	mov    0x806790,%eax
  8011a0:	8b 40 48             	mov    0x48(%eax),%eax
  8011a3:	83 ec 04             	sub    $0x4,%esp
  8011a6:	51                   	push   %ecx
  8011a7:	50                   	push   %eax
  8011a8:	68 ec 29 80 00       	push   $0x8029ec
  8011ad:	e8 29 f3 ff ff       	call   8004db <cprintf>
	*dev = 0;
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011bb:	83 c4 10             	add    $0x10,%esp
  8011be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    
			*dev = devtab[i];
  8011c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cf:	eb f2                	jmp    8011c3 <dev_lookup+0x48>

008011d1 <fd_close>:
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	57                   	push   %edi
  8011d5:	56                   	push   %esi
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 1c             	sub    $0x1c,%esp
  8011da:	8b 75 08             	mov    0x8(%ebp),%esi
  8011dd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011ea:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ed:	50                   	push   %eax
  8011ee:	e8 32 ff ff ff       	call   801125 <fd_lookup>
  8011f3:	89 c3                	mov    %eax,%ebx
  8011f5:	83 c4 08             	add    $0x8,%esp
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	78 05                	js     801201 <fd_close+0x30>
	    || fd != fd2)
  8011fc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011ff:	74 16                	je     801217 <fd_close+0x46>
		return (must_exist ? r : 0);
  801201:	89 f8                	mov    %edi,%eax
  801203:	84 c0                	test   %al,%al
  801205:	b8 00 00 00 00       	mov    $0x0,%eax
  80120a:	0f 44 d8             	cmove  %eax,%ebx
}
  80120d:	89 d8                	mov    %ebx,%eax
  80120f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801212:	5b                   	pop    %ebx
  801213:	5e                   	pop    %esi
  801214:	5f                   	pop    %edi
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801217:	83 ec 08             	sub    $0x8,%esp
  80121a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80121d:	50                   	push   %eax
  80121e:	ff 36                	pushl  (%esi)
  801220:	e8 56 ff ff ff       	call   80117b <dev_lookup>
  801225:	89 c3                	mov    %eax,%ebx
  801227:	83 c4 10             	add    $0x10,%esp
  80122a:	85 c0                	test   %eax,%eax
  80122c:	78 15                	js     801243 <fd_close+0x72>
		if (dev->dev_close)
  80122e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801231:	8b 40 10             	mov    0x10(%eax),%eax
  801234:	85 c0                	test   %eax,%eax
  801236:	74 1b                	je     801253 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801238:	83 ec 0c             	sub    $0xc,%esp
  80123b:	56                   	push   %esi
  80123c:	ff d0                	call   *%eax
  80123e:	89 c3                	mov    %eax,%ebx
  801240:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	56                   	push   %esi
  801247:	6a 00                	push   $0x0
  801249:	e8 f5 fc ff ff       	call   800f43 <sys_page_unmap>
	return r;
  80124e:	83 c4 10             	add    $0x10,%esp
  801251:	eb ba                	jmp    80120d <fd_close+0x3c>
			r = 0;
  801253:	bb 00 00 00 00       	mov    $0x0,%ebx
  801258:	eb e9                	jmp    801243 <fd_close+0x72>

0080125a <close>:

int
close(int fdnum)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801260:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801263:	50                   	push   %eax
  801264:	ff 75 08             	pushl  0x8(%ebp)
  801267:	e8 b9 fe ff ff       	call   801125 <fd_lookup>
  80126c:	83 c4 08             	add    $0x8,%esp
  80126f:	85 c0                	test   %eax,%eax
  801271:	78 10                	js     801283 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801273:	83 ec 08             	sub    $0x8,%esp
  801276:	6a 01                	push   $0x1
  801278:	ff 75 f4             	pushl  -0xc(%ebp)
  80127b:	e8 51 ff ff ff       	call   8011d1 <fd_close>
  801280:	83 c4 10             	add    $0x10,%esp
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <close_all>:

void
close_all(void)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	53                   	push   %ebx
  801289:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80128c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801291:	83 ec 0c             	sub    $0xc,%esp
  801294:	53                   	push   %ebx
  801295:	e8 c0 ff ff ff       	call   80125a <close>
	for (i = 0; i < MAXFD; i++)
  80129a:	83 c3 01             	add    $0x1,%ebx
  80129d:	83 c4 10             	add    $0x10,%esp
  8012a0:	83 fb 20             	cmp    $0x20,%ebx
  8012a3:	75 ec                	jne    801291 <close_all+0xc>
}
  8012a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	57                   	push   %edi
  8012ae:	56                   	push   %esi
  8012af:	53                   	push   %ebx
  8012b0:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b6:	50                   	push   %eax
  8012b7:	ff 75 08             	pushl  0x8(%ebp)
  8012ba:	e8 66 fe ff ff       	call   801125 <fd_lookup>
  8012bf:	89 c3                	mov    %eax,%ebx
  8012c1:	83 c4 08             	add    $0x8,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	0f 88 81 00 00 00    	js     80134d <dup+0xa3>
		return r;
	close(newfdnum);
  8012cc:	83 ec 0c             	sub    $0xc,%esp
  8012cf:	ff 75 0c             	pushl  0xc(%ebp)
  8012d2:	e8 83 ff ff ff       	call   80125a <close>

	newfd = INDEX2FD(newfdnum);
  8012d7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012da:	c1 e6 0c             	shl    $0xc,%esi
  8012dd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012e3:	83 c4 04             	add    $0x4,%esp
  8012e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012e9:	e8 d1 fd ff ff       	call   8010bf <fd2data>
  8012ee:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012f0:	89 34 24             	mov    %esi,(%esp)
  8012f3:	e8 c7 fd ff ff       	call   8010bf <fd2data>
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012fd:	89 d8                	mov    %ebx,%eax
  8012ff:	c1 e8 16             	shr    $0x16,%eax
  801302:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801309:	a8 01                	test   $0x1,%al
  80130b:	74 11                	je     80131e <dup+0x74>
  80130d:	89 d8                	mov    %ebx,%eax
  80130f:	c1 e8 0c             	shr    $0xc,%eax
  801312:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801319:	f6 c2 01             	test   $0x1,%dl
  80131c:	75 39                	jne    801357 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80131e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	c1 e8 0c             	shr    $0xc,%eax
  801326:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80132d:	83 ec 0c             	sub    $0xc,%esp
  801330:	25 07 0e 00 00       	and    $0xe07,%eax
  801335:	50                   	push   %eax
  801336:	56                   	push   %esi
  801337:	6a 00                	push   $0x0
  801339:	52                   	push   %edx
  80133a:	6a 00                	push   $0x0
  80133c:	e8 c0 fb ff ff       	call   800f01 <sys_page_map>
  801341:	89 c3                	mov    %eax,%ebx
  801343:	83 c4 20             	add    $0x20,%esp
  801346:	85 c0                	test   %eax,%eax
  801348:	78 31                	js     80137b <dup+0xd1>
		goto err;

	return newfdnum;
  80134a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80134d:	89 d8                	mov    %ebx,%eax
  80134f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801352:	5b                   	pop    %ebx
  801353:	5e                   	pop    %esi
  801354:	5f                   	pop    %edi
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801357:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80135e:	83 ec 0c             	sub    $0xc,%esp
  801361:	25 07 0e 00 00       	and    $0xe07,%eax
  801366:	50                   	push   %eax
  801367:	57                   	push   %edi
  801368:	6a 00                	push   $0x0
  80136a:	53                   	push   %ebx
  80136b:	6a 00                	push   $0x0
  80136d:	e8 8f fb ff ff       	call   800f01 <sys_page_map>
  801372:	89 c3                	mov    %eax,%ebx
  801374:	83 c4 20             	add    $0x20,%esp
  801377:	85 c0                	test   %eax,%eax
  801379:	79 a3                	jns    80131e <dup+0x74>
	sys_page_unmap(0, newfd);
  80137b:	83 ec 08             	sub    $0x8,%esp
  80137e:	56                   	push   %esi
  80137f:	6a 00                	push   $0x0
  801381:	e8 bd fb ff ff       	call   800f43 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801386:	83 c4 08             	add    $0x8,%esp
  801389:	57                   	push   %edi
  80138a:	6a 00                	push   $0x0
  80138c:	e8 b2 fb ff ff       	call   800f43 <sys_page_unmap>
	return r;
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	eb b7                	jmp    80134d <dup+0xa3>

00801396 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	53                   	push   %ebx
  80139a:	83 ec 14             	sub    $0x14,%esp
  80139d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a3:	50                   	push   %eax
  8013a4:	53                   	push   %ebx
  8013a5:	e8 7b fd ff ff       	call   801125 <fd_lookup>
  8013aa:	83 c4 08             	add    $0x8,%esp
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	78 3f                	js     8013f0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b1:	83 ec 08             	sub    $0x8,%esp
  8013b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b7:	50                   	push   %eax
  8013b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bb:	ff 30                	pushl  (%eax)
  8013bd:	e8 b9 fd ff ff       	call   80117b <dev_lookup>
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	78 27                	js     8013f0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013cc:	8b 42 08             	mov    0x8(%edx),%eax
  8013cf:	83 e0 03             	and    $0x3,%eax
  8013d2:	83 f8 01             	cmp    $0x1,%eax
  8013d5:	74 1e                	je     8013f5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013da:	8b 40 08             	mov    0x8(%eax),%eax
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	74 35                	je     801416 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013e1:	83 ec 04             	sub    $0x4,%esp
  8013e4:	ff 75 10             	pushl  0x10(%ebp)
  8013e7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ea:	52                   	push   %edx
  8013eb:	ff d0                	call   *%eax
  8013ed:	83 c4 10             	add    $0x10,%esp
}
  8013f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013f5:	a1 90 67 80 00       	mov    0x806790,%eax
  8013fa:	8b 40 48             	mov    0x48(%eax),%eax
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	53                   	push   %ebx
  801401:	50                   	push   %eax
  801402:	68 2d 2a 80 00       	push   $0x802a2d
  801407:	e8 cf f0 ff ff       	call   8004db <cprintf>
		return -E_INVAL;
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801414:	eb da                	jmp    8013f0 <read+0x5a>
		return -E_NOT_SUPP;
  801416:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80141b:	eb d3                	jmp    8013f0 <read+0x5a>

0080141d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	57                   	push   %edi
  801421:	56                   	push   %esi
  801422:	53                   	push   %ebx
  801423:	83 ec 0c             	sub    $0xc,%esp
  801426:	8b 7d 08             	mov    0x8(%ebp),%edi
  801429:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80142c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801431:	39 f3                	cmp    %esi,%ebx
  801433:	73 25                	jae    80145a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801435:	83 ec 04             	sub    $0x4,%esp
  801438:	89 f0                	mov    %esi,%eax
  80143a:	29 d8                	sub    %ebx,%eax
  80143c:	50                   	push   %eax
  80143d:	89 d8                	mov    %ebx,%eax
  80143f:	03 45 0c             	add    0xc(%ebp),%eax
  801442:	50                   	push   %eax
  801443:	57                   	push   %edi
  801444:	e8 4d ff ff ff       	call   801396 <read>
		if (m < 0)
  801449:	83 c4 10             	add    $0x10,%esp
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 08                	js     801458 <readn+0x3b>
			return m;
		if (m == 0)
  801450:	85 c0                	test   %eax,%eax
  801452:	74 06                	je     80145a <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801454:	01 c3                	add    %eax,%ebx
  801456:	eb d9                	jmp    801431 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801458:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80145a:	89 d8                	mov    %ebx,%eax
  80145c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80145f:	5b                   	pop    %ebx
  801460:	5e                   	pop    %esi
  801461:	5f                   	pop    %edi
  801462:	5d                   	pop    %ebp
  801463:	c3                   	ret    

00801464 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	53                   	push   %ebx
  801468:	83 ec 14             	sub    $0x14,%esp
  80146b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801471:	50                   	push   %eax
  801472:	53                   	push   %ebx
  801473:	e8 ad fc ff ff       	call   801125 <fd_lookup>
  801478:	83 c4 08             	add    $0x8,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 3a                	js     8014b9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147f:	83 ec 08             	sub    $0x8,%esp
  801482:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801489:	ff 30                	pushl  (%eax)
  80148b:	e8 eb fc ff ff       	call   80117b <dev_lookup>
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	85 c0                	test   %eax,%eax
  801495:	78 22                	js     8014b9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80149e:	74 1e                	je     8014be <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a3:	8b 52 0c             	mov    0xc(%edx),%edx
  8014a6:	85 d2                	test   %edx,%edx
  8014a8:	74 35                	je     8014df <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014aa:	83 ec 04             	sub    $0x4,%esp
  8014ad:	ff 75 10             	pushl  0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	50                   	push   %eax
  8014b4:	ff d2                	call   *%edx
  8014b6:	83 c4 10             	add    $0x10,%esp
}
  8014b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014be:	a1 90 67 80 00       	mov    0x806790,%eax
  8014c3:	8b 40 48             	mov    0x48(%eax),%eax
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	53                   	push   %ebx
  8014ca:	50                   	push   %eax
  8014cb:	68 49 2a 80 00       	push   $0x802a49
  8014d0:	e8 06 f0 ff ff       	call   8004db <cprintf>
		return -E_INVAL;
  8014d5:	83 c4 10             	add    $0x10,%esp
  8014d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014dd:	eb da                	jmp    8014b9 <write+0x55>
		return -E_NOT_SUPP;
  8014df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e4:	eb d3                	jmp    8014b9 <write+0x55>

008014e6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ec:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014ef:	50                   	push   %eax
  8014f0:	ff 75 08             	pushl  0x8(%ebp)
  8014f3:	e8 2d fc ff ff       	call   801125 <fd_lookup>
  8014f8:	83 c4 08             	add    $0x8,%esp
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	78 0e                	js     80150d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801502:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801505:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801508:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	53                   	push   %ebx
  801513:	83 ec 14             	sub    $0x14,%esp
  801516:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801519:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	53                   	push   %ebx
  80151e:	e8 02 fc ff ff       	call   801125 <fd_lookup>
  801523:	83 c4 08             	add    $0x8,%esp
  801526:	85 c0                	test   %eax,%eax
  801528:	78 37                	js     801561 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801530:	50                   	push   %eax
  801531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801534:	ff 30                	pushl  (%eax)
  801536:	e8 40 fc ff ff       	call   80117b <dev_lookup>
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	85 c0                	test   %eax,%eax
  801540:	78 1f                	js     801561 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801545:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801549:	74 1b                	je     801566 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80154b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154e:	8b 52 18             	mov    0x18(%edx),%edx
  801551:	85 d2                	test   %edx,%edx
  801553:	74 32                	je     801587 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	ff 75 0c             	pushl  0xc(%ebp)
  80155b:	50                   	push   %eax
  80155c:	ff d2                	call   *%edx
  80155e:	83 c4 10             	add    $0x10,%esp
}
  801561:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801564:	c9                   	leave  
  801565:	c3                   	ret    
			thisenv->env_id, fdnum);
  801566:	a1 90 67 80 00       	mov    0x806790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80156b:	8b 40 48             	mov    0x48(%eax),%eax
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	53                   	push   %ebx
  801572:	50                   	push   %eax
  801573:	68 0c 2a 80 00       	push   $0x802a0c
  801578:	e8 5e ef ff ff       	call   8004db <cprintf>
		return -E_INVAL;
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801585:	eb da                	jmp    801561 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801587:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158c:	eb d3                	jmp    801561 <ftruncate+0x52>

0080158e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	53                   	push   %ebx
  801592:	83 ec 14             	sub    $0x14,%esp
  801595:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801598:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	ff 75 08             	pushl  0x8(%ebp)
  80159f:	e8 81 fb ff ff       	call   801125 <fd_lookup>
  8015a4:	83 c4 08             	add    $0x8,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	78 4b                	js     8015f6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b1:	50                   	push   %eax
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b5:	ff 30                	pushl  (%eax)
  8015b7:	e8 bf fb ff ff       	call   80117b <dev_lookup>
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	78 33                	js     8015f6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015ca:	74 2f                	je     8015fb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015cc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015cf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015d6:	00 00 00 
	stat->st_isdir = 0;
  8015d9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015e0:	00 00 00 
	stat->st_dev = dev;
  8015e3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	53                   	push   %ebx
  8015ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f0:	ff 50 14             	call   *0x14(%eax)
  8015f3:	83 c4 10             	add    $0x10,%esp
}
  8015f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    
		return -E_NOT_SUPP;
  8015fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801600:	eb f4                	jmp    8015f6 <fstat+0x68>

00801602 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	56                   	push   %esi
  801606:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801607:	83 ec 08             	sub    $0x8,%esp
  80160a:	6a 00                	push   $0x0
  80160c:	ff 75 08             	pushl  0x8(%ebp)
  80160f:	e8 e7 01 00 00       	call   8017fb <open>
  801614:	89 c3                	mov    %eax,%ebx
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	85 c0                	test   %eax,%eax
  80161b:	78 1b                	js     801638 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80161d:	83 ec 08             	sub    $0x8,%esp
  801620:	ff 75 0c             	pushl  0xc(%ebp)
  801623:	50                   	push   %eax
  801624:	e8 65 ff ff ff       	call   80158e <fstat>
  801629:	89 c6                	mov    %eax,%esi
	close(fd);
  80162b:	89 1c 24             	mov    %ebx,(%esp)
  80162e:	e8 27 fc ff ff       	call   80125a <close>
	return r;
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	89 f3                	mov    %esi,%ebx
}
  801638:	89 d8                	mov    %ebx,%eax
  80163a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	56                   	push   %esi
  801645:	53                   	push   %ebx
  801646:	89 c6                	mov    %eax,%esi
  801648:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80164a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801651:	74 27                	je     80167a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801653:	6a 07                	push   $0x7
  801655:	68 00 70 80 00       	push   $0x807000
  80165a:	56                   	push   %esi
  80165b:	ff 35 00 50 80 00    	pushl  0x805000
  801661:	e8 03 0c 00 00       	call   802269 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801666:	83 c4 0c             	add    $0xc,%esp
  801669:	6a 00                	push   $0x0
  80166b:	53                   	push   %ebx
  80166c:	6a 00                	push   $0x0
  80166e:	e8 df 0b 00 00       	call   802252 <ipc_recv>
}
  801673:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801676:	5b                   	pop    %ebx
  801677:	5e                   	pop    %esi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80167a:	83 ec 0c             	sub    $0xc,%esp
  80167d:	6a 01                	push   $0x1
  80167f:	e8 fc 0b 00 00       	call   802280 <ipc_find_env>
  801684:	a3 00 50 80 00       	mov    %eax,0x805000
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	eb c5                	jmp    801653 <fsipc+0x12>

0080168e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	8b 40 0c             	mov    0xc(%eax),%eax
  80169a:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	b8 02 00 00 00       	mov    $0x2,%eax
  8016b1:	e8 8b ff ff ff       	call   801641 <fsipc>
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <devfile_flush>:
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c4:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8016c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ce:	b8 06 00 00 00       	mov    $0x6,%eax
  8016d3:	e8 69 ff ff ff       	call   801641 <fsipc>
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <devfile_stat>:
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 04             	sub    $0x4,%esp
  8016e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ea:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f4:	b8 05 00 00 00       	mov    $0x5,%eax
  8016f9:	e8 43 ff ff ff       	call   801641 <fsipc>
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 2c                	js     80172e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	68 00 70 80 00       	push   $0x807000
  80170a:	53                   	push   %ebx
  80170b:	e8 b5 f3 ff ff       	call   800ac5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801710:	a1 80 70 80 00       	mov    0x807080,%eax
  801715:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80171b:	a1 84 70 80 00       	mov    0x807084,%eax
  801720:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801726:	83 c4 10             	add    $0x10,%esp
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <devfile_write>:
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 0c             	sub    $0xc,%esp
  801739:	8b 45 10             	mov    0x10(%ebp),%eax
  80173c:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801741:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801746:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801749:	8b 55 08             	mov    0x8(%ebp),%edx
  80174c:	8b 52 0c             	mov    0xc(%edx),%edx
  80174f:	89 15 00 70 80 00    	mov    %edx,0x807000
        fsipcbuf.write.req_n = n;
  801755:	a3 04 70 80 00       	mov    %eax,0x807004
        memmove(fsipcbuf.write.req_buf, buf, n);
  80175a:	50                   	push   %eax
  80175b:	ff 75 0c             	pushl  0xc(%ebp)
  80175e:	68 08 70 80 00       	push   $0x807008
  801763:	e8 eb f4 ff ff       	call   800c53 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801768:	ba 00 00 00 00       	mov    $0x0,%edx
  80176d:	b8 04 00 00 00       	mov    $0x4,%eax
  801772:	e8 ca fe ff ff       	call   801641 <fsipc>
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <devfile_read>:
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	56                   	push   %esi
  80177d:	53                   	push   %ebx
  80177e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	8b 40 0c             	mov    0xc(%eax),%eax
  801787:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80178c:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801792:	ba 00 00 00 00       	mov    $0x0,%edx
  801797:	b8 03 00 00 00       	mov    $0x3,%eax
  80179c:	e8 a0 fe ff ff       	call   801641 <fsipc>
  8017a1:	89 c3                	mov    %eax,%ebx
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 1f                	js     8017c6 <devfile_read+0x4d>
	assert(r <= n);
  8017a7:	39 f0                	cmp    %esi,%eax
  8017a9:	77 24                	ja     8017cf <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017ab:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017b0:	7f 33                	jg     8017e5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017b2:	83 ec 04             	sub    $0x4,%esp
  8017b5:	50                   	push   %eax
  8017b6:	68 00 70 80 00       	push   $0x807000
  8017bb:	ff 75 0c             	pushl  0xc(%ebp)
  8017be:	e8 90 f4 ff ff       	call   800c53 <memmove>
	return r;
  8017c3:	83 c4 10             	add    $0x10,%esp
}
  8017c6:	89 d8                	mov    %ebx,%eax
  8017c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017cb:	5b                   	pop    %ebx
  8017cc:	5e                   	pop    %esi
  8017cd:	5d                   	pop    %ebp
  8017ce:	c3                   	ret    
	assert(r <= n);
  8017cf:	68 78 2a 80 00       	push   $0x802a78
  8017d4:	68 7f 2a 80 00       	push   $0x802a7f
  8017d9:	6a 7c                	push   $0x7c
  8017db:	68 94 2a 80 00       	push   $0x802a94
  8017e0:	e8 1b ec ff ff       	call   800400 <_panic>
	assert(r <= PGSIZE);
  8017e5:	68 9f 2a 80 00       	push   $0x802a9f
  8017ea:	68 7f 2a 80 00       	push   $0x802a7f
  8017ef:	6a 7d                	push   $0x7d
  8017f1:	68 94 2a 80 00       	push   $0x802a94
  8017f6:	e8 05 ec ff ff       	call   800400 <_panic>

008017fb <open>:
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	56                   	push   %esi
  8017ff:	53                   	push   %ebx
  801800:	83 ec 1c             	sub    $0x1c,%esp
  801803:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801806:	56                   	push   %esi
  801807:	e8 82 f2 ff ff       	call   800a8e <strlen>
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801814:	7f 6c                	jg     801882 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801816:	83 ec 0c             	sub    $0xc,%esp
  801819:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181c:	50                   	push   %eax
  80181d:	e8 b4 f8 ff ff       	call   8010d6 <fd_alloc>
  801822:	89 c3                	mov    %eax,%ebx
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	85 c0                	test   %eax,%eax
  801829:	78 3c                	js     801867 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80182b:	83 ec 08             	sub    $0x8,%esp
  80182e:	56                   	push   %esi
  80182f:	68 00 70 80 00       	push   $0x807000
  801834:	e8 8c f2 ff ff       	call   800ac5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801844:	b8 01 00 00 00       	mov    $0x1,%eax
  801849:	e8 f3 fd ff ff       	call   801641 <fsipc>
  80184e:	89 c3                	mov    %eax,%ebx
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	85 c0                	test   %eax,%eax
  801855:	78 19                	js     801870 <open+0x75>
	return fd2num(fd);
  801857:	83 ec 0c             	sub    $0xc,%esp
  80185a:	ff 75 f4             	pushl  -0xc(%ebp)
  80185d:	e8 4d f8 ff ff       	call   8010af <fd2num>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	83 c4 10             	add    $0x10,%esp
}
  801867:	89 d8                	mov    %ebx,%eax
  801869:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186c:	5b                   	pop    %ebx
  80186d:	5e                   	pop    %esi
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    
		fd_close(fd, 0);
  801870:	83 ec 08             	sub    $0x8,%esp
  801873:	6a 00                	push   $0x0
  801875:	ff 75 f4             	pushl  -0xc(%ebp)
  801878:	e8 54 f9 ff ff       	call   8011d1 <fd_close>
		return r;
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	eb e5                	jmp    801867 <open+0x6c>
		return -E_BAD_PATH;
  801882:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801887:	eb de                	jmp    801867 <open+0x6c>

00801889 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80188f:	ba 00 00 00 00       	mov    $0x0,%edx
  801894:	b8 08 00 00 00       	mov    $0x8,%eax
  801899:	e8 a3 fd ff ff       	call   801641 <fsipc>
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	57                   	push   %edi
  8018a4:	56                   	push   %esi
  8018a5:	53                   	push   %ebx
  8018a6:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8018ac:	6a 00                	push   $0x0
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	e8 45 ff ff ff       	call   8017fb <open>
  8018b6:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	0f 88 40 03 00 00    	js     801c07 <spawn+0x367>
  8018c7:	89 c7                	mov    %eax,%edi
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	68 00 02 00 00       	push   $0x200
  8018d1:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8018d7:	50                   	push   %eax
  8018d8:	57                   	push   %edi
  8018d9:	e8 3f fb ff ff       	call   80141d <readn>
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8018e6:	75 5d                	jne    801945 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  8018e8:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8018ef:	45 4c 46 
  8018f2:	75 51                	jne    801945 <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8018f4:	b8 07 00 00 00       	mov    $0x7,%eax
  8018f9:	cd 30                	int    $0x30
  8018fb:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801901:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801907:	85 c0                	test   %eax,%eax
  801909:	0f 88 81 04 00 00    	js     801d90 <spawn+0x4f0>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80190f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801914:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801917:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80191d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801923:	b9 11 00 00 00       	mov    $0x11,%ecx
  801928:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80192a:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801930:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801936:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80193b:	be 00 00 00 00       	mov    $0x0,%esi
  801940:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801943:	eb 4b                	jmp    801990 <spawn+0xf0>
		close(fd);
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80194e:	e8 07 f9 ff ff       	call   80125a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801953:	83 c4 0c             	add    $0xc,%esp
  801956:	68 7f 45 4c 46       	push   $0x464c457f
  80195b:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801961:	68 ab 2a 80 00       	push   $0x802aab
  801966:	e8 70 eb ff ff       	call   8004db <cprintf>
		return -E_NOT_EXEC;
  80196b:	83 c4 10             	add    $0x10,%esp
  80196e:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801975:	ff ff ff 
  801978:	e9 8a 02 00 00       	jmp    801c07 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  80197d:	83 ec 0c             	sub    $0xc,%esp
  801980:	50                   	push   %eax
  801981:	e8 08 f1 ff ff       	call   800a8e <strlen>
  801986:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80198a:	83 c3 01             	add    $0x1,%ebx
  80198d:	83 c4 10             	add    $0x10,%esp
  801990:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801997:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80199a:	85 c0                	test   %eax,%eax
  80199c:	75 df                	jne    80197d <spawn+0xdd>
  80199e:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8019a4:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8019aa:	bf 00 10 40 00       	mov    $0x401000,%edi
  8019af:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8019b1:	89 fa                	mov    %edi,%edx
  8019b3:	83 e2 fc             	and    $0xfffffffc,%edx
  8019b6:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8019bd:	29 c2                	sub    %eax,%edx
  8019bf:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8019c5:	8d 42 f8             	lea    -0x8(%edx),%eax
  8019c8:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8019cd:	0f 86 ce 03 00 00    	jbe    801da1 <spawn+0x501>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	6a 07                	push   $0x7
  8019d8:	68 00 00 40 00       	push   $0x400000
  8019dd:	6a 00                	push   $0x0
  8019df:	e8 da f4 ff ff       	call   800ebe <sys_page_alloc>
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	0f 88 b7 03 00 00    	js     801da6 <spawn+0x506>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8019ef:	be 00 00 00 00       	mov    $0x0,%esi
  8019f4:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  8019fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019fd:	eb 30                	jmp    801a2f <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  8019ff:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a05:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801a0b:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801a0e:	83 ec 08             	sub    $0x8,%esp
  801a11:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a14:	57                   	push   %edi
  801a15:	e8 ab f0 ff ff       	call   800ac5 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a1a:	83 c4 04             	add    $0x4,%esp
  801a1d:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a20:	e8 69 f0 ff ff       	call   800a8e <strlen>
  801a25:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801a29:	83 c6 01             	add    $0x1,%esi
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	39 b5 88 fd ff ff    	cmp    %esi,-0x278(%ebp)
  801a35:	7f c8                	jg     8019ff <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801a37:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801a3d:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801a43:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801a4a:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801a50:	0f 85 8c 00 00 00    	jne    801ae2 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801a56:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801a5c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a62:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801a65:	89 f8                	mov    %edi,%eax
  801a67:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801a6d:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801a70:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801a75:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801a7b:	83 ec 0c             	sub    $0xc,%esp
  801a7e:	6a 07                	push   $0x7
  801a80:	68 00 d0 bf ee       	push   $0xeebfd000
  801a85:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801a8b:	68 00 00 40 00       	push   $0x400000
  801a90:	6a 00                	push   $0x0
  801a92:	e8 6a f4 ff ff       	call   800f01 <sys_page_map>
  801a97:	89 c3                	mov    %eax,%ebx
  801a99:	83 c4 20             	add    $0x20,%esp
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	0f 88 78 03 00 00    	js     801e1c <spawn+0x57c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801aa4:	83 ec 08             	sub    $0x8,%esp
  801aa7:	68 00 00 40 00       	push   $0x400000
  801aac:	6a 00                	push   $0x0
  801aae:	e8 90 f4 ff ff       	call   800f43 <sys_page_unmap>
  801ab3:	89 c3                	mov    %eax,%ebx
  801ab5:	83 c4 10             	add    $0x10,%esp
  801ab8:	85 c0                	test   %eax,%eax
  801aba:	0f 88 5c 03 00 00    	js     801e1c <spawn+0x57c>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801ac0:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801ac6:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801acd:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ad3:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801ada:	00 00 00 
  801add:	e9 56 01 00 00       	jmp    801c38 <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ae2:	68 38 2b 80 00       	push   $0x802b38
  801ae7:	68 7f 2a 80 00       	push   $0x802a7f
  801aec:	68 f2 00 00 00       	push   $0xf2
  801af1:	68 c5 2a 80 00       	push   $0x802ac5
  801af6:	e8 05 e9 ff ff       	call   800400 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801afb:	83 ec 04             	sub    $0x4,%esp
  801afe:	6a 07                	push   $0x7
  801b00:	68 00 00 40 00       	push   $0x400000
  801b05:	6a 00                	push   $0x0
  801b07:	e8 b2 f3 ff ff       	call   800ebe <sys_page_alloc>
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	0f 88 9a 02 00 00    	js     801db1 <spawn+0x511>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801b17:	83 ec 08             	sub    $0x8,%esp
  801b1a:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b20:	01 f0                	add    %esi,%eax
  801b22:	50                   	push   %eax
  801b23:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801b29:	e8 b8 f9 ff ff       	call   8014e6 <seek>
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	85 c0                	test   %eax,%eax
  801b33:	0f 88 7f 02 00 00    	js     801db8 <spawn+0x518>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801b39:	83 ec 04             	sub    $0x4,%esp
  801b3c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b42:	29 f0                	sub    %esi,%eax
  801b44:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b49:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801b4e:	0f 47 c1             	cmova  %ecx,%eax
  801b51:	50                   	push   %eax
  801b52:	68 00 00 40 00       	push   $0x400000
  801b57:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801b5d:	e8 bb f8 ff ff       	call   80141d <readn>
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	85 c0                	test   %eax,%eax
  801b67:	0f 88 52 02 00 00    	js     801dbf <spawn+0x51f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801b6d:	83 ec 0c             	sub    $0xc,%esp
  801b70:	57                   	push   %edi
  801b71:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  801b77:	56                   	push   %esi
  801b78:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801b7e:	68 00 00 40 00       	push   $0x400000
  801b83:	6a 00                	push   $0x0
  801b85:	e8 77 f3 ff ff       	call   800f01 <sys_page_map>
  801b8a:	83 c4 20             	add    $0x20,%esp
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	0f 88 80 00 00 00    	js     801c15 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801b95:	83 ec 08             	sub    $0x8,%esp
  801b98:	68 00 00 40 00       	push   $0x400000
  801b9d:	6a 00                	push   $0x0
  801b9f:	e8 9f f3 ff ff       	call   800f43 <sys_page_unmap>
  801ba4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801ba7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bad:	89 de                	mov    %ebx,%esi
  801baf:	39 9d 88 fd ff ff    	cmp    %ebx,-0x278(%ebp)
  801bb5:	76 73                	jbe    801c2a <spawn+0x38a>
		if (i >= filesz) {
  801bb7:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801bbd:	0f 87 38 ff ff ff    	ja     801afb <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	57                   	push   %edi
  801bc7:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  801bcd:	56                   	push   %esi
  801bce:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801bd4:	e8 e5 f2 ff ff       	call   800ebe <sys_page_alloc>
  801bd9:	83 c4 10             	add    $0x10,%esp
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	79 c7                	jns    801ba7 <spawn+0x307>
  801be0:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801beb:	e8 4f f2 ff ff       	call   800e3f <sys_env_destroy>
	close(fd);
  801bf0:	83 c4 04             	add    $0x4,%esp
  801bf3:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801bf9:	e8 5c f6 ff ff       	call   80125a <close>
	return r;
  801bfe:	83 c4 10             	add    $0x10,%esp
  801c01:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801c07:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c10:	5b                   	pop    %ebx
  801c11:	5e                   	pop    %esi
  801c12:	5f                   	pop    %edi
  801c13:	5d                   	pop    %ebp
  801c14:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801c15:	50                   	push   %eax
  801c16:	68 d1 2a 80 00       	push   $0x802ad1
  801c1b:	68 25 01 00 00       	push   $0x125
  801c20:	68 c5 2a 80 00       	push   $0x802ac5
  801c25:	e8 d6 e7 ff ff       	call   800400 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c2a:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801c31:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801c38:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801c3f:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801c45:	7e 71                	jle    801cb8 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801c47:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801c4d:	83 39 01             	cmpl   $0x1,(%ecx)
  801c50:	75 d8                	jne    801c2a <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801c52:	8b 41 18             	mov    0x18(%ecx),%eax
  801c55:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801c58:	83 f8 01             	cmp    $0x1,%eax
  801c5b:	19 ff                	sbb    %edi,%edi
  801c5d:	83 e7 fe             	and    $0xfffffffe,%edi
  801c60:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801c63:	8b 71 04             	mov    0x4(%ecx),%esi
  801c66:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801c6c:	8b 59 10             	mov    0x10(%ecx),%ebx
  801c6f:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801c75:	8b 41 14             	mov    0x14(%ecx),%eax
  801c78:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801c7e:	8b 51 08             	mov    0x8(%ecx),%edx
  801c81:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	if ((i = PGOFF(va))) {
  801c87:	89 d0                	mov    %edx,%eax
  801c89:	25 ff 0f 00 00       	and    $0xfff,%eax
  801c8e:	74 1e                	je     801cae <spawn+0x40e>
		va -= i;
  801c90:	29 c2                	sub    %eax,%edx
  801c92:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		memsz += i;
  801c98:	01 85 88 fd ff ff    	add    %eax,-0x278(%ebp)
		filesz += i;
  801c9e:	01 c3                	add    %eax,%ebx
  801ca0:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801ca6:	29 c6                	sub    %eax,%esi
  801ca8:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801cae:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cb3:	e9 f5 fe ff ff       	jmp    801bad <spawn+0x30d>
	close(fd);
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801cc1:	e8 94 f5 ff ff       	call   80125a <close>
  801cc6:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i, j, pn, r;

        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  801cc9:	bf 02 00 00 00       	mov    $0x2,%edi
  801cce:	eb 7c                	jmp    801d4c <spawn+0x4ac>
  801cd0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
                if (uvpd[i] & PTE_P) {
                        for (j = 0; j < NPTENTRIES; j++) {
  801cd6:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801cdc:	74 63                	je     801d41 <spawn+0x4a1>
                                pn = PGNUM(PGADDR(i, j, 0));
  801cde:	89 da                	mov    %ebx,%edx
  801ce0:	09 f2                	or     %esi,%edx
  801ce2:	89 d0                	mov    %edx,%eax
  801ce4:	c1 e8 0c             	shr    $0xc,%eax
                                if (pn == PGNUM(UXSTACKTOP - PGSIZE))
  801ce7:	3d ff eb 0e 00       	cmp    $0xeebff,%eax
  801cec:	74 53                	je     801d41 <spawn+0x4a1>
                                        break;
                                if ((uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  801cee:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  801cf5:	f6 c1 01             	test   $0x1,%cl
  801cf8:	74 d6                	je     801cd0 <spawn+0x430>
  801cfa:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  801d01:	f6 c5 04             	test   $0x4,%ch
  801d04:	74 ca                	je     801cd0 <spawn+0x430>
                                        if ((r = sys_page_map(0, (void *)PGADDR(i, j, 0), child, (void *)PGADDR(i, j, 0), uvpt[pn] & PTE_SYSCALL)) < 0)
  801d06:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d0d:	83 ec 0c             	sub    $0xc,%esp
  801d10:	25 07 0e 00 00       	and    $0xe07,%eax
  801d15:	50                   	push   %eax
  801d16:	52                   	push   %edx
  801d17:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d1d:	52                   	push   %edx
  801d1e:	6a 00                	push   $0x0
  801d20:	e8 dc f1 ff ff       	call   800f01 <sys_page_map>
  801d25:	83 c4 20             	add    $0x20,%esp
  801d28:	85 c0                	test   %eax,%eax
  801d2a:	79 a4                	jns    801cd0 <spawn+0x430>
		panic("copy_shared_pages: %e", r);
  801d2c:	50                   	push   %eax
  801d2d:	68 1f 2b 80 00       	push   $0x802b1f
  801d32:	68 82 00 00 00       	push   $0x82
  801d37:	68 c5 2a 80 00       	push   $0x802ac5
  801d3c:	e8 bf e6 ff ff       	call   800400 <_panic>
        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  801d41:	83 c7 01             	add    $0x1,%edi
  801d44:	81 ff bb 03 00 00    	cmp    $0x3bb,%edi
  801d4a:	74 7a                	je     801dc6 <spawn+0x526>
                if (uvpd[i] & PTE_P) {
  801d4c:	8b 04 bd 00 d0 7b ef 	mov    -0x10843000(,%edi,4),%eax
  801d53:	a8 01                	test   $0x1,%al
  801d55:	74 ea                	je     801d41 <spawn+0x4a1>
  801d57:	89 fe                	mov    %edi,%esi
  801d59:	c1 e6 16             	shl    $0x16,%esi
  801d5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d61:	e9 78 ff ff ff       	jmp    801cde <spawn+0x43e>
		panic("sys_env_set_trapframe: %e", r);
  801d66:	50                   	push   %eax
  801d67:	68 ee 2a 80 00       	push   $0x802aee
  801d6c:	68 86 00 00 00       	push   $0x86
  801d71:	68 c5 2a 80 00       	push   $0x802ac5
  801d76:	e8 85 e6 ff ff       	call   800400 <_panic>
		panic("sys_env_set_status: %e", r);
  801d7b:	50                   	push   %eax
  801d7c:	68 08 2b 80 00       	push   $0x802b08
  801d81:	68 89 00 00 00       	push   $0x89
  801d86:	68 c5 2a 80 00       	push   $0x802ac5
  801d8b:	e8 70 e6 ff ff       	call   800400 <_panic>
		return r;
  801d90:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d96:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801d9c:	e9 66 fe ff ff       	jmp    801c07 <spawn+0x367>
		return -E_NO_MEM;
  801da1:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801da6:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801dac:	e9 56 fe ff ff       	jmp    801c07 <spawn+0x367>
  801db1:	89 c7                	mov    %eax,%edi
  801db3:	e9 2a fe ff ff       	jmp    801be2 <spawn+0x342>
  801db8:	89 c7                	mov    %eax,%edi
  801dba:	e9 23 fe ff ff       	jmp    801be2 <spawn+0x342>
  801dbf:	89 c7                	mov    %eax,%edi
  801dc1:	e9 1c fe ff ff       	jmp    801be2 <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801dc6:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801dcd:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801dd0:	83 ec 08             	sub    $0x8,%esp
  801dd3:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801dd9:	50                   	push   %eax
  801dda:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801de0:	e8 e2 f1 ff ff       	call   800fc7 <sys_env_set_trapframe>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	85 c0                	test   %eax,%eax
  801dea:	0f 88 76 ff ff ff    	js     801d66 <spawn+0x4c6>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801df0:	83 ec 08             	sub    $0x8,%esp
  801df3:	6a 02                	push   $0x2
  801df5:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801dfb:	e8 85 f1 ff ff       	call   800f85 <sys_env_set_status>
  801e00:	83 c4 10             	add    $0x10,%esp
  801e03:	85 c0                	test   %eax,%eax
  801e05:	0f 88 70 ff ff ff    	js     801d7b <spawn+0x4db>
	return child;
  801e0b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e11:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801e17:	e9 eb fd ff ff       	jmp    801c07 <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  801e1c:	83 ec 08             	sub    $0x8,%esp
  801e1f:	68 00 00 40 00       	push   $0x400000
  801e24:	6a 00                	push   $0x0
  801e26:	e8 18 f1 ff ff       	call   800f43 <sys_page_unmap>
  801e2b:	83 c4 10             	add    $0x10,%esp
  801e2e:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801e34:	e9 ce fd ff ff       	jmp    801c07 <spawn+0x367>

00801e39 <spawnl>:
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	57                   	push   %edi
  801e3d:	56                   	push   %esi
  801e3e:	53                   	push   %ebx
  801e3f:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801e42:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801e4a:	eb 05                	jmp    801e51 <spawnl+0x18>
		argc++;
  801e4c:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801e4f:	89 ca                	mov    %ecx,%edx
  801e51:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e54:	83 3a 00             	cmpl   $0x0,(%edx)
  801e57:	75 f3                	jne    801e4c <spawnl+0x13>
	const char *argv[argc+2];
  801e59:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801e60:	83 e2 f0             	and    $0xfffffff0,%edx
  801e63:	29 d4                	sub    %edx,%esp
  801e65:	8d 54 24 03          	lea    0x3(%esp),%edx
  801e69:	c1 ea 02             	shr    $0x2,%edx
  801e6c:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801e73:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e78:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801e7f:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801e86:	00 
	va_start(vl, arg0);
  801e87:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801e8a:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e91:	eb 0b                	jmp    801e9e <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801e93:	83 c0 01             	add    $0x1,%eax
  801e96:	8b 39                	mov    (%ecx),%edi
  801e98:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801e9b:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801e9e:	39 d0                	cmp    %edx,%eax
  801ea0:	75 f1                	jne    801e93 <spawnl+0x5a>
	return spawn(prog, argv);
  801ea2:	83 ec 08             	sub    $0x8,%esp
  801ea5:	56                   	push   %esi
  801ea6:	ff 75 08             	pushl  0x8(%ebp)
  801ea9:	e8 f2 f9 ff ff       	call   8018a0 <spawn>
}
  801eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eb1:	5b                   	pop    %ebx
  801eb2:	5e                   	pop    %esi
  801eb3:	5f                   	pop    %edi
  801eb4:	5d                   	pop    %ebp
  801eb5:	c3                   	ret    

00801eb6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	56                   	push   %esi
  801eba:	53                   	push   %ebx
  801ebb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ebe:	83 ec 0c             	sub    $0xc,%esp
  801ec1:	ff 75 08             	pushl  0x8(%ebp)
  801ec4:	e8 f6 f1 ff ff       	call   8010bf <fd2data>
  801ec9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ecb:	83 c4 08             	add    $0x8,%esp
  801ece:	68 60 2b 80 00       	push   $0x802b60
  801ed3:	53                   	push   %ebx
  801ed4:	e8 ec eb ff ff       	call   800ac5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ed9:	8b 46 04             	mov    0x4(%esi),%eax
  801edc:	2b 06                	sub    (%esi),%eax
  801ede:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ee4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801eeb:	00 00 00 
	stat->st_dev = &devpipe;
  801eee:	c7 83 88 00 00 00 ac 	movl   $0x8047ac,0x88(%ebx)
  801ef5:	47 80 00 
	return 0;
}
  801ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  801efd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f00:	5b                   	pop    %ebx
  801f01:	5e                   	pop    %esi
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    

00801f04 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	53                   	push   %ebx
  801f08:	83 ec 0c             	sub    $0xc,%esp
  801f0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f0e:	53                   	push   %ebx
  801f0f:	6a 00                	push   $0x0
  801f11:	e8 2d f0 ff ff       	call   800f43 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f16:	89 1c 24             	mov    %ebx,(%esp)
  801f19:	e8 a1 f1 ff ff       	call   8010bf <fd2data>
  801f1e:	83 c4 08             	add    $0x8,%esp
  801f21:	50                   	push   %eax
  801f22:	6a 00                	push   $0x0
  801f24:	e8 1a f0 ff ff       	call   800f43 <sys_page_unmap>
}
  801f29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <_pipeisclosed>:
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	57                   	push   %edi
  801f32:	56                   	push   %esi
  801f33:	53                   	push   %ebx
  801f34:	83 ec 1c             	sub    $0x1c,%esp
  801f37:	89 c7                	mov    %eax,%edi
  801f39:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f3b:	a1 90 67 80 00       	mov    0x806790,%eax
  801f40:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f43:	83 ec 0c             	sub    $0xc,%esp
  801f46:	57                   	push   %edi
  801f47:	e8 6d 03 00 00       	call   8022b9 <pageref>
  801f4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f4f:	89 34 24             	mov    %esi,(%esp)
  801f52:	e8 62 03 00 00       	call   8022b9 <pageref>
		nn = thisenv->env_runs;
  801f57:	8b 15 90 67 80 00    	mov    0x806790,%edx
  801f5d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	39 cb                	cmp    %ecx,%ebx
  801f65:	74 1b                	je     801f82 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f67:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f6a:	75 cf                	jne    801f3b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f6c:	8b 42 58             	mov    0x58(%edx),%eax
  801f6f:	6a 01                	push   $0x1
  801f71:	50                   	push   %eax
  801f72:	53                   	push   %ebx
  801f73:	68 67 2b 80 00       	push   $0x802b67
  801f78:	e8 5e e5 ff ff       	call   8004db <cprintf>
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	eb b9                	jmp    801f3b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f82:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f85:	0f 94 c0             	sete   %al
  801f88:	0f b6 c0             	movzbl %al,%eax
}
  801f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f8e:	5b                   	pop    %ebx
  801f8f:	5e                   	pop    %esi
  801f90:	5f                   	pop    %edi
  801f91:	5d                   	pop    %ebp
  801f92:	c3                   	ret    

00801f93 <devpipe_write>:
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	57                   	push   %edi
  801f97:	56                   	push   %esi
  801f98:	53                   	push   %ebx
  801f99:	83 ec 28             	sub    $0x28,%esp
  801f9c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f9f:	56                   	push   %esi
  801fa0:	e8 1a f1 ff ff       	call   8010bf <fd2data>
  801fa5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fa7:	83 c4 10             	add    $0x10,%esp
  801faa:	bf 00 00 00 00       	mov    $0x0,%edi
  801faf:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fb2:	74 4f                	je     802003 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fb4:	8b 43 04             	mov    0x4(%ebx),%eax
  801fb7:	8b 0b                	mov    (%ebx),%ecx
  801fb9:	8d 51 20             	lea    0x20(%ecx),%edx
  801fbc:	39 d0                	cmp    %edx,%eax
  801fbe:	72 14                	jb     801fd4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801fc0:	89 da                	mov    %ebx,%edx
  801fc2:	89 f0                	mov    %esi,%eax
  801fc4:	e8 65 ff ff ff       	call   801f2e <_pipeisclosed>
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	75 3a                	jne    802007 <devpipe_write+0x74>
			sys_yield();
  801fcd:	e8 cd ee ff ff       	call   800e9f <sys_yield>
  801fd2:	eb e0                	jmp    801fb4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fd7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fdb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fde:	89 c2                	mov    %eax,%edx
  801fe0:	c1 fa 1f             	sar    $0x1f,%edx
  801fe3:	89 d1                	mov    %edx,%ecx
  801fe5:	c1 e9 1b             	shr    $0x1b,%ecx
  801fe8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801feb:	83 e2 1f             	and    $0x1f,%edx
  801fee:	29 ca                	sub    %ecx,%edx
  801ff0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ff4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ff8:	83 c0 01             	add    $0x1,%eax
  801ffb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ffe:	83 c7 01             	add    $0x1,%edi
  802001:	eb ac                	jmp    801faf <devpipe_write+0x1c>
	return i;
  802003:	89 f8                	mov    %edi,%eax
  802005:	eb 05                	jmp    80200c <devpipe_write+0x79>
				return 0;
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80200f:	5b                   	pop    %ebx
  802010:	5e                   	pop    %esi
  802011:	5f                   	pop    %edi
  802012:	5d                   	pop    %ebp
  802013:	c3                   	ret    

00802014 <devpipe_read>:
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	57                   	push   %edi
  802018:	56                   	push   %esi
  802019:	53                   	push   %ebx
  80201a:	83 ec 18             	sub    $0x18,%esp
  80201d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802020:	57                   	push   %edi
  802021:	e8 99 f0 ff ff       	call   8010bf <fd2data>
  802026:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	be 00 00 00 00       	mov    $0x0,%esi
  802030:	3b 75 10             	cmp    0x10(%ebp),%esi
  802033:	74 47                	je     80207c <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802035:	8b 03                	mov    (%ebx),%eax
  802037:	3b 43 04             	cmp    0x4(%ebx),%eax
  80203a:	75 22                	jne    80205e <devpipe_read+0x4a>
			if (i > 0)
  80203c:	85 f6                	test   %esi,%esi
  80203e:	75 14                	jne    802054 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802040:	89 da                	mov    %ebx,%edx
  802042:	89 f8                	mov    %edi,%eax
  802044:	e8 e5 fe ff ff       	call   801f2e <_pipeisclosed>
  802049:	85 c0                	test   %eax,%eax
  80204b:	75 33                	jne    802080 <devpipe_read+0x6c>
			sys_yield();
  80204d:	e8 4d ee ff ff       	call   800e9f <sys_yield>
  802052:	eb e1                	jmp    802035 <devpipe_read+0x21>
				return i;
  802054:	89 f0                	mov    %esi,%eax
}
  802056:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802059:	5b                   	pop    %ebx
  80205a:	5e                   	pop    %esi
  80205b:	5f                   	pop    %edi
  80205c:	5d                   	pop    %ebp
  80205d:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80205e:	99                   	cltd   
  80205f:	c1 ea 1b             	shr    $0x1b,%edx
  802062:	01 d0                	add    %edx,%eax
  802064:	83 e0 1f             	and    $0x1f,%eax
  802067:	29 d0                	sub    %edx,%eax
  802069:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80206e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802071:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802074:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802077:	83 c6 01             	add    $0x1,%esi
  80207a:	eb b4                	jmp    802030 <devpipe_read+0x1c>
	return i;
  80207c:	89 f0                	mov    %esi,%eax
  80207e:	eb d6                	jmp    802056 <devpipe_read+0x42>
				return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
  802085:	eb cf                	jmp    802056 <devpipe_read+0x42>

00802087 <pipe>:
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	56                   	push   %esi
  80208b:	53                   	push   %ebx
  80208c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80208f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802092:	50                   	push   %eax
  802093:	e8 3e f0 ff ff       	call   8010d6 <fd_alloc>
  802098:	89 c3                	mov    %eax,%ebx
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	85 c0                	test   %eax,%eax
  80209f:	78 5b                	js     8020fc <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	68 07 04 00 00       	push   $0x407
  8020a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ac:	6a 00                	push   $0x0
  8020ae:	e8 0b ee ff ff       	call   800ebe <sys_page_alloc>
  8020b3:	89 c3                	mov    %eax,%ebx
  8020b5:	83 c4 10             	add    $0x10,%esp
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	78 40                	js     8020fc <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020c2:	50                   	push   %eax
  8020c3:	e8 0e f0 ff ff       	call   8010d6 <fd_alloc>
  8020c8:	89 c3                	mov    %eax,%ebx
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 1b                	js     8020ec <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020d1:	83 ec 04             	sub    $0x4,%esp
  8020d4:	68 07 04 00 00       	push   $0x407
  8020d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8020dc:	6a 00                	push   $0x0
  8020de:	e8 db ed ff ff       	call   800ebe <sys_page_alloc>
  8020e3:	89 c3                	mov    %eax,%ebx
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	79 19                	jns    802105 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8020ec:	83 ec 08             	sub    $0x8,%esp
  8020ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f2:	6a 00                	push   $0x0
  8020f4:	e8 4a ee ff ff       	call   800f43 <sys_page_unmap>
  8020f9:	83 c4 10             	add    $0x10,%esp
}
  8020fc:	89 d8                	mov    %ebx,%eax
  8020fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802101:	5b                   	pop    %ebx
  802102:	5e                   	pop    %esi
  802103:	5d                   	pop    %ebp
  802104:	c3                   	ret    
	va = fd2data(fd0);
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	ff 75 f4             	pushl  -0xc(%ebp)
  80210b:	e8 af ef ff ff       	call   8010bf <fd2data>
  802110:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802112:	83 c4 0c             	add    $0xc,%esp
  802115:	68 07 04 00 00       	push   $0x407
  80211a:	50                   	push   %eax
  80211b:	6a 00                	push   $0x0
  80211d:	e8 9c ed ff ff       	call   800ebe <sys_page_alloc>
  802122:	89 c3                	mov    %eax,%ebx
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	85 c0                	test   %eax,%eax
  802129:	0f 88 8c 00 00 00    	js     8021bb <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80212f:	83 ec 0c             	sub    $0xc,%esp
  802132:	ff 75 f0             	pushl  -0x10(%ebp)
  802135:	e8 85 ef ff ff       	call   8010bf <fd2data>
  80213a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802141:	50                   	push   %eax
  802142:	6a 00                	push   $0x0
  802144:	56                   	push   %esi
  802145:	6a 00                	push   $0x0
  802147:	e8 b5 ed ff ff       	call   800f01 <sys_page_map>
  80214c:	89 c3                	mov    %eax,%ebx
  80214e:	83 c4 20             	add    $0x20,%esp
  802151:	85 c0                	test   %eax,%eax
  802153:	78 58                	js     8021ad <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802158:	8b 15 ac 47 80 00    	mov    0x8047ac,%edx
  80215e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802163:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80216a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216d:	8b 15 ac 47 80 00    	mov    0x8047ac,%edx
  802173:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802178:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80217f:	83 ec 0c             	sub    $0xc,%esp
  802182:	ff 75 f4             	pushl  -0xc(%ebp)
  802185:	e8 25 ef ff ff       	call   8010af <fd2num>
  80218a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80218d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80218f:	83 c4 04             	add    $0x4,%esp
  802192:	ff 75 f0             	pushl  -0x10(%ebp)
  802195:	e8 15 ef ff ff       	call   8010af <fd2num>
  80219a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80219d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021a0:	83 c4 10             	add    $0x10,%esp
  8021a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021a8:	e9 4f ff ff ff       	jmp    8020fc <pipe+0x75>
	sys_page_unmap(0, va);
  8021ad:	83 ec 08             	sub    $0x8,%esp
  8021b0:	56                   	push   %esi
  8021b1:	6a 00                	push   $0x0
  8021b3:	e8 8b ed ff ff       	call   800f43 <sys_page_unmap>
  8021b8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021bb:	83 ec 08             	sub    $0x8,%esp
  8021be:	ff 75 f0             	pushl  -0x10(%ebp)
  8021c1:	6a 00                	push   $0x0
  8021c3:	e8 7b ed ff ff       	call   800f43 <sys_page_unmap>
  8021c8:	83 c4 10             	add    $0x10,%esp
  8021cb:	e9 1c ff ff ff       	jmp    8020ec <pipe+0x65>

008021d0 <pipeisclosed>:
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021d9:	50                   	push   %eax
  8021da:	ff 75 08             	pushl  0x8(%ebp)
  8021dd:	e8 43 ef ff ff       	call   801125 <fd_lookup>
  8021e2:	83 c4 10             	add    $0x10,%esp
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	78 18                	js     802201 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8021e9:	83 ec 0c             	sub    $0xc,%esp
  8021ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ef:	e8 cb ee ff ff       	call   8010bf <fd2data>
	return _pipeisclosed(fd, p);
  8021f4:	89 c2                	mov    %eax,%edx
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	e8 30 fd ff ff       	call   801f2e <_pipeisclosed>
  8021fe:	83 c4 10             	add    $0x10,%esp
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	56                   	push   %esi
  802207:	53                   	push   %ebx
  802208:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80220b:	85 f6                	test   %esi,%esi
  80220d:	74 13                	je     802222 <wait+0x1f>
	e = &envs[ENVX(envid)];
  80220f:	89 f3                	mov    %esi,%ebx
  802211:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802217:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80221a:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802220:	eb 1b                	jmp    80223d <wait+0x3a>
	assert(envid != 0);
  802222:	68 7f 2b 80 00       	push   $0x802b7f
  802227:	68 7f 2a 80 00       	push   $0x802a7f
  80222c:	6a 09                	push   $0x9
  80222e:	68 8a 2b 80 00       	push   $0x802b8a
  802233:	e8 c8 e1 ff ff       	call   800400 <_panic>
		sys_yield();
  802238:	e8 62 ec ff ff       	call   800e9f <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80223d:	8b 43 48             	mov    0x48(%ebx),%eax
  802240:	39 f0                	cmp    %esi,%eax
  802242:	75 07                	jne    80224b <wait+0x48>
  802244:	8b 43 54             	mov    0x54(%ebx),%eax
  802247:	85 c0                	test   %eax,%eax
  802249:	75 ed                	jne    802238 <wait+0x35>
}
  80224b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80224e:	5b                   	pop    %ebx
  80224f:	5e                   	pop    %esi
  802250:	5d                   	pop    %ebp
  802251:	c3                   	ret    

00802252 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  802258:	68 95 2b 80 00       	push   $0x802b95
  80225d:	6a 1a                	push   $0x1a
  80225f:	68 ae 2b 80 00       	push   $0x802bae
  802264:	e8 97 e1 ff ff       	call   800400 <_panic>

00802269 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
  80226c:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  80226f:	68 b8 2b 80 00       	push   $0x802bb8
  802274:	6a 2a                	push   $0x2a
  802276:	68 ae 2b 80 00       	push   $0x802bae
  80227b:	e8 80 e1 ff ff       	call   800400 <_panic>

00802280 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80228b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80228e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802294:	8b 52 50             	mov    0x50(%edx),%edx
  802297:	39 ca                	cmp    %ecx,%edx
  802299:	74 11                	je     8022ac <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80229b:	83 c0 01             	add    $0x1,%eax
  80229e:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022a3:	75 e6                	jne    80228b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022aa:	eb 0b                	jmp    8022b7 <ipc_find_env+0x37>
			return envs[i].env_id;
  8022ac:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022b4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    

008022b9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022bf:	89 d0                	mov    %edx,%eax
  8022c1:	c1 e8 16             	shr    $0x16,%eax
  8022c4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022d0:	f6 c1 01             	test   $0x1,%cl
  8022d3:	74 1d                	je     8022f2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022d5:	c1 ea 0c             	shr    $0xc,%edx
  8022d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022df:	f6 c2 01             	test   $0x1,%dl
  8022e2:	74 0e                	je     8022f2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022e4:	c1 ea 0c             	shr    $0xc,%edx
  8022e7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022ee:	ef 
  8022ef:	0f b7 c0             	movzwl %ax,%eax
}
  8022f2:	5d                   	pop    %ebp
  8022f3:	c3                   	ret    
  8022f4:	66 90                	xchg   %ax,%ax
  8022f6:	66 90                	xchg   %ax,%ax
  8022f8:	66 90                	xchg   %ax,%ax
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <__udivdi3>:
  802300:	55                   	push   %ebp
  802301:	57                   	push   %edi
  802302:	56                   	push   %esi
  802303:	53                   	push   %ebx
  802304:	83 ec 1c             	sub    $0x1c,%esp
  802307:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80230b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80230f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802313:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802317:	85 d2                	test   %edx,%edx
  802319:	75 35                	jne    802350 <__udivdi3+0x50>
  80231b:	39 f3                	cmp    %esi,%ebx
  80231d:	0f 87 bd 00 00 00    	ja     8023e0 <__udivdi3+0xe0>
  802323:	85 db                	test   %ebx,%ebx
  802325:	89 d9                	mov    %ebx,%ecx
  802327:	75 0b                	jne    802334 <__udivdi3+0x34>
  802329:	b8 01 00 00 00       	mov    $0x1,%eax
  80232e:	31 d2                	xor    %edx,%edx
  802330:	f7 f3                	div    %ebx
  802332:	89 c1                	mov    %eax,%ecx
  802334:	31 d2                	xor    %edx,%edx
  802336:	89 f0                	mov    %esi,%eax
  802338:	f7 f1                	div    %ecx
  80233a:	89 c6                	mov    %eax,%esi
  80233c:	89 e8                	mov    %ebp,%eax
  80233e:	89 f7                	mov    %esi,%edi
  802340:	f7 f1                	div    %ecx
  802342:	89 fa                	mov    %edi,%edx
  802344:	83 c4 1c             	add    $0x1c,%esp
  802347:	5b                   	pop    %ebx
  802348:	5e                   	pop    %esi
  802349:	5f                   	pop    %edi
  80234a:	5d                   	pop    %ebp
  80234b:	c3                   	ret    
  80234c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802350:	39 f2                	cmp    %esi,%edx
  802352:	77 7c                	ja     8023d0 <__udivdi3+0xd0>
  802354:	0f bd fa             	bsr    %edx,%edi
  802357:	83 f7 1f             	xor    $0x1f,%edi
  80235a:	0f 84 98 00 00 00    	je     8023f8 <__udivdi3+0xf8>
  802360:	89 f9                	mov    %edi,%ecx
  802362:	b8 20 00 00 00       	mov    $0x20,%eax
  802367:	29 f8                	sub    %edi,%eax
  802369:	d3 e2                	shl    %cl,%edx
  80236b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80236f:	89 c1                	mov    %eax,%ecx
  802371:	89 da                	mov    %ebx,%edx
  802373:	d3 ea                	shr    %cl,%edx
  802375:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802379:	09 d1                	or     %edx,%ecx
  80237b:	89 f2                	mov    %esi,%edx
  80237d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802381:	89 f9                	mov    %edi,%ecx
  802383:	d3 e3                	shl    %cl,%ebx
  802385:	89 c1                	mov    %eax,%ecx
  802387:	d3 ea                	shr    %cl,%edx
  802389:	89 f9                	mov    %edi,%ecx
  80238b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80238f:	d3 e6                	shl    %cl,%esi
  802391:	89 eb                	mov    %ebp,%ebx
  802393:	89 c1                	mov    %eax,%ecx
  802395:	d3 eb                	shr    %cl,%ebx
  802397:	09 de                	or     %ebx,%esi
  802399:	89 f0                	mov    %esi,%eax
  80239b:	f7 74 24 08          	divl   0x8(%esp)
  80239f:	89 d6                	mov    %edx,%esi
  8023a1:	89 c3                	mov    %eax,%ebx
  8023a3:	f7 64 24 0c          	mull   0xc(%esp)
  8023a7:	39 d6                	cmp    %edx,%esi
  8023a9:	72 0c                	jb     8023b7 <__udivdi3+0xb7>
  8023ab:	89 f9                	mov    %edi,%ecx
  8023ad:	d3 e5                	shl    %cl,%ebp
  8023af:	39 c5                	cmp    %eax,%ebp
  8023b1:	73 5d                	jae    802410 <__udivdi3+0x110>
  8023b3:	39 d6                	cmp    %edx,%esi
  8023b5:	75 59                	jne    802410 <__udivdi3+0x110>
  8023b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023ba:	31 ff                	xor    %edi,%edi
  8023bc:	89 fa                	mov    %edi,%edx
  8023be:	83 c4 1c             	add    $0x1c,%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5f                   	pop    %edi
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    
  8023c6:	8d 76 00             	lea    0x0(%esi),%esi
  8023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8023d0:	31 ff                	xor    %edi,%edi
  8023d2:	31 c0                	xor    %eax,%eax
  8023d4:	89 fa                	mov    %edi,%edx
  8023d6:	83 c4 1c             	add    $0x1c,%esp
  8023d9:	5b                   	pop    %ebx
  8023da:	5e                   	pop    %esi
  8023db:	5f                   	pop    %edi
  8023dc:	5d                   	pop    %ebp
  8023dd:	c3                   	ret    
  8023de:	66 90                	xchg   %ax,%ax
  8023e0:	31 ff                	xor    %edi,%edi
  8023e2:	89 e8                	mov    %ebp,%eax
  8023e4:	89 f2                	mov    %esi,%edx
  8023e6:	f7 f3                	div    %ebx
  8023e8:	89 fa                	mov    %edi,%edx
  8023ea:	83 c4 1c             	add    $0x1c,%esp
  8023ed:	5b                   	pop    %ebx
  8023ee:	5e                   	pop    %esi
  8023ef:	5f                   	pop    %edi
  8023f0:	5d                   	pop    %ebp
  8023f1:	c3                   	ret    
  8023f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023f8:	39 f2                	cmp    %esi,%edx
  8023fa:	72 06                	jb     802402 <__udivdi3+0x102>
  8023fc:	31 c0                	xor    %eax,%eax
  8023fe:	39 eb                	cmp    %ebp,%ebx
  802400:	77 d2                	ja     8023d4 <__udivdi3+0xd4>
  802402:	b8 01 00 00 00       	mov    $0x1,%eax
  802407:	eb cb                	jmp    8023d4 <__udivdi3+0xd4>
  802409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802410:	89 d8                	mov    %ebx,%eax
  802412:	31 ff                	xor    %edi,%edi
  802414:	eb be                	jmp    8023d4 <__udivdi3+0xd4>
  802416:	66 90                	xchg   %ax,%ax
  802418:	66 90                	xchg   %ax,%ax
  80241a:	66 90                	xchg   %ax,%ax
  80241c:	66 90                	xchg   %ax,%ax
  80241e:	66 90                	xchg   %ax,%ax

00802420 <__umoddi3>:
  802420:	55                   	push   %ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	53                   	push   %ebx
  802424:	83 ec 1c             	sub    $0x1c,%esp
  802427:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80242b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80242f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802433:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802437:	85 ed                	test   %ebp,%ebp
  802439:	89 f0                	mov    %esi,%eax
  80243b:	89 da                	mov    %ebx,%edx
  80243d:	75 19                	jne    802458 <__umoddi3+0x38>
  80243f:	39 df                	cmp    %ebx,%edi
  802441:	0f 86 b1 00 00 00    	jbe    8024f8 <__umoddi3+0xd8>
  802447:	f7 f7                	div    %edi
  802449:	89 d0                	mov    %edx,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	83 c4 1c             	add    $0x1c,%esp
  802450:	5b                   	pop    %ebx
  802451:	5e                   	pop    %esi
  802452:	5f                   	pop    %edi
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    
  802455:	8d 76 00             	lea    0x0(%esi),%esi
  802458:	39 dd                	cmp    %ebx,%ebp
  80245a:	77 f1                	ja     80244d <__umoddi3+0x2d>
  80245c:	0f bd cd             	bsr    %ebp,%ecx
  80245f:	83 f1 1f             	xor    $0x1f,%ecx
  802462:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802466:	0f 84 b4 00 00 00    	je     802520 <__umoddi3+0x100>
  80246c:	b8 20 00 00 00       	mov    $0x20,%eax
  802471:	89 c2                	mov    %eax,%edx
  802473:	8b 44 24 04          	mov    0x4(%esp),%eax
  802477:	29 c2                	sub    %eax,%edx
  802479:	89 c1                	mov    %eax,%ecx
  80247b:	89 f8                	mov    %edi,%eax
  80247d:	d3 e5                	shl    %cl,%ebp
  80247f:	89 d1                	mov    %edx,%ecx
  802481:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802485:	d3 e8                	shr    %cl,%eax
  802487:	09 c5                	or     %eax,%ebp
  802489:	8b 44 24 04          	mov    0x4(%esp),%eax
  80248d:	89 c1                	mov    %eax,%ecx
  80248f:	d3 e7                	shl    %cl,%edi
  802491:	89 d1                	mov    %edx,%ecx
  802493:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802497:	89 df                	mov    %ebx,%edi
  802499:	d3 ef                	shr    %cl,%edi
  80249b:	89 c1                	mov    %eax,%ecx
  80249d:	89 f0                	mov    %esi,%eax
  80249f:	d3 e3                	shl    %cl,%ebx
  8024a1:	89 d1                	mov    %edx,%ecx
  8024a3:	89 fa                	mov    %edi,%edx
  8024a5:	d3 e8                	shr    %cl,%eax
  8024a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ac:	09 d8                	or     %ebx,%eax
  8024ae:	f7 f5                	div    %ebp
  8024b0:	d3 e6                	shl    %cl,%esi
  8024b2:	89 d1                	mov    %edx,%ecx
  8024b4:	f7 64 24 08          	mull   0x8(%esp)
  8024b8:	39 d1                	cmp    %edx,%ecx
  8024ba:	89 c3                	mov    %eax,%ebx
  8024bc:	89 d7                	mov    %edx,%edi
  8024be:	72 06                	jb     8024c6 <__umoddi3+0xa6>
  8024c0:	75 0e                	jne    8024d0 <__umoddi3+0xb0>
  8024c2:	39 c6                	cmp    %eax,%esi
  8024c4:	73 0a                	jae    8024d0 <__umoddi3+0xb0>
  8024c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8024ca:	19 ea                	sbb    %ebp,%edx
  8024cc:	89 d7                	mov    %edx,%edi
  8024ce:	89 c3                	mov    %eax,%ebx
  8024d0:	89 ca                	mov    %ecx,%edx
  8024d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8024d7:	29 de                	sub    %ebx,%esi
  8024d9:	19 fa                	sbb    %edi,%edx
  8024db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8024df:	89 d0                	mov    %edx,%eax
  8024e1:	d3 e0                	shl    %cl,%eax
  8024e3:	89 d9                	mov    %ebx,%ecx
  8024e5:	d3 ee                	shr    %cl,%esi
  8024e7:	d3 ea                	shr    %cl,%edx
  8024e9:	09 f0                	or     %esi,%eax
  8024eb:	83 c4 1c             	add    $0x1c,%esp
  8024ee:	5b                   	pop    %ebx
  8024ef:	5e                   	pop    %esi
  8024f0:	5f                   	pop    %edi
  8024f1:	5d                   	pop    %ebp
  8024f2:	c3                   	ret    
  8024f3:	90                   	nop
  8024f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	85 ff                	test   %edi,%edi
  8024fa:	89 f9                	mov    %edi,%ecx
  8024fc:	75 0b                	jne    802509 <__umoddi3+0xe9>
  8024fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802503:	31 d2                	xor    %edx,%edx
  802505:	f7 f7                	div    %edi
  802507:	89 c1                	mov    %eax,%ecx
  802509:	89 d8                	mov    %ebx,%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	f7 f1                	div    %ecx
  80250f:	89 f0                	mov    %esi,%eax
  802511:	f7 f1                	div    %ecx
  802513:	e9 31 ff ff ff       	jmp    802449 <__umoddi3+0x29>
  802518:	90                   	nop
  802519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802520:	39 dd                	cmp    %ebx,%ebp
  802522:	72 08                	jb     80252c <__umoddi3+0x10c>
  802524:	39 f7                	cmp    %esi,%edi
  802526:	0f 87 21 ff ff ff    	ja     80244d <__umoddi3+0x2d>
  80252c:	89 da                	mov    %ebx,%edx
  80252e:	89 f0                	mov    %esi,%eax
  802530:	29 f8                	sub    %edi,%eax
  802532:	19 ea                	sbb    %ebp,%edx
  802534:	e9 14 ff ff ff       	jmp    80244d <__umoddi3+0x2d>
