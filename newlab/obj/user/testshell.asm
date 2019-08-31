
obj/user/testshell.debug：     文件格式 elf32-i386


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
  80002c:	e8 5f 04 00 00       	call   800490 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 84 00 00 00    	sub    $0x84,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	53                   	push   %ebx
  800049:	56                   	push   %esi
  80004a:	e8 c0 17 00 00       	call   80180f <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 b6 17 00 00       	call   80180f <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 00 29 80 00 	movl   $0x802900,(%esp)
  800060:	e8 66 05 00 00       	call   8005cb <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 6b 29 80 00 	movl   $0x80296b,(%esp)
  80006c:	e8 5a 05 00 00       	call   8005cb <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	eb 0d                	jmp    800086 <wrong+0x53>
		sys_cputs(buf, n);
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	e8 6f 0e 00 00       	call   800ef2 <sys_cputs>
  800083:	83 c4 10             	add    $0x10,%esp
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 63                	push   $0x63
  80008b:	53                   	push   %ebx
  80008c:	57                   	push   %edi
  80008d:	e8 2d 16 00 00       	call   8016bf <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7f e0                	jg     800079 <wrong+0x46>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 7a 29 80 00       	push   $0x80297a
  8000a1:	e8 25 05 00 00       	call   8005cb <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 3a 0e 00 00       	call   800ef2 <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 f8 15 00 00       	call   8016bf <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 75 29 80 00       	push   $0x802975
  8000d6:	e8 f0 04 00 00       	call   8005cb <cprintf>
	exit();
  8000db:	e8 f6 03 00 00       	call   8004d6 <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <umain>:
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000f4:	6a 00                	push   $0x0
  8000f6:	e8 88 14 00 00       	call   801583 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 7c 14 00 00       	call   801583 <close>
	opencons();
  800107:	e8 32 03 00 00       	call   80043e <opencons>
	opencons();
  80010c:	e8 2d 03 00 00       	call   80043e <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 88 29 80 00       	push   $0x802988
  80011b:	e8 04 1a 00 00       	call   801b24 <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e9 00 00 00    	js     800216 <umain+0x12b>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 77 22 00 00       	call   8023b0 <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e4 00 00 00    	js     800228 <umain+0x13d>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 24 29 80 00       	push   $0x802924
  80014f:	e8 77 04 00 00       	call   8005cb <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 5d 10 00 00       	call   8011b6 <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d6 00 00 00    	js     80023a <umain+0x14f>
	if (r == 0) {
  800164:	85 c0                	test   %eax,%eax
  800166:	75 6f                	jne    8001d7 <umain+0xec>
		dup(rfd, 0);
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	6a 00                	push   $0x0
  80016d:	53                   	push   %ebx
  80016e:	e8 60 14 00 00       	call   8015d3 <dup>
		dup(wfd, 1);
  800173:	83 c4 08             	add    $0x8,%esp
  800176:	6a 01                	push   $0x1
  800178:	56                   	push   %esi
  800179:	e8 55 14 00 00       	call   8015d3 <dup>
		close(rfd);
  80017e:	89 1c 24             	mov    %ebx,(%esp)
  800181:	e8 fd 13 00 00       	call   801583 <close>
		close(wfd);
  800186:	89 34 24             	mov    %esi,(%esp)
  800189:	e8 f5 13 00 00       	call   801583 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018e:	6a 00                	push   $0x0
  800190:	68 ce 29 80 00       	push   $0x8029ce
  800195:	68 92 29 80 00       	push   $0x802992
  80019a:	68 d1 29 80 00       	push   $0x8029d1
  80019f:	e8 be 1f 00 00       	call   802162 <spawnl>
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	83 c4 20             	add    $0x20,%esp
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	0f 88 9b 00 00 00    	js     80024c <umain+0x161>
		close(0);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	6a 00                	push   $0x0
  8001b6:	e8 c8 13 00 00       	call   801583 <close>
		close(1);
  8001bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c2:	e8 bc 13 00 00       	call   801583 <close>
		wait(r);
  8001c7:	89 3c 24             	mov    %edi,(%esp)
  8001ca:	e8 5d 23 00 00       	call   80252c <wait>
		exit();
  8001cf:	e8 02 03 00 00       	call   8004d6 <exit>
  8001d4:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	53                   	push   %ebx
  8001db:	e8 a3 13 00 00       	call   801583 <close>
	close(wfd);
  8001e0:	89 34 24             	mov    %esi,(%esp)
  8001e3:	e8 9b 13 00 00       	call   801583 <close>
	rfd = pfds[0];
  8001e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001ee:	83 c4 08             	add    $0x8,%esp
  8001f1:	6a 00                	push   $0x0
  8001f3:	68 df 29 80 00       	push   $0x8029df
  8001f8:	e8 27 19 00 00       	call   801b24 <open>
  8001fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	85 c0                	test   %eax,%eax
  800205:	78 57                	js     80025e <umain+0x173>
  800207:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  80020c:	bf 00 00 00 00       	mov    $0x0,%edi
  800211:	e9 9a 00 00 00       	jmp    8002b0 <umain+0x1c5>
		panic("open testshell.sh: %e", rfd);
  800216:	50                   	push   %eax
  800217:	68 95 29 80 00       	push   $0x802995
  80021c:	6a 13                	push   $0x13
  80021e:	68 ab 29 80 00       	push   $0x8029ab
  800223:	e8 c8 02 00 00       	call   8004f0 <_panic>
		panic("pipe: %e", wfd);
  800228:	50                   	push   %eax
  800229:	68 bc 29 80 00       	push   $0x8029bc
  80022e:	6a 15                	push   $0x15
  800230:	68 ab 29 80 00       	push   $0x8029ab
  800235:	e8 b6 02 00 00       	call   8004f0 <_panic>
		panic("fork: %e", r);
  80023a:	50                   	push   %eax
  80023b:	68 c5 29 80 00       	push   $0x8029c5
  800240:	6a 1a                	push   $0x1a
  800242:	68 ab 29 80 00       	push   $0x8029ab
  800247:	e8 a4 02 00 00       	call   8004f0 <_panic>
			panic("spawn: %e", r);
  80024c:	50                   	push   %eax
  80024d:	68 d5 29 80 00       	push   $0x8029d5
  800252:	6a 21                	push   $0x21
  800254:	68 ab 29 80 00       	push   $0x8029ab
  800259:	e8 92 02 00 00       	call   8004f0 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025e:	50                   	push   %eax
  80025f:	68 48 29 80 00       	push   $0x802948
  800264:	6a 2c                	push   $0x2c
  800266:	68 ab 29 80 00       	push   $0x8029ab
  80026b:	e8 80 02 00 00       	call   8004f0 <_panic>
			panic("reading testshell.out: %e", n1);
  800270:	53                   	push   %ebx
  800271:	68 ed 29 80 00       	push   $0x8029ed
  800276:	6a 33                	push   $0x33
  800278:	68 ab 29 80 00       	push   $0x8029ab
  80027d:	e8 6e 02 00 00       	call   8004f0 <_panic>
			panic("reading testshell.key: %e", n2);
  800282:	50                   	push   %eax
  800283:	68 07 2a 80 00       	push   $0x802a07
  800288:	6a 35                	push   $0x35
  80028a:	68 ab 29 80 00       	push   $0x8029ab
  80028f:	e8 5c 02 00 00       	call   8004f0 <_panic>
			wrong(rfd, kfd, nloff);
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	57                   	push   %edi
  800298:	ff 75 d4             	pushl  -0x2c(%ebp)
  80029b:	ff 75 d0             	pushl  -0x30(%ebp)
  80029e:	e8 90 fd ff ff       	call   800033 <wrong>
  8002a3:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002a6:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002aa:	0f 44 fe             	cmove  %esi,%edi
  8002ad:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	6a 01                	push   $0x1
  8002b5:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002b8:	50                   	push   %eax
  8002b9:	ff 75 d0             	pushl  -0x30(%ebp)
  8002bc:	e8 fe 13 00 00       	call   8016bf <read>
  8002c1:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c3:	83 c4 0c             	add    $0xc,%esp
  8002c6:	6a 01                	push   $0x1
  8002c8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002cb:	50                   	push   %eax
  8002cc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002cf:	e8 eb 13 00 00       	call   8016bf <read>
		if (n1 < 0)
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	85 db                	test   %ebx,%ebx
  8002d9:	78 95                	js     800270 <umain+0x185>
		if (n2 < 0)
  8002db:	85 c0                	test   %eax,%eax
  8002dd:	78 a3                	js     800282 <umain+0x197>
		if (n1 == 0 && n2 == 0)
  8002df:	89 da                	mov    %ebx,%edx
  8002e1:	09 c2                	or     %eax,%edx
  8002e3:	74 15                	je     8002fa <umain+0x20f>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002e5:	83 fb 01             	cmp    $0x1,%ebx
  8002e8:	75 aa                	jne    800294 <umain+0x1a9>
  8002ea:	83 f8 01             	cmp    $0x1,%eax
  8002ed:	75 a5                	jne    800294 <umain+0x1a9>
  8002ef:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002f3:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002f6:	75 9c                	jne    800294 <umain+0x1a9>
  8002f8:	eb ac                	jmp    8002a6 <umain+0x1bb>
	cprintf("shell ran correctly\n");
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 21 2a 80 00       	push   $0x802a21
  800302:	e8 c4 02 00 00       	call   8005cb <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800307:	cc                   	int3   
}
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030e:	5b                   	pop    %ebx
  80030f:	5e                   	pop    %esi
  800310:	5f                   	pop    %edi
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	5d                   	pop    %ebp
  80031c:	c3                   	ret    

0080031d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800323:	68 36 2a 80 00       	push   $0x802a36
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	e8 85 08 00 00       	call   800bb5 <strcpy>
	return 0;
}
  800330:	b8 00 00 00 00       	mov    $0x0,%eax
  800335:	c9                   	leave  
  800336:	c3                   	ret    

00800337 <devcons_write>:
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	57                   	push   %edi
  80033b:	56                   	push   %esi
  80033c:	53                   	push   %ebx
  80033d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800343:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800348:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80034e:	eb 2f                	jmp    80037f <devcons_write+0x48>
		m = n - tot;
  800350:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800353:	29 f3                	sub    %esi,%ebx
  800355:	83 fb 7f             	cmp    $0x7f,%ebx
  800358:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80035d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	53                   	push   %ebx
  800364:	89 f0                	mov    %esi,%eax
  800366:	03 45 0c             	add    0xc(%ebp),%eax
  800369:	50                   	push   %eax
  80036a:	57                   	push   %edi
  80036b:	e8 d3 09 00 00       	call   800d43 <memmove>
		sys_cputs(buf, m);
  800370:	83 c4 08             	add    $0x8,%esp
  800373:	53                   	push   %ebx
  800374:	57                   	push   %edi
  800375:	e8 78 0b 00 00       	call   800ef2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80037a:	01 de                	add    %ebx,%esi
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	3b 75 10             	cmp    0x10(%ebp),%esi
  800382:	72 cc                	jb     800350 <devcons_write+0x19>
}
  800384:	89 f0                	mov    %esi,%eax
  800386:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800389:	5b                   	pop    %ebx
  80038a:	5e                   	pop    %esi
  80038b:	5f                   	pop    %edi
  80038c:	5d                   	pop    %ebp
  80038d:	c3                   	ret    

0080038e <devcons_read>:
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800399:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80039d:	75 07                	jne    8003a6 <devcons_read+0x18>
}
  80039f:	c9                   	leave  
  8003a0:	c3                   	ret    
		sys_yield();
  8003a1:	e8 e9 0b 00 00       	call   800f8f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8003a6:	e8 65 0b 00 00       	call   800f10 <sys_cgetc>
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	74 f2                	je     8003a1 <devcons_read+0x13>
	if (c < 0)
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	78 ec                	js     80039f <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8003b3:	83 f8 04             	cmp    $0x4,%eax
  8003b6:	74 0c                	je     8003c4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8003b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bb:	88 02                	mov    %al,(%edx)
	return 1;
  8003bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8003c2:	eb db                	jmp    80039f <devcons_read+0x11>
		return 0;
  8003c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c9:	eb d4                	jmp    80039f <devcons_read+0x11>

008003cb <cputchar>:
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003d7:	6a 01                	push   $0x1
  8003d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003dc:	50                   	push   %eax
  8003dd:	e8 10 0b 00 00       	call   800ef2 <sys_cputs>
}
  8003e2:	83 c4 10             	add    $0x10,%esp
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <getchar>:
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8003ed:	6a 01                	push   $0x1
  8003ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003f2:	50                   	push   %eax
  8003f3:	6a 00                	push   $0x0
  8003f5:	e8 c5 12 00 00       	call   8016bf <read>
	if (r < 0)
  8003fa:	83 c4 10             	add    $0x10,%esp
  8003fd:	85 c0                	test   %eax,%eax
  8003ff:	78 08                	js     800409 <getchar+0x22>
	if (r < 1)
  800401:	85 c0                	test   %eax,%eax
  800403:	7e 06                	jle    80040b <getchar+0x24>
	return c;
  800405:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800409:	c9                   	leave  
  80040a:	c3                   	ret    
		return -E_EOF;
  80040b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800410:	eb f7                	jmp    800409 <getchar+0x22>

00800412 <iscons>:
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800418:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80041b:	50                   	push   %eax
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 2a 10 00 00       	call   80144e <fd_lookup>
  800424:	83 c4 10             	add    $0x10,%esp
  800427:	85 c0                	test   %eax,%eax
  800429:	78 11                	js     80043c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80042b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80042e:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800434:	39 10                	cmp    %edx,(%eax)
  800436:	0f 94 c0             	sete   %al
  800439:	0f b6 c0             	movzbl %al,%eax
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <opencons>:
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800444:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800447:	50                   	push   %eax
  800448:	e8 b2 0f 00 00       	call   8013ff <fd_alloc>
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	85 c0                	test   %eax,%eax
  800452:	78 3a                	js     80048e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800454:	83 ec 04             	sub    $0x4,%esp
  800457:	68 07 04 00 00       	push   $0x407
  80045c:	ff 75 f4             	pushl  -0xc(%ebp)
  80045f:	6a 00                	push   $0x0
  800461:	e8 48 0b 00 00       	call   800fae <sys_page_alloc>
  800466:	83 c4 10             	add    $0x10,%esp
  800469:	85 c0                	test   %eax,%eax
  80046b:	78 21                	js     80048e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80046d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800470:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800476:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800482:	83 ec 0c             	sub    $0xc,%esp
  800485:	50                   	push   %eax
  800486:	e8 4d 0f 00 00       	call   8013d8 <fd2num>
  80048b:	83 c4 10             	add    $0x10,%esp
}
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	56                   	push   %esi
  800494:	53                   	push   %ebx
  800495:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800498:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80049b:	e8 d0 0a 00 00       	call   800f70 <sys_getenvid>
  8004a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004a5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004ad:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004b2:	85 db                	test   %ebx,%ebx
  8004b4:	7e 07                	jle    8004bd <libmain+0x2d>
		binaryname = argv[0];
  8004b6:	8b 06                	mov    (%esi),%eax
  8004b8:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	56                   	push   %esi
  8004c1:	53                   	push   %ebx
  8004c2:	e8 24 fc ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8004c7:	e8 0a 00 00 00       	call   8004d6 <exit>
}
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004d2:	5b                   	pop    %ebx
  8004d3:	5e                   	pop    %esi
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    

008004d6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8004dc:	e8 cd 10 00 00       	call   8015ae <close_all>
	sys_env_destroy(0);
  8004e1:	83 ec 0c             	sub    $0xc,%esp
  8004e4:	6a 00                	push   $0x0
  8004e6:	e8 44 0a 00 00       	call   800f2f <sys_env_destroy>
}
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	56                   	push   %esi
  8004f4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8004f5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004f8:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8004fe:	e8 6d 0a 00 00       	call   800f70 <sys_getenvid>
  800503:	83 ec 0c             	sub    $0xc,%esp
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	56                   	push   %esi
  80050d:	50                   	push   %eax
  80050e:	68 4c 2a 80 00       	push   $0x802a4c
  800513:	e8 b3 00 00 00       	call   8005cb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800518:	83 c4 18             	add    $0x18,%esp
  80051b:	53                   	push   %ebx
  80051c:	ff 75 10             	pushl  0x10(%ebp)
  80051f:	e8 56 00 00 00       	call   80057a <vcprintf>
	cprintf("\n");
  800524:	c7 04 24 78 29 80 00 	movl   $0x802978,(%esp)
  80052b:	e8 9b 00 00 00       	call   8005cb <cprintf>
  800530:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800533:	cc                   	int3   
  800534:	eb fd                	jmp    800533 <_panic+0x43>

00800536 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	53                   	push   %ebx
  80053a:	83 ec 04             	sub    $0x4,%esp
  80053d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800540:	8b 13                	mov    (%ebx),%edx
  800542:	8d 42 01             	lea    0x1(%edx),%eax
  800545:	89 03                	mov    %eax,(%ebx)
  800547:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80054a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80054e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800553:	74 09                	je     80055e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800555:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	68 ff 00 00 00       	push   $0xff
  800566:	8d 43 08             	lea    0x8(%ebx),%eax
  800569:	50                   	push   %eax
  80056a:	e8 83 09 00 00       	call   800ef2 <sys_cputs>
		b->idx = 0;
  80056f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	eb db                	jmp    800555 <putch+0x1f>

0080057a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80057a:	55                   	push   %ebp
  80057b:	89 e5                	mov    %esp,%ebp
  80057d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800583:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058a:	00 00 00 
	b.cnt = 0;
  80058d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800594:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800597:	ff 75 0c             	pushl  0xc(%ebp)
  80059a:	ff 75 08             	pushl  0x8(%ebp)
  80059d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a3:	50                   	push   %eax
  8005a4:	68 36 05 80 00       	push   $0x800536
  8005a9:	e8 1a 01 00 00       	call   8006c8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005ae:	83 c4 08             	add    $0x8,%esp
  8005b1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005bd:	50                   	push   %eax
  8005be:	e8 2f 09 00 00       	call   800ef2 <sys_cputs>

	return b.cnt;
}
  8005c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    

008005cb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005cb:	55                   	push   %ebp
  8005cc:	89 e5                	mov    %esp,%ebp
  8005ce:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005d4:	50                   	push   %eax
  8005d5:	ff 75 08             	pushl  0x8(%ebp)
  8005d8:	e8 9d ff ff ff       	call   80057a <vcprintf>
	va_end(ap);

	return cnt;
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	57                   	push   %edi
  8005e3:	56                   	push   %esi
  8005e4:	53                   	push   %ebx
  8005e5:	83 ec 1c             	sub    $0x1c,%esp
  8005e8:	89 c7                	mov    %eax,%edi
  8005ea:	89 d6                	mov    %edx,%esi
  8005ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800600:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800603:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800606:	39 d3                	cmp    %edx,%ebx
  800608:	72 05                	jb     80060f <printnum+0x30>
  80060a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80060d:	77 7a                	ja     800689 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060f:	83 ec 0c             	sub    $0xc,%esp
  800612:	ff 75 18             	pushl  0x18(%ebp)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80061b:	53                   	push   %ebx
  80061c:	ff 75 10             	pushl  0x10(%ebp)
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 e4             	pushl  -0x1c(%ebp)
  800625:	ff 75 e0             	pushl  -0x20(%ebp)
  800628:	ff 75 dc             	pushl  -0x24(%ebp)
  80062b:	ff 75 d8             	pushl  -0x28(%ebp)
  80062e:	e8 8d 20 00 00       	call   8026c0 <__udivdi3>
  800633:	83 c4 18             	add    $0x18,%esp
  800636:	52                   	push   %edx
  800637:	50                   	push   %eax
  800638:	89 f2                	mov    %esi,%edx
  80063a:	89 f8                	mov    %edi,%eax
  80063c:	e8 9e ff ff ff       	call   8005df <printnum>
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	eb 13                	jmp    800659 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	56                   	push   %esi
  80064a:	ff 75 18             	pushl  0x18(%ebp)
  80064d:	ff d7                	call   *%edi
  80064f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800652:	83 eb 01             	sub    $0x1,%ebx
  800655:	85 db                	test   %ebx,%ebx
  800657:	7f ed                	jg     800646 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	56                   	push   %esi
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	ff 75 e4             	pushl  -0x1c(%ebp)
  800663:	ff 75 e0             	pushl  -0x20(%ebp)
  800666:	ff 75 dc             	pushl  -0x24(%ebp)
  800669:	ff 75 d8             	pushl  -0x28(%ebp)
  80066c:	e8 6f 21 00 00       	call   8027e0 <__umoddi3>
  800671:	83 c4 14             	add    $0x14,%esp
  800674:	0f be 80 6f 2a 80 00 	movsbl 0x802a6f(%eax),%eax
  80067b:	50                   	push   %eax
  80067c:	ff d7                	call   *%edi
}
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800684:	5b                   	pop    %ebx
  800685:	5e                   	pop    %esi
  800686:	5f                   	pop    %edi
  800687:	5d                   	pop    %ebp
  800688:	c3                   	ret    
  800689:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80068c:	eb c4                	jmp    800652 <printnum+0x73>

0080068e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800694:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	3b 50 04             	cmp    0x4(%eax),%edx
  80069d:	73 0a                	jae    8006a9 <sprintputch+0x1b>
		*b->buf++ = ch;
  80069f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006a2:	89 08                	mov    %ecx,(%eax)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	88 02                	mov    %al,(%edx)
}
  8006a9:	5d                   	pop    %ebp
  8006aa:	c3                   	ret    

008006ab <printfmt>:
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006b1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 10             	pushl  0x10(%ebp)
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 05 00 00 00       	call   8006c8 <vprintfmt>
}
  8006c3:	83 c4 10             	add    $0x10,%esp
  8006c6:	c9                   	leave  
  8006c7:	c3                   	ret    

008006c8 <vprintfmt>:
{
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
  8006cb:	57                   	push   %edi
  8006cc:	56                   	push   %esi
  8006cd:	53                   	push   %ebx
  8006ce:	83 ec 2c             	sub    $0x2c,%esp
  8006d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8006da:	e9 8c 03 00 00       	jmp    800a6b <vprintfmt+0x3a3>
		padc = ' ';
  8006df:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8006e3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8006ea:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8006f1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006f8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006fd:	8d 47 01             	lea    0x1(%edi),%eax
  800700:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800703:	0f b6 17             	movzbl (%edi),%edx
  800706:	8d 42 dd             	lea    -0x23(%edx),%eax
  800709:	3c 55                	cmp    $0x55,%al
  80070b:	0f 87 dd 03 00 00    	ja     800aee <vprintfmt+0x426>
  800711:	0f b6 c0             	movzbl %al,%eax
  800714:	ff 24 85 c0 2b 80 00 	jmp    *0x802bc0(,%eax,4)
  80071b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80071e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800722:	eb d9                	jmp    8006fd <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800724:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800727:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80072b:	eb d0                	jmp    8006fd <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80072d:	0f b6 d2             	movzbl %dl,%edx
  800730:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800733:	b8 00 00 00 00       	mov    $0x0,%eax
  800738:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80073b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80073e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800742:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800745:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800748:	83 f9 09             	cmp    $0x9,%ecx
  80074b:	77 55                	ja     8007a2 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80074d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800750:	eb e9                	jmp    80073b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8d 40 04             	lea    0x4(%eax),%eax
  800760:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800763:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800766:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80076a:	79 91                	jns    8006fd <vprintfmt+0x35>
				width = precision, precision = -1;
  80076c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80076f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800772:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800779:	eb 82                	jmp    8006fd <vprintfmt+0x35>
  80077b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80077e:	85 c0                	test   %eax,%eax
  800780:	ba 00 00 00 00       	mov    $0x0,%edx
  800785:	0f 49 d0             	cmovns %eax,%edx
  800788:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80078b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80078e:	e9 6a ff ff ff       	jmp    8006fd <vprintfmt+0x35>
  800793:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800796:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80079d:	e9 5b ff ff ff       	jmp    8006fd <vprintfmt+0x35>
  8007a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a8:	eb bc                	jmp    800766 <vprintfmt+0x9e>
			lflag++;
  8007aa:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007b0:	e9 48 ff ff ff       	jmp    8006fd <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8d 78 04             	lea    0x4(%eax),%edi
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	53                   	push   %ebx
  8007bf:	ff 30                	pushl  (%eax)
  8007c1:	ff d6                	call   *%esi
			break;
  8007c3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007c6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007c9:	e9 9a 02 00 00       	jmp    800a68 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8d 78 04             	lea    0x4(%eax),%edi
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	99                   	cltd   
  8007d7:	31 d0                	xor    %edx,%eax
  8007d9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007db:	83 f8 0f             	cmp    $0xf,%eax
  8007de:	7f 23                	jg     800803 <vprintfmt+0x13b>
  8007e0:	8b 14 85 20 2d 80 00 	mov    0x802d20(,%eax,4),%edx
  8007e7:	85 d2                	test   %edx,%edx
  8007e9:	74 18                	je     800803 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8007eb:	52                   	push   %edx
  8007ec:	68 09 2f 80 00       	push   $0x802f09
  8007f1:	53                   	push   %ebx
  8007f2:	56                   	push   %esi
  8007f3:	e8 b3 fe ff ff       	call   8006ab <printfmt>
  8007f8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8007fb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8007fe:	e9 65 02 00 00       	jmp    800a68 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800803:	50                   	push   %eax
  800804:	68 87 2a 80 00       	push   $0x802a87
  800809:	53                   	push   %ebx
  80080a:	56                   	push   %esi
  80080b:	e8 9b fe ff ff       	call   8006ab <printfmt>
  800810:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800813:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800816:	e9 4d 02 00 00       	jmp    800a68 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800829:	85 ff                	test   %edi,%edi
  80082b:	b8 80 2a 80 00       	mov    $0x802a80,%eax
  800830:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800833:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800837:	0f 8e bd 00 00 00    	jle    8008fa <vprintfmt+0x232>
  80083d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800841:	75 0e                	jne    800851 <vprintfmt+0x189>
  800843:	89 75 08             	mov    %esi,0x8(%ebp)
  800846:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800849:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80084c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80084f:	eb 6d                	jmp    8008be <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800851:	83 ec 08             	sub    $0x8,%esp
  800854:	ff 75 d0             	pushl  -0x30(%ebp)
  800857:	57                   	push   %edi
  800858:	e8 39 03 00 00       	call   800b96 <strnlen>
  80085d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800860:	29 c1                	sub    %eax,%ecx
  800862:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800865:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800868:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80086c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80086f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800872:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800874:	eb 0f                	jmp    800885 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	53                   	push   %ebx
  80087a:	ff 75 e0             	pushl  -0x20(%ebp)
  80087d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80087f:	83 ef 01             	sub    $0x1,%edi
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	85 ff                	test   %edi,%edi
  800887:	7f ed                	jg     800876 <vprintfmt+0x1ae>
  800889:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80088c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80088f:	85 c9                	test   %ecx,%ecx
  800891:	b8 00 00 00 00       	mov    $0x0,%eax
  800896:	0f 49 c1             	cmovns %ecx,%eax
  800899:	29 c1                	sub    %eax,%ecx
  80089b:	89 75 08             	mov    %esi,0x8(%ebp)
  80089e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8008a1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8008a4:	89 cb                	mov    %ecx,%ebx
  8008a6:	eb 16                	jmp    8008be <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8008a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008ac:	75 31                	jne    8008df <vprintfmt+0x217>
					putch(ch, putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	50                   	push   %eax
  8008b5:	ff 55 08             	call   *0x8(%ebp)
  8008b8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008bb:	83 eb 01             	sub    $0x1,%ebx
  8008be:	83 c7 01             	add    $0x1,%edi
  8008c1:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8008c5:	0f be c2             	movsbl %dl,%eax
  8008c8:	85 c0                	test   %eax,%eax
  8008ca:	74 59                	je     800925 <vprintfmt+0x25d>
  8008cc:	85 f6                	test   %esi,%esi
  8008ce:	78 d8                	js     8008a8 <vprintfmt+0x1e0>
  8008d0:	83 ee 01             	sub    $0x1,%esi
  8008d3:	79 d3                	jns    8008a8 <vprintfmt+0x1e0>
  8008d5:	89 df                	mov    %ebx,%edi
  8008d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008dd:	eb 37                	jmp    800916 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8008df:	0f be d2             	movsbl %dl,%edx
  8008e2:	83 ea 20             	sub    $0x20,%edx
  8008e5:	83 fa 5e             	cmp    $0x5e,%edx
  8008e8:	76 c4                	jbe    8008ae <vprintfmt+0x1e6>
					putch('?', putdat);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	6a 3f                	push   $0x3f
  8008f2:	ff 55 08             	call   *0x8(%ebp)
  8008f5:	83 c4 10             	add    $0x10,%esp
  8008f8:	eb c1                	jmp    8008bb <vprintfmt+0x1f3>
  8008fa:	89 75 08             	mov    %esi,0x8(%ebp)
  8008fd:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800900:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800903:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800906:	eb b6                	jmp    8008be <vprintfmt+0x1f6>
				putch(' ', putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	53                   	push   %ebx
  80090c:	6a 20                	push   $0x20
  80090e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800910:	83 ef 01             	sub    $0x1,%edi
  800913:	83 c4 10             	add    $0x10,%esp
  800916:	85 ff                	test   %edi,%edi
  800918:	7f ee                	jg     800908 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80091a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80091d:	89 45 14             	mov    %eax,0x14(%ebp)
  800920:	e9 43 01 00 00       	jmp    800a68 <vprintfmt+0x3a0>
  800925:	89 df                	mov    %ebx,%edi
  800927:	8b 75 08             	mov    0x8(%ebp),%esi
  80092a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80092d:	eb e7                	jmp    800916 <vprintfmt+0x24e>
	if (lflag >= 2)
  80092f:	83 f9 01             	cmp    $0x1,%ecx
  800932:	7e 3f                	jle    800973 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8b 50 04             	mov    0x4(%eax),%edx
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	8d 40 08             	lea    0x8(%eax),%eax
  800948:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80094b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80094f:	79 5c                	jns    8009ad <vprintfmt+0x2e5>
				putch('-', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	53                   	push   %ebx
  800955:	6a 2d                	push   $0x2d
  800957:	ff d6                	call   *%esi
				num = -(long long) num;
  800959:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80095c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80095f:	f7 da                	neg    %edx
  800961:	83 d1 00             	adc    $0x0,%ecx
  800964:	f7 d9                	neg    %ecx
  800966:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800969:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096e:	e9 db 00 00 00       	jmp    800a4e <vprintfmt+0x386>
	else if (lflag)
  800973:	85 c9                	test   %ecx,%ecx
  800975:	75 1b                	jne    800992 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80097f:	89 c1                	mov    %eax,%ecx
  800981:	c1 f9 1f             	sar    $0x1f,%ecx
  800984:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800987:	8b 45 14             	mov    0x14(%ebp),%eax
  80098a:	8d 40 04             	lea    0x4(%eax),%eax
  80098d:	89 45 14             	mov    %eax,0x14(%ebp)
  800990:	eb b9                	jmp    80094b <vprintfmt+0x283>
		return va_arg(*ap, long);
  800992:	8b 45 14             	mov    0x14(%ebp),%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099a:	89 c1                	mov    %eax,%ecx
  80099c:	c1 f9 1f             	sar    $0x1f,%ecx
  80099f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a5:	8d 40 04             	lea    0x4(%eax),%eax
  8009a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ab:	eb 9e                	jmp    80094b <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8009ad:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8009b0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8009b3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b8:	e9 91 00 00 00       	jmp    800a4e <vprintfmt+0x386>
	if (lflag >= 2)
  8009bd:	83 f9 01             	cmp    $0x1,%ecx
  8009c0:	7e 15                	jle    8009d7 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8009c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c5:	8b 10                	mov    (%eax),%edx
  8009c7:	8b 48 04             	mov    0x4(%eax),%ecx
  8009ca:	8d 40 08             	lea    0x8(%eax),%eax
  8009cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009d5:	eb 77                	jmp    800a4e <vprintfmt+0x386>
	else if (lflag)
  8009d7:	85 c9                	test   %ecx,%ecx
  8009d9:	75 17                	jne    8009f2 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8009db:	8b 45 14             	mov    0x14(%ebp),%eax
  8009de:	8b 10                	mov    (%eax),%edx
  8009e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009e5:	8d 40 04             	lea    0x4(%eax),%eax
  8009e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009f0:	eb 5c                	jmp    800a4e <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	8b 10                	mov    (%eax),%edx
  8009f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009fc:	8d 40 04             	lea    0x4(%eax),%eax
  8009ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a02:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a07:	eb 45                	jmp    800a4e <vprintfmt+0x386>
			putch('X', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	53                   	push   %ebx
  800a0d:	6a 58                	push   $0x58
  800a0f:	ff d6                	call   *%esi
			putch('X', putdat);
  800a11:	83 c4 08             	add    $0x8,%esp
  800a14:	53                   	push   %ebx
  800a15:	6a 58                	push   $0x58
  800a17:	ff d6                	call   *%esi
			putch('X', putdat);
  800a19:	83 c4 08             	add    $0x8,%esp
  800a1c:	53                   	push   %ebx
  800a1d:	6a 58                	push   $0x58
  800a1f:	ff d6                	call   *%esi
			break;
  800a21:	83 c4 10             	add    $0x10,%esp
  800a24:	eb 42                	jmp    800a68 <vprintfmt+0x3a0>
			putch('0', putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	53                   	push   %ebx
  800a2a:	6a 30                	push   $0x30
  800a2c:	ff d6                	call   *%esi
			putch('x', putdat);
  800a2e:	83 c4 08             	add    $0x8,%esp
  800a31:	53                   	push   %ebx
  800a32:	6a 78                	push   $0x78
  800a34:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	8b 10                	mov    (%eax),%edx
  800a3b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a40:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a43:	8d 40 04             	lea    0x4(%eax),%eax
  800a46:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a49:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a4e:	83 ec 0c             	sub    $0xc,%esp
  800a51:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800a55:	57                   	push   %edi
  800a56:	ff 75 e0             	pushl  -0x20(%ebp)
  800a59:	50                   	push   %eax
  800a5a:	51                   	push   %ecx
  800a5b:	52                   	push   %edx
  800a5c:	89 da                	mov    %ebx,%edx
  800a5e:	89 f0                	mov    %esi,%eax
  800a60:	e8 7a fb ff ff       	call   8005df <printnum>
			break;
  800a65:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800a68:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a6b:	83 c7 01             	add    $0x1,%edi
  800a6e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a72:	83 f8 25             	cmp    $0x25,%eax
  800a75:	0f 84 64 fc ff ff    	je     8006df <vprintfmt+0x17>
			if (ch == '\0')
  800a7b:	85 c0                	test   %eax,%eax
  800a7d:	0f 84 8b 00 00 00    	je     800b0e <vprintfmt+0x446>
			putch(ch, putdat);
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	53                   	push   %ebx
  800a87:	50                   	push   %eax
  800a88:	ff d6                	call   *%esi
  800a8a:	83 c4 10             	add    $0x10,%esp
  800a8d:	eb dc                	jmp    800a6b <vprintfmt+0x3a3>
	if (lflag >= 2)
  800a8f:	83 f9 01             	cmp    $0x1,%ecx
  800a92:	7e 15                	jle    800aa9 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  800a94:	8b 45 14             	mov    0x14(%ebp),%eax
  800a97:	8b 10                	mov    (%eax),%edx
  800a99:	8b 48 04             	mov    0x4(%eax),%ecx
  800a9c:	8d 40 08             	lea    0x8(%eax),%eax
  800a9f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aa2:	b8 10 00 00 00       	mov    $0x10,%eax
  800aa7:	eb a5                	jmp    800a4e <vprintfmt+0x386>
	else if (lflag)
  800aa9:	85 c9                	test   %ecx,%ecx
  800aab:	75 17                	jne    800ac4 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800aad:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab0:	8b 10                	mov    (%eax),%edx
  800ab2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab7:	8d 40 04             	lea    0x4(%eax),%eax
  800aba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800abd:	b8 10 00 00 00       	mov    $0x10,%eax
  800ac2:	eb 8a                	jmp    800a4e <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac7:	8b 10                	mov    (%eax),%edx
  800ac9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ace:	8d 40 04             	lea    0x4(%eax),%eax
  800ad1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad4:	b8 10 00 00 00       	mov    $0x10,%eax
  800ad9:	e9 70 ff ff ff       	jmp    800a4e <vprintfmt+0x386>
			putch(ch, putdat);
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	53                   	push   %ebx
  800ae2:	6a 25                	push   $0x25
  800ae4:	ff d6                	call   *%esi
			break;
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	e9 7a ff ff ff       	jmp    800a68 <vprintfmt+0x3a0>
			putch('%', putdat);
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	53                   	push   %ebx
  800af2:	6a 25                	push   $0x25
  800af4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	89 f8                	mov    %edi,%eax
  800afb:	eb 03                	jmp    800b00 <vprintfmt+0x438>
  800afd:	83 e8 01             	sub    $0x1,%eax
  800b00:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b04:	75 f7                	jne    800afd <vprintfmt+0x435>
  800b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b09:	e9 5a ff ff ff       	jmp    800a68 <vprintfmt+0x3a0>
}
  800b0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	83 ec 18             	sub    $0x18,%esp
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b25:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b29:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b33:	85 c0                	test   %eax,%eax
  800b35:	74 26                	je     800b5d <vsnprintf+0x47>
  800b37:	85 d2                	test   %edx,%edx
  800b39:	7e 22                	jle    800b5d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b3b:	ff 75 14             	pushl  0x14(%ebp)
  800b3e:	ff 75 10             	pushl  0x10(%ebp)
  800b41:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b44:	50                   	push   %eax
  800b45:	68 8e 06 80 00       	push   $0x80068e
  800b4a:	e8 79 fb ff ff       	call   8006c8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b52:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b58:	83 c4 10             	add    $0x10,%esp
}
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    
		return -E_INVAL;
  800b5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b62:	eb f7                	jmp    800b5b <vsnprintf+0x45>

00800b64 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b6a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 10             	pushl  0x10(%ebp)
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	ff 75 08             	pushl  0x8(%ebp)
  800b77:	e8 9a ff ff ff       	call   800b16 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b84:	b8 00 00 00 00       	mov    $0x0,%eax
  800b89:	eb 03                	jmp    800b8e <strlen+0x10>
		n++;
  800b8b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800b8e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b92:	75 f7                	jne    800b8b <strlen+0xd>
	return n;
}
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba4:	eb 03                	jmp    800ba9 <strnlen+0x13>
		n++;
  800ba6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba9:	39 d0                	cmp    %edx,%eax
  800bab:	74 06                	je     800bb3 <strnlen+0x1d>
  800bad:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800bb1:	75 f3                	jne    800ba6 <strnlen+0x10>
	return n;
}
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	53                   	push   %ebx
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bbf:	89 c2                	mov    %eax,%edx
  800bc1:	83 c1 01             	add    $0x1,%ecx
  800bc4:	83 c2 01             	add    $0x1,%edx
  800bc7:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800bcb:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bce:	84 db                	test   %bl,%bl
  800bd0:	75 ef                	jne    800bc1 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800bd2:	5b                   	pop    %ebx
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	53                   	push   %ebx
  800bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bdc:	53                   	push   %ebx
  800bdd:	e8 9c ff ff ff       	call   800b7e <strlen>
  800be2:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	01 d8                	add    %ebx,%eax
  800bea:	50                   	push   %eax
  800beb:	e8 c5 ff ff ff       	call   800bb5 <strcpy>
	return dst;
}
  800bf0:	89 d8                	mov    %ebx,%eax
  800bf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bf5:	c9                   	leave  
  800bf6:	c3                   	ret    

00800bf7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	56                   	push   %esi
  800bfb:	53                   	push   %ebx
  800bfc:	8b 75 08             	mov    0x8(%ebp),%esi
  800bff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c02:	89 f3                	mov    %esi,%ebx
  800c04:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c07:	89 f2                	mov    %esi,%edx
  800c09:	eb 0f                	jmp    800c1a <strncpy+0x23>
		*dst++ = *src;
  800c0b:	83 c2 01             	add    $0x1,%edx
  800c0e:	0f b6 01             	movzbl (%ecx),%eax
  800c11:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c14:	80 39 01             	cmpb   $0x1,(%ecx)
  800c17:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800c1a:	39 da                	cmp    %ebx,%edx
  800c1c:	75 ed                	jne    800c0b <strncpy+0x14>
	}
	return ret;
}
  800c1e:	89 f0                	mov    %esi,%eax
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	8b 75 08             	mov    0x8(%ebp),%esi
  800c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c32:	89 f0                	mov    %esi,%eax
  800c34:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c38:	85 c9                	test   %ecx,%ecx
  800c3a:	75 0b                	jne    800c47 <strlcpy+0x23>
  800c3c:	eb 17                	jmp    800c55 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c3e:	83 c2 01             	add    $0x1,%edx
  800c41:	83 c0 01             	add    $0x1,%eax
  800c44:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800c47:	39 d8                	cmp    %ebx,%eax
  800c49:	74 07                	je     800c52 <strlcpy+0x2e>
  800c4b:	0f b6 0a             	movzbl (%edx),%ecx
  800c4e:	84 c9                	test   %cl,%cl
  800c50:	75 ec                	jne    800c3e <strlcpy+0x1a>
		*dst = '\0';
  800c52:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c55:	29 f0                	sub    %esi,%eax
}
  800c57:	5b                   	pop    %ebx
  800c58:	5e                   	pop    %esi
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c64:	eb 06                	jmp    800c6c <strcmp+0x11>
		p++, q++;
  800c66:	83 c1 01             	add    $0x1,%ecx
  800c69:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800c6c:	0f b6 01             	movzbl (%ecx),%eax
  800c6f:	84 c0                	test   %al,%al
  800c71:	74 04                	je     800c77 <strcmp+0x1c>
  800c73:	3a 02                	cmp    (%edx),%al
  800c75:	74 ef                	je     800c66 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c77:	0f b6 c0             	movzbl %al,%eax
  800c7a:	0f b6 12             	movzbl (%edx),%edx
  800c7d:	29 d0                	sub    %edx,%eax
}
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	53                   	push   %ebx
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	89 c3                	mov    %eax,%ebx
  800c8d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c90:	eb 06                	jmp    800c98 <strncmp+0x17>
		n--, p++, q++;
  800c92:	83 c0 01             	add    $0x1,%eax
  800c95:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c98:	39 d8                	cmp    %ebx,%eax
  800c9a:	74 16                	je     800cb2 <strncmp+0x31>
  800c9c:	0f b6 08             	movzbl (%eax),%ecx
  800c9f:	84 c9                	test   %cl,%cl
  800ca1:	74 04                	je     800ca7 <strncmp+0x26>
  800ca3:	3a 0a                	cmp    (%edx),%cl
  800ca5:	74 eb                	je     800c92 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca7:	0f b6 00             	movzbl (%eax),%eax
  800caa:	0f b6 12             	movzbl (%edx),%edx
  800cad:	29 d0                	sub    %edx,%eax
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    
		return 0;
  800cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb7:	eb f6                	jmp    800caf <strncmp+0x2e>

00800cb9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc3:	0f b6 10             	movzbl (%eax),%edx
  800cc6:	84 d2                	test   %dl,%dl
  800cc8:	74 09                	je     800cd3 <strchr+0x1a>
		if (*s == c)
  800cca:	38 ca                	cmp    %cl,%dl
  800ccc:	74 0a                	je     800cd8 <strchr+0x1f>
	for (; *s; s++)
  800cce:	83 c0 01             	add    $0x1,%eax
  800cd1:	eb f0                	jmp    800cc3 <strchr+0xa>
			return (char *) s;
	return 0;
  800cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    

00800cda <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ce4:	eb 03                	jmp    800ce9 <strfind+0xf>
  800ce6:	83 c0 01             	add    $0x1,%eax
  800ce9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800cec:	38 ca                	cmp    %cl,%dl
  800cee:	74 04                	je     800cf4 <strfind+0x1a>
  800cf0:	84 d2                	test   %dl,%dl
  800cf2:	75 f2                	jne    800ce6 <strfind+0xc>
			break;
	return (char *) s;
}
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
  800cfc:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d02:	85 c9                	test   %ecx,%ecx
  800d04:	74 13                	je     800d19 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d06:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d0c:	75 05                	jne    800d13 <memset+0x1d>
  800d0e:	f6 c1 03             	test   $0x3,%cl
  800d11:	74 0d                	je     800d20 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	fc                   	cld    
  800d17:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d19:	89 f8                	mov    %edi,%eax
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5f                   	pop    %edi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    
		c &= 0xFF;
  800d20:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d24:	89 d3                	mov    %edx,%ebx
  800d26:	c1 e3 08             	shl    $0x8,%ebx
  800d29:	89 d0                	mov    %edx,%eax
  800d2b:	c1 e0 18             	shl    $0x18,%eax
  800d2e:	89 d6                	mov    %edx,%esi
  800d30:	c1 e6 10             	shl    $0x10,%esi
  800d33:	09 f0                	or     %esi,%eax
  800d35:	09 c2                	or     %eax,%edx
  800d37:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800d39:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d3c:	89 d0                	mov    %edx,%eax
  800d3e:	fc                   	cld    
  800d3f:	f3 ab                	rep stos %eax,%es:(%edi)
  800d41:	eb d6                	jmp    800d19 <memset+0x23>

00800d43 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d51:	39 c6                	cmp    %eax,%esi
  800d53:	73 35                	jae    800d8a <memmove+0x47>
  800d55:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d58:	39 c2                	cmp    %eax,%edx
  800d5a:	76 2e                	jbe    800d8a <memmove+0x47>
		s += n;
		d += n;
  800d5c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d5f:	89 d6                	mov    %edx,%esi
  800d61:	09 fe                	or     %edi,%esi
  800d63:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d69:	74 0c                	je     800d77 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d6b:	83 ef 01             	sub    $0x1,%edi
  800d6e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d71:	fd                   	std    
  800d72:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d74:	fc                   	cld    
  800d75:	eb 21                	jmp    800d98 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d77:	f6 c1 03             	test   $0x3,%cl
  800d7a:	75 ef                	jne    800d6b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d7c:	83 ef 04             	sub    $0x4,%edi
  800d7f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d82:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d85:	fd                   	std    
  800d86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d88:	eb ea                	jmp    800d74 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d8a:	89 f2                	mov    %esi,%edx
  800d8c:	09 c2                	or     %eax,%edx
  800d8e:	f6 c2 03             	test   $0x3,%dl
  800d91:	74 09                	je     800d9c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d93:	89 c7                	mov    %eax,%edi
  800d95:	fc                   	cld    
  800d96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d9c:	f6 c1 03             	test   $0x3,%cl
  800d9f:	75 f2                	jne    800d93 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800da1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800da4:	89 c7                	mov    %eax,%edi
  800da6:	fc                   	cld    
  800da7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800da9:	eb ed                	jmp    800d98 <memmove+0x55>

00800dab <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800dae:	ff 75 10             	pushl  0x10(%ebp)
  800db1:	ff 75 0c             	pushl  0xc(%ebp)
  800db4:	ff 75 08             	pushl  0x8(%ebp)
  800db7:	e8 87 ff ff ff       	call   800d43 <memmove>
}
  800dbc:	c9                   	leave  
  800dbd:	c3                   	ret    

00800dbe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	56                   	push   %esi
  800dc2:	53                   	push   %ebx
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc9:	89 c6                	mov    %eax,%esi
  800dcb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dce:	39 f0                	cmp    %esi,%eax
  800dd0:	74 1c                	je     800dee <memcmp+0x30>
		if (*s1 != *s2)
  800dd2:	0f b6 08             	movzbl (%eax),%ecx
  800dd5:	0f b6 1a             	movzbl (%edx),%ebx
  800dd8:	38 d9                	cmp    %bl,%cl
  800dda:	75 08                	jne    800de4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ddc:	83 c0 01             	add    $0x1,%eax
  800ddf:	83 c2 01             	add    $0x1,%edx
  800de2:	eb ea                	jmp    800dce <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800de4:	0f b6 c1             	movzbl %cl,%eax
  800de7:	0f b6 db             	movzbl %bl,%ebx
  800dea:	29 d8                	sub    %ebx,%eax
  800dec:	eb 05                	jmp    800df3 <memcmp+0x35>
	}

	return 0;
  800dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    

00800df7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e00:	89 c2                	mov    %eax,%edx
  800e02:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e05:	39 d0                	cmp    %edx,%eax
  800e07:	73 09                	jae    800e12 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e09:	38 08                	cmp    %cl,(%eax)
  800e0b:	74 05                	je     800e12 <memfind+0x1b>
	for (; s < ends; s++)
  800e0d:	83 c0 01             	add    $0x1,%eax
  800e10:	eb f3                	jmp    800e05 <memfind+0xe>
			break;
	return (void *) s;
}
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	57                   	push   %edi
  800e18:	56                   	push   %esi
  800e19:	53                   	push   %ebx
  800e1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e20:	eb 03                	jmp    800e25 <strtol+0x11>
		s++;
  800e22:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e25:	0f b6 01             	movzbl (%ecx),%eax
  800e28:	3c 20                	cmp    $0x20,%al
  800e2a:	74 f6                	je     800e22 <strtol+0xe>
  800e2c:	3c 09                	cmp    $0x9,%al
  800e2e:	74 f2                	je     800e22 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800e30:	3c 2b                	cmp    $0x2b,%al
  800e32:	74 2e                	je     800e62 <strtol+0x4e>
	int neg = 0;
  800e34:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800e39:	3c 2d                	cmp    $0x2d,%al
  800e3b:	74 2f                	je     800e6c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e3d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800e43:	75 05                	jne    800e4a <strtol+0x36>
  800e45:	80 39 30             	cmpb   $0x30,(%ecx)
  800e48:	74 2c                	je     800e76 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e4a:	85 db                	test   %ebx,%ebx
  800e4c:	75 0a                	jne    800e58 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e4e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800e53:	80 39 30             	cmpb   $0x30,(%ecx)
  800e56:	74 28                	je     800e80 <strtol+0x6c>
		base = 10;
  800e58:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e60:	eb 50                	jmp    800eb2 <strtol+0x9e>
		s++;
  800e62:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800e65:	bf 00 00 00 00       	mov    $0x0,%edi
  800e6a:	eb d1                	jmp    800e3d <strtol+0x29>
		s++, neg = 1;
  800e6c:	83 c1 01             	add    $0x1,%ecx
  800e6f:	bf 01 00 00 00       	mov    $0x1,%edi
  800e74:	eb c7                	jmp    800e3d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e76:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e7a:	74 0e                	je     800e8a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800e7c:	85 db                	test   %ebx,%ebx
  800e7e:	75 d8                	jne    800e58 <strtol+0x44>
		s++, base = 8;
  800e80:	83 c1 01             	add    $0x1,%ecx
  800e83:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e88:	eb ce                	jmp    800e58 <strtol+0x44>
		s += 2, base = 16;
  800e8a:	83 c1 02             	add    $0x2,%ecx
  800e8d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e92:	eb c4                	jmp    800e58 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800e94:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e97:	89 f3                	mov    %esi,%ebx
  800e99:	80 fb 19             	cmp    $0x19,%bl
  800e9c:	77 29                	ja     800ec7 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800e9e:	0f be d2             	movsbl %dl,%edx
  800ea1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ea4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ea7:	7d 30                	jge    800ed9 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ea9:	83 c1 01             	add    $0x1,%ecx
  800eac:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eb0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800eb2:	0f b6 11             	movzbl (%ecx),%edx
  800eb5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800eb8:	89 f3                	mov    %esi,%ebx
  800eba:	80 fb 09             	cmp    $0x9,%bl
  800ebd:	77 d5                	ja     800e94 <strtol+0x80>
			dig = *s - '0';
  800ebf:	0f be d2             	movsbl %dl,%edx
  800ec2:	83 ea 30             	sub    $0x30,%edx
  800ec5:	eb dd                	jmp    800ea4 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ec7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800eca:	89 f3                	mov    %esi,%ebx
  800ecc:	80 fb 19             	cmp    $0x19,%bl
  800ecf:	77 08                	ja     800ed9 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ed1:	0f be d2             	movsbl %dl,%edx
  800ed4:	83 ea 37             	sub    $0x37,%edx
  800ed7:	eb cb                	jmp    800ea4 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ed9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800edd:	74 05                	je     800ee4 <strtol+0xd0>
		*endptr = (char *) s;
  800edf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ee2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ee4:	89 c2                	mov    %eax,%edx
  800ee6:	f7 da                	neg    %edx
  800ee8:	85 ff                	test   %edi,%edi
  800eea:	0f 45 c2             	cmovne %edx,%eax
}
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    

00800ef2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	57                   	push   %edi
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f03:	89 c3                	mov    %eax,%ebx
  800f05:	89 c7                	mov    %eax,%edi
  800f07:	89 c6                	mov    %eax,%esi
  800f09:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f16:	ba 00 00 00 00       	mov    $0x0,%edx
  800f1b:	b8 01 00 00 00       	mov    $0x1,%eax
  800f20:	89 d1                	mov    %edx,%ecx
  800f22:	89 d3                	mov    %edx,%ebx
  800f24:	89 d7                	mov    %edx,%edi
  800f26:	89 d6                	mov    %edx,%esi
  800f28:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f2a:	5b                   	pop    %ebx
  800f2b:	5e                   	pop    %esi
  800f2c:	5f                   	pop    %edi
  800f2d:	5d                   	pop    %ebp
  800f2e:	c3                   	ret    

00800f2f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	57                   	push   %edi
  800f33:	56                   	push   %esi
  800f34:	53                   	push   %ebx
  800f35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f38:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f40:	b8 03 00 00 00       	mov    $0x3,%eax
  800f45:	89 cb                	mov    %ecx,%ebx
  800f47:	89 cf                	mov    %ecx,%edi
  800f49:	89 ce                	mov    %ecx,%esi
  800f4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4d:	85 c0                	test   %eax,%eax
  800f4f:	7f 08                	jg     800f59 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f59:	83 ec 0c             	sub    $0xc,%esp
  800f5c:	50                   	push   %eax
  800f5d:	6a 03                	push   $0x3
  800f5f:	68 7f 2d 80 00       	push   $0x802d7f
  800f64:	6a 23                	push   $0x23
  800f66:	68 9c 2d 80 00       	push   $0x802d9c
  800f6b:	e8 80 f5 ff ff       	call   8004f0 <_panic>

00800f70 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	57                   	push   %edi
  800f74:	56                   	push   %esi
  800f75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f76:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7b:	b8 02 00 00 00       	mov    $0x2,%eax
  800f80:	89 d1                	mov    %edx,%ecx
  800f82:	89 d3                	mov    %edx,%ebx
  800f84:	89 d7                	mov    %edx,%edi
  800f86:	89 d6                	mov    %edx,%esi
  800f88:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f8a:	5b                   	pop    %ebx
  800f8b:	5e                   	pop    %esi
  800f8c:	5f                   	pop    %edi
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <sys_yield>:

void
sys_yield(void)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	57                   	push   %edi
  800f93:	56                   	push   %esi
  800f94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f95:	ba 00 00 00 00       	mov    $0x0,%edx
  800f9a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f9f:	89 d1                	mov    %edx,%ecx
  800fa1:	89 d3                	mov    %edx,%ebx
  800fa3:	89 d7                	mov    %edx,%edi
  800fa5:	89 d6                	mov    %edx,%esi
  800fa7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fa9:	5b                   	pop    %ebx
  800faa:	5e                   	pop    %esi
  800fab:	5f                   	pop    %edi
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    

00800fae <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	57                   	push   %edi
  800fb2:	56                   	push   %esi
  800fb3:	53                   	push   %ebx
  800fb4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb7:	be 00 00 00 00       	mov    $0x0,%esi
  800fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc2:	b8 04 00 00 00       	mov    $0x4,%eax
  800fc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fca:	89 f7                	mov    %esi,%edi
  800fcc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fce:	85 c0                	test   %eax,%eax
  800fd0:	7f 08                	jg     800fda <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd5:	5b                   	pop    %ebx
  800fd6:	5e                   	pop    %esi
  800fd7:	5f                   	pop    %edi
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fda:	83 ec 0c             	sub    $0xc,%esp
  800fdd:	50                   	push   %eax
  800fde:	6a 04                	push   $0x4
  800fe0:	68 7f 2d 80 00       	push   $0x802d7f
  800fe5:	6a 23                	push   $0x23
  800fe7:	68 9c 2d 80 00       	push   $0x802d9c
  800fec:	e8 ff f4 ff ff       	call   8004f0 <_panic>

00800ff1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	57                   	push   %edi
  800ff5:	56                   	push   %esi
  800ff6:	53                   	push   %ebx
  800ff7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801000:	b8 05 00 00 00       	mov    $0x5,%eax
  801005:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801008:	8b 7d 14             	mov    0x14(%ebp),%edi
  80100b:	8b 75 18             	mov    0x18(%ebp),%esi
  80100e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801010:	85 c0                	test   %eax,%eax
  801012:	7f 08                	jg     80101c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801014:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801017:	5b                   	pop    %ebx
  801018:	5e                   	pop    %esi
  801019:	5f                   	pop    %edi
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80101c:	83 ec 0c             	sub    $0xc,%esp
  80101f:	50                   	push   %eax
  801020:	6a 05                	push   $0x5
  801022:	68 7f 2d 80 00       	push   $0x802d7f
  801027:	6a 23                	push   $0x23
  801029:	68 9c 2d 80 00       	push   $0x802d9c
  80102e:	e8 bd f4 ff ff       	call   8004f0 <_panic>

00801033 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
  801039:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	8b 55 08             	mov    0x8(%ebp),%edx
  801044:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801047:	b8 06 00 00 00       	mov    $0x6,%eax
  80104c:	89 df                	mov    %ebx,%edi
  80104e:	89 de                	mov    %ebx,%esi
  801050:	cd 30                	int    $0x30
	if(check && ret > 0)
  801052:	85 c0                	test   %eax,%eax
  801054:	7f 08                	jg     80105e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801056:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801059:	5b                   	pop    %ebx
  80105a:	5e                   	pop    %esi
  80105b:	5f                   	pop    %edi
  80105c:	5d                   	pop    %ebp
  80105d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105e:	83 ec 0c             	sub    $0xc,%esp
  801061:	50                   	push   %eax
  801062:	6a 06                	push   $0x6
  801064:	68 7f 2d 80 00       	push   $0x802d7f
  801069:	6a 23                	push   $0x23
  80106b:	68 9c 2d 80 00       	push   $0x802d9c
  801070:	e8 7b f4 ff ff       	call   8004f0 <_panic>

00801075 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	57                   	push   %edi
  801079:	56                   	push   %esi
  80107a:	53                   	push   %ebx
  80107b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80107e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801083:	8b 55 08             	mov    0x8(%ebp),%edx
  801086:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801089:	b8 08 00 00 00       	mov    $0x8,%eax
  80108e:	89 df                	mov    %ebx,%edi
  801090:	89 de                	mov    %ebx,%esi
  801092:	cd 30                	int    $0x30
	if(check && ret > 0)
  801094:	85 c0                	test   %eax,%eax
  801096:	7f 08                	jg     8010a0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801098:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5f                   	pop    %edi
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a0:	83 ec 0c             	sub    $0xc,%esp
  8010a3:	50                   	push   %eax
  8010a4:	6a 08                	push   $0x8
  8010a6:	68 7f 2d 80 00       	push   $0x802d7f
  8010ab:	6a 23                	push   $0x23
  8010ad:	68 9c 2d 80 00       	push   $0x802d9c
  8010b2:	e8 39 f4 ff ff       	call   8004f0 <_panic>

008010b7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
  8010ba:	57                   	push   %edi
  8010bb:	56                   	push   %esi
  8010bc:	53                   	push   %ebx
  8010bd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cb:	b8 09 00 00 00       	mov    $0x9,%eax
  8010d0:	89 df                	mov    %ebx,%edi
  8010d2:	89 de                	mov    %ebx,%esi
  8010d4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	7f 08                	jg     8010e2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010dd:	5b                   	pop    %ebx
  8010de:	5e                   	pop    %esi
  8010df:	5f                   	pop    %edi
  8010e0:	5d                   	pop    %ebp
  8010e1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e2:	83 ec 0c             	sub    $0xc,%esp
  8010e5:	50                   	push   %eax
  8010e6:	6a 09                	push   $0x9
  8010e8:	68 7f 2d 80 00       	push   $0x802d7f
  8010ed:	6a 23                	push   $0x23
  8010ef:	68 9c 2d 80 00       	push   $0x802d9c
  8010f4:	e8 f7 f3 ff ff       	call   8004f0 <_panic>

008010f9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	57                   	push   %edi
  8010fd:	56                   	push   %esi
  8010fe:	53                   	push   %ebx
  8010ff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801102:	bb 00 00 00 00       	mov    $0x0,%ebx
  801107:	8b 55 08             	mov    0x8(%ebp),%edx
  80110a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801112:	89 df                	mov    %ebx,%edi
  801114:	89 de                	mov    %ebx,%esi
  801116:	cd 30                	int    $0x30
	if(check && ret > 0)
  801118:	85 c0                	test   %eax,%eax
  80111a:	7f 08                	jg     801124 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80111c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111f:	5b                   	pop    %ebx
  801120:	5e                   	pop    %esi
  801121:	5f                   	pop    %edi
  801122:	5d                   	pop    %ebp
  801123:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801124:	83 ec 0c             	sub    $0xc,%esp
  801127:	50                   	push   %eax
  801128:	6a 0a                	push   $0xa
  80112a:	68 7f 2d 80 00       	push   $0x802d7f
  80112f:	6a 23                	push   $0x23
  801131:	68 9c 2d 80 00       	push   $0x802d9c
  801136:	e8 b5 f3 ff ff       	call   8004f0 <_panic>

0080113b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	57                   	push   %edi
  80113f:	56                   	push   %esi
  801140:	53                   	push   %ebx
	asm volatile("int %1\n"
  801141:	8b 55 08             	mov    0x8(%ebp),%edx
  801144:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801147:	b8 0c 00 00 00       	mov    $0xc,%eax
  80114c:	be 00 00 00 00       	mov    $0x0,%esi
  801151:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801154:	8b 7d 14             	mov    0x14(%ebp),%edi
  801157:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801159:	5b                   	pop    %ebx
  80115a:	5e                   	pop    %esi
  80115b:	5f                   	pop    %edi
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	57                   	push   %edi
  801162:	56                   	push   %esi
  801163:	53                   	push   %ebx
  801164:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801167:	b9 00 00 00 00       	mov    $0x0,%ecx
  80116c:	8b 55 08             	mov    0x8(%ebp),%edx
  80116f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801174:	89 cb                	mov    %ecx,%ebx
  801176:	89 cf                	mov    %ecx,%edi
  801178:	89 ce                	mov    %ecx,%esi
  80117a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80117c:	85 c0                	test   %eax,%eax
  80117e:	7f 08                	jg     801188 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801180:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801183:	5b                   	pop    %ebx
  801184:	5e                   	pop    %esi
  801185:	5f                   	pop    %edi
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801188:	83 ec 0c             	sub    $0xc,%esp
  80118b:	50                   	push   %eax
  80118c:	6a 0d                	push   $0xd
  80118e:	68 7f 2d 80 00       	push   $0x802d7f
  801193:	6a 23                	push   $0x23
  801195:	68 9c 2d 80 00       	push   $0x802d9c
  80119a:	e8 51 f3 ff ff       	call   8004f0 <_panic>

0080119f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  8011a5:	68 aa 2d 80 00       	push   $0x802daa
  8011aa:	6a 25                	push   $0x25
  8011ac:	68 c2 2d 80 00       	push   $0x802dc2
  8011b1:	e8 3a f3 ff ff       	call   8004f0 <_panic>

008011b6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	57                   	push   %edi
  8011ba:	56                   	push   %esi
  8011bb:	53                   	push   %ebx
  8011bc:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  8011bf:	68 9f 11 80 00       	push   $0x80119f
  8011c4:	e8 b2 13 00 00       	call   80257b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011c9:	b8 07 00 00 00       	mov    $0x7,%eax
  8011ce:	cd 30                	int    $0x30
  8011d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  8011d6:	83 c4 10             	add    $0x10,%esp
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	78 27                	js     801204 <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  8011dd:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  8011e2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011e6:	75 65                	jne    80124d <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011e8:	e8 83 fd ff ff       	call   800f70 <sys_getenvid>
  8011ed:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011f2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011f5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011fa:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  8011ff:	e9 11 01 00 00       	jmp    801315 <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  801204:	50                   	push   %eax
  801205:	68 c5 29 80 00       	push   $0x8029c5
  80120a:	6a 6f                	push   $0x6f
  80120c:	68 c2 2d 80 00       	push   $0x802dc2
  801211:	e8 da f2 ff ff       	call   8004f0 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  801216:	e8 55 fd ff ff       	call   800f70 <sys_getenvid>
  80121b:	83 ec 0c             	sub    $0xc,%esp
  80121e:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  801224:	56                   	push   %esi
  801225:	57                   	push   %edi
  801226:	ff 75 e4             	pushl  -0x1c(%ebp)
  801229:	57                   	push   %edi
  80122a:	50                   	push   %eax
  80122b:	e8 c1 fd ff ff       	call   800ff1 <sys_page_map>
  801230:	83 c4 20             	add    $0x20,%esp
  801233:	85 c0                	test   %eax,%eax
  801235:	0f 88 84 00 00 00    	js     8012bf <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  80123b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801241:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801247:	0f 84 84 00 00 00    	je     8012d1 <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  80124d:	89 d8                	mov    %ebx,%eax
  80124f:	c1 e8 16             	shr    $0x16,%eax
  801252:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801259:	a8 01                	test   $0x1,%al
  80125b:	74 de                	je     80123b <fork+0x85>
  80125d:	89 d8                	mov    %ebx,%eax
  80125f:	c1 e8 0c             	shr    $0xc,%eax
  801262:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801269:	f6 c2 01             	test   $0x1,%dl
  80126c:	74 cd                	je     80123b <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  80126e:	89 c7                	mov    %eax,%edi
  801270:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  801273:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  80127a:	f7 c6 00 04 00 00    	test   $0x400,%esi
  801280:	75 94                	jne    801216 <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  801282:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801288:	0f 85 d1 00 00 00    	jne    80135f <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  80128e:	a1 04 50 80 00       	mov    0x805004,%eax
  801293:	8b 40 48             	mov    0x48(%eax),%eax
  801296:	83 ec 0c             	sub    $0xc,%esp
  801299:	6a 05                	push   $0x5
  80129b:	57                   	push   %edi
  80129c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80129f:	57                   	push   %edi
  8012a0:	50                   	push   %eax
  8012a1:	e8 4b fd ff ff       	call   800ff1 <sys_page_map>
  8012a6:	83 c4 20             	add    $0x20,%esp
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	79 8e                	jns    80123b <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  8012ad:	50                   	push   %eax
  8012ae:	68 1c 2e 80 00       	push   $0x802e1c
  8012b3:	6a 4a                	push   $0x4a
  8012b5:	68 c2 2d 80 00       	push   $0x802dc2
  8012ba:	e8 31 f2 ff ff       	call   8004f0 <_panic>
                        panic("duppage: page mapping failed %e", r);
  8012bf:	50                   	push   %eax
  8012c0:	68 fc 2d 80 00       	push   $0x802dfc
  8012c5:	6a 41                	push   $0x41
  8012c7:	68 c2 2d 80 00       	push   $0x802dc2
  8012cc:	e8 1f f2 ff ff       	call   8004f0 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  8012d1:	83 ec 04             	sub    $0x4,%esp
  8012d4:	6a 07                	push   $0x7
  8012d6:	68 00 f0 bf ee       	push   $0xeebff000
  8012db:	ff 75 e0             	pushl  -0x20(%ebp)
  8012de:	e8 cb fc ff ff       	call   800fae <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  8012e3:	83 c4 10             	add    $0x10,%esp
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	78 36                	js     801320 <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  8012ea:	83 ec 08             	sub    $0x8,%esp
  8012ed:	68 ef 25 80 00       	push   $0x8025ef
  8012f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8012f5:	e8 ff fd ff ff       	call   8010f9 <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	78 34                	js     801335 <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801301:	83 ec 08             	sub    $0x8,%esp
  801304:	6a 02                	push   $0x2
  801306:	ff 75 e0             	pushl  -0x20(%ebp)
  801309:	e8 67 fd ff ff       	call   801075 <sys_env_set_status>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	78 35                	js     80134a <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  801315:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801318:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80131b:	5b                   	pop    %ebx
  80131c:	5e                   	pop    %esi
  80131d:	5f                   	pop    %edi
  80131e:	5d                   	pop    %ebp
  80131f:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  801320:	50                   	push   %eax
  801321:	68 c5 29 80 00       	push   $0x8029c5
  801326:	68 82 00 00 00       	push   $0x82
  80132b:	68 c2 2d 80 00       	push   $0x802dc2
  801330:	e8 bb f1 ff ff       	call   8004f0 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801335:	50                   	push   %eax
  801336:	68 40 2e 80 00       	push   $0x802e40
  80133b:	68 87 00 00 00       	push   $0x87
  801340:	68 c2 2d 80 00       	push   $0x802dc2
  801345:	e8 a6 f1 ff ff       	call   8004f0 <_panic>
        	panic("sys_env_set_status: %e", r);
  80134a:	50                   	push   %eax
  80134b:	68 cd 2d 80 00       	push   $0x802dcd
  801350:	68 8b 00 00 00       	push   $0x8b
  801355:	68 c2 2d 80 00       	push   $0x802dc2
  80135a:	e8 91 f1 ff ff       	call   8004f0 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  80135f:	a1 04 50 80 00       	mov    0x805004,%eax
  801364:	8b 40 48             	mov    0x48(%eax),%eax
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	68 05 08 00 00       	push   $0x805
  80136f:	57                   	push   %edi
  801370:	ff 75 e4             	pushl  -0x1c(%ebp)
  801373:	57                   	push   %edi
  801374:	50                   	push   %eax
  801375:	e8 77 fc ff ff       	call   800ff1 <sys_page_map>
  80137a:	83 c4 20             	add    $0x20,%esp
  80137d:	85 c0                	test   %eax,%eax
  80137f:	0f 88 28 ff ff ff    	js     8012ad <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  801385:	a1 04 50 80 00       	mov    0x805004,%eax
  80138a:	8b 50 48             	mov    0x48(%eax),%edx
  80138d:	8b 40 48             	mov    0x48(%eax),%eax
  801390:	83 ec 0c             	sub    $0xc,%esp
  801393:	68 05 08 00 00       	push   $0x805
  801398:	57                   	push   %edi
  801399:	52                   	push   %edx
  80139a:	57                   	push   %edi
  80139b:	50                   	push   %eax
  80139c:	e8 50 fc ff ff       	call   800ff1 <sys_page_map>
  8013a1:	83 c4 20             	add    $0x20,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	0f 89 8f fe ff ff    	jns    80123b <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  8013ac:	50                   	push   %eax
  8013ad:	68 1c 2e 80 00       	push   $0x802e1c
  8013b2:	6a 4f                	push   $0x4f
  8013b4:	68 c2 2d 80 00       	push   $0x802dc2
  8013b9:	e8 32 f1 ff ff       	call   8004f0 <_panic>

008013be <sfork>:

// Challenge!
int
sfork(void)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8013c4:	68 e4 2d 80 00       	push   $0x802de4
  8013c9:	68 94 00 00 00       	push   $0x94
  8013ce:	68 c2 2d 80 00       	push   $0x802dc2
  8013d3:	e8 18 f1 ff ff       	call   8004f0 <_panic>

008013d8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	05 00 00 00 30       	add    $0x30000000,%eax
  8013e3:	c1 e8 0c             	shr    $0xc,%eax
}
  8013e6:	5d                   	pop    %ebp
  8013e7:	c3                   	ret    

008013e8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013fd:	5d                   	pop    %ebp
  8013fe:	c3                   	ret    

008013ff <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801405:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80140a:	89 c2                	mov    %eax,%edx
  80140c:	c1 ea 16             	shr    $0x16,%edx
  80140f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801416:	f6 c2 01             	test   $0x1,%dl
  801419:	74 2a                	je     801445 <fd_alloc+0x46>
  80141b:	89 c2                	mov    %eax,%edx
  80141d:	c1 ea 0c             	shr    $0xc,%edx
  801420:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801427:	f6 c2 01             	test   $0x1,%dl
  80142a:	74 19                	je     801445 <fd_alloc+0x46>
  80142c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801431:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801436:	75 d2                	jne    80140a <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801438:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80143e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801443:	eb 07                	jmp    80144c <fd_alloc+0x4d>
			*fd_store = fd;
  801445:	89 01                	mov    %eax,(%ecx)
			return 0;
  801447:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801454:	83 f8 1f             	cmp    $0x1f,%eax
  801457:	77 36                	ja     80148f <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801459:	c1 e0 0c             	shl    $0xc,%eax
  80145c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801461:	89 c2                	mov    %eax,%edx
  801463:	c1 ea 16             	shr    $0x16,%edx
  801466:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80146d:	f6 c2 01             	test   $0x1,%dl
  801470:	74 24                	je     801496 <fd_lookup+0x48>
  801472:	89 c2                	mov    %eax,%edx
  801474:	c1 ea 0c             	shr    $0xc,%edx
  801477:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80147e:	f6 c2 01             	test   $0x1,%dl
  801481:	74 1a                	je     80149d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801483:	8b 55 0c             	mov    0xc(%ebp),%edx
  801486:	89 02                	mov    %eax,(%edx)
	return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    
		return -E_INVAL;
  80148f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801494:	eb f7                	jmp    80148d <fd_lookup+0x3f>
		return -E_INVAL;
  801496:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149b:	eb f0                	jmp    80148d <fd_lookup+0x3f>
  80149d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a2:	eb e9                	jmp    80148d <fd_lookup+0x3f>

008014a4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 08             	sub    $0x8,%esp
  8014aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014ad:	ba e0 2e 80 00       	mov    $0x802ee0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014b2:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014b7:	39 08                	cmp    %ecx,(%eax)
  8014b9:	74 33                	je     8014ee <dev_lookup+0x4a>
  8014bb:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8014be:	8b 02                	mov    (%edx),%eax
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	75 f3                	jne    8014b7 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014c4:	a1 04 50 80 00       	mov    0x805004,%eax
  8014c9:	8b 40 48             	mov    0x48(%eax),%eax
  8014cc:	83 ec 04             	sub    $0x4,%esp
  8014cf:	51                   	push   %ecx
  8014d0:	50                   	push   %eax
  8014d1:	68 64 2e 80 00       	push   $0x802e64
  8014d6:	e8 f0 f0 ff ff       	call   8005cb <cprintf>
	*dev = 0;
  8014db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    
			*dev = devtab[i];
  8014ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014f1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f8:	eb f2                	jmp    8014ec <dev_lookup+0x48>

008014fa <fd_close>:
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	57                   	push   %edi
  8014fe:	56                   	push   %esi
  8014ff:	53                   	push   %ebx
  801500:	83 ec 1c             	sub    $0x1c,%esp
  801503:	8b 75 08             	mov    0x8(%ebp),%esi
  801506:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801509:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80150c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80150d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801513:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801516:	50                   	push   %eax
  801517:	e8 32 ff ff ff       	call   80144e <fd_lookup>
  80151c:	89 c3                	mov    %eax,%ebx
  80151e:	83 c4 08             	add    $0x8,%esp
  801521:	85 c0                	test   %eax,%eax
  801523:	78 05                	js     80152a <fd_close+0x30>
	    || fd != fd2)
  801525:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801528:	74 16                	je     801540 <fd_close+0x46>
		return (must_exist ? r : 0);
  80152a:	89 f8                	mov    %edi,%eax
  80152c:	84 c0                	test   %al,%al
  80152e:	b8 00 00 00 00       	mov    $0x0,%eax
  801533:	0f 44 d8             	cmove  %eax,%ebx
}
  801536:	89 d8                	mov    %ebx,%eax
  801538:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153b:	5b                   	pop    %ebx
  80153c:	5e                   	pop    %esi
  80153d:	5f                   	pop    %edi
  80153e:	5d                   	pop    %ebp
  80153f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801546:	50                   	push   %eax
  801547:	ff 36                	pushl  (%esi)
  801549:	e8 56 ff ff ff       	call   8014a4 <dev_lookup>
  80154e:	89 c3                	mov    %eax,%ebx
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	78 15                	js     80156c <fd_close+0x72>
		if (dev->dev_close)
  801557:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155a:	8b 40 10             	mov    0x10(%eax),%eax
  80155d:	85 c0                	test   %eax,%eax
  80155f:	74 1b                	je     80157c <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	56                   	push   %esi
  801565:	ff d0                	call   *%eax
  801567:	89 c3                	mov    %eax,%ebx
  801569:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	56                   	push   %esi
  801570:	6a 00                	push   $0x0
  801572:	e8 bc fa ff ff       	call   801033 <sys_page_unmap>
	return r;
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	eb ba                	jmp    801536 <fd_close+0x3c>
			r = 0;
  80157c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801581:	eb e9                	jmp    80156c <fd_close+0x72>

00801583 <close>:

int
close(int fdnum)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801589:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158c:	50                   	push   %eax
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	e8 b9 fe ff ff       	call   80144e <fd_lookup>
  801595:	83 c4 08             	add    $0x8,%esp
  801598:	85 c0                	test   %eax,%eax
  80159a:	78 10                	js     8015ac <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80159c:	83 ec 08             	sub    $0x8,%esp
  80159f:	6a 01                	push   $0x1
  8015a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a4:	e8 51 ff ff ff       	call   8014fa <fd_close>
  8015a9:	83 c4 10             	add    $0x10,%esp
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <close_all>:

void
close_all(void)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	53                   	push   %ebx
  8015b2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015b5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015ba:	83 ec 0c             	sub    $0xc,%esp
  8015bd:	53                   	push   %ebx
  8015be:	e8 c0 ff ff ff       	call   801583 <close>
	for (i = 0; i < MAXFD; i++)
  8015c3:	83 c3 01             	add    $0x1,%ebx
  8015c6:	83 c4 10             	add    $0x10,%esp
  8015c9:	83 fb 20             	cmp    $0x20,%ebx
  8015cc:	75 ec                	jne    8015ba <close_all+0xc>
}
  8015ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	57                   	push   %edi
  8015d7:	56                   	push   %esi
  8015d8:	53                   	push   %ebx
  8015d9:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015dc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015df:	50                   	push   %eax
  8015e0:	ff 75 08             	pushl  0x8(%ebp)
  8015e3:	e8 66 fe ff ff       	call   80144e <fd_lookup>
  8015e8:	89 c3                	mov    %eax,%ebx
  8015ea:	83 c4 08             	add    $0x8,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	0f 88 81 00 00 00    	js     801676 <dup+0xa3>
		return r;
	close(newfdnum);
  8015f5:	83 ec 0c             	sub    $0xc,%esp
  8015f8:	ff 75 0c             	pushl  0xc(%ebp)
  8015fb:	e8 83 ff ff ff       	call   801583 <close>

	newfd = INDEX2FD(newfdnum);
  801600:	8b 75 0c             	mov    0xc(%ebp),%esi
  801603:	c1 e6 0c             	shl    $0xc,%esi
  801606:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80160c:	83 c4 04             	add    $0x4,%esp
  80160f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801612:	e8 d1 fd ff ff       	call   8013e8 <fd2data>
  801617:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801619:	89 34 24             	mov    %esi,(%esp)
  80161c:	e8 c7 fd ff ff       	call   8013e8 <fd2data>
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801626:	89 d8                	mov    %ebx,%eax
  801628:	c1 e8 16             	shr    $0x16,%eax
  80162b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801632:	a8 01                	test   $0x1,%al
  801634:	74 11                	je     801647 <dup+0x74>
  801636:	89 d8                	mov    %ebx,%eax
  801638:	c1 e8 0c             	shr    $0xc,%eax
  80163b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801642:	f6 c2 01             	test   $0x1,%dl
  801645:	75 39                	jne    801680 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801647:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80164a:	89 d0                	mov    %edx,%eax
  80164c:	c1 e8 0c             	shr    $0xc,%eax
  80164f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	25 07 0e 00 00       	and    $0xe07,%eax
  80165e:	50                   	push   %eax
  80165f:	56                   	push   %esi
  801660:	6a 00                	push   $0x0
  801662:	52                   	push   %edx
  801663:	6a 00                	push   $0x0
  801665:	e8 87 f9 ff ff       	call   800ff1 <sys_page_map>
  80166a:	89 c3                	mov    %eax,%ebx
  80166c:	83 c4 20             	add    $0x20,%esp
  80166f:	85 c0                	test   %eax,%eax
  801671:	78 31                	js     8016a4 <dup+0xd1>
		goto err;

	return newfdnum;
  801673:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801676:	89 d8                	mov    %ebx,%eax
  801678:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80167b:	5b                   	pop    %ebx
  80167c:	5e                   	pop    %esi
  80167d:	5f                   	pop    %edi
  80167e:	5d                   	pop    %ebp
  80167f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801680:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801687:	83 ec 0c             	sub    $0xc,%esp
  80168a:	25 07 0e 00 00       	and    $0xe07,%eax
  80168f:	50                   	push   %eax
  801690:	57                   	push   %edi
  801691:	6a 00                	push   $0x0
  801693:	53                   	push   %ebx
  801694:	6a 00                	push   $0x0
  801696:	e8 56 f9 ff ff       	call   800ff1 <sys_page_map>
  80169b:	89 c3                	mov    %eax,%ebx
  80169d:	83 c4 20             	add    $0x20,%esp
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	79 a3                	jns    801647 <dup+0x74>
	sys_page_unmap(0, newfd);
  8016a4:	83 ec 08             	sub    $0x8,%esp
  8016a7:	56                   	push   %esi
  8016a8:	6a 00                	push   $0x0
  8016aa:	e8 84 f9 ff ff       	call   801033 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016af:	83 c4 08             	add    $0x8,%esp
  8016b2:	57                   	push   %edi
  8016b3:	6a 00                	push   $0x0
  8016b5:	e8 79 f9 ff ff       	call   801033 <sys_page_unmap>
	return r;
  8016ba:	83 c4 10             	add    $0x10,%esp
  8016bd:	eb b7                	jmp    801676 <dup+0xa3>

008016bf <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	53                   	push   %ebx
  8016c3:	83 ec 14             	sub    $0x14,%esp
  8016c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016cc:	50                   	push   %eax
  8016cd:	53                   	push   %ebx
  8016ce:	e8 7b fd ff ff       	call   80144e <fd_lookup>
  8016d3:	83 c4 08             	add    $0x8,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	78 3f                	js     801719 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016da:	83 ec 08             	sub    $0x8,%esp
  8016dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e0:	50                   	push   %eax
  8016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e4:	ff 30                	pushl  (%eax)
  8016e6:	e8 b9 fd ff ff       	call   8014a4 <dev_lookup>
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 27                	js     801719 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016f5:	8b 42 08             	mov    0x8(%edx),%eax
  8016f8:	83 e0 03             	and    $0x3,%eax
  8016fb:	83 f8 01             	cmp    $0x1,%eax
  8016fe:	74 1e                	je     80171e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	8b 40 08             	mov    0x8(%eax),%eax
  801706:	85 c0                	test   %eax,%eax
  801708:	74 35                	je     80173f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80170a:	83 ec 04             	sub    $0x4,%esp
  80170d:	ff 75 10             	pushl  0x10(%ebp)
  801710:	ff 75 0c             	pushl  0xc(%ebp)
  801713:	52                   	push   %edx
  801714:	ff d0                	call   *%eax
  801716:	83 c4 10             	add    $0x10,%esp
}
  801719:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80171e:	a1 04 50 80 00       	mov    0x805004,%eax
  801723:	8b 40 48             	mov    0x48(%eax),%eax
  801726:	83 ec 04             	sub    $0x4,%esp
  801729:	53                   	push   %ebx
  80172a:	50                   	push   %eax
  80172b:	68 a5 2e 80 00       	push   $0x802ea5
  801730:	e8 96 ee ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80173d:	eb da                	jmp    801719 <read+0x5a>
		return -E_NOT_SUPP;
  80173f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801744:	eb d3                	jmp    801719 <read+0x5a>

00801746 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	57                   	push   %edi
  80174a:	56                   	push   %esi
  80174b:	53                   	push   %ebx
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801752:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801755:	bb 00 00 00 00       	mov    $0x0,%ebx
  80175a:	39 f3                	cmp    %esi,%ebx
  80175c:	73 25                	jae    801783 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80175e:	83 ec 04             	sub    $0x4,%esp
  801761:	89 f0                	mov    %esi,%eax
  801763:	29 d8                	sub    %ebx,%eax
  801765:	50                   	push   %eax
  801766:	89 d8                	mov    %ebx,%eax
  801768:	03 45 0c             	add    0xc(%ebp),%eax
  80176b:	50                   	push   %eax
  80176c:	57                   	push   %edi
  80176d:	e8 4d ff ff ff       	call   8016bf <read>
		if (m < 0)
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	85 c0                	test   %eax,%eax
  801777:	78 08                	js     801781 <readn+0x3b>
			return m;
		if (m == 0)
  801779:	85 c0                	test   %eax,%eax
  80177b:	74 06                	je     801783 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80177d:	01 c3                	add    %eax,%ebx
  80177f:	eb d9                	jmp    80175a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801781:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801783:	89 d8                	mov    %ebx,%eax
  801785:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801788:	5b                   	pop    %ebx
  801789:	5e                   	pop    %esi
  80178a:	5f                   	pop    %edi
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    

0080178d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	53                   	push   %ebx
  801791:	83 ec 14             	sub    $0x14,%esp
  801794:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801797:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80179a:	50                   	push   %eax
  80179b:	53                   	push   %ebx
  80179c:	e8 ad fc ff ff       	call   80144e <fd_lookup>
  8017a1:	83 c4 08             	add    $0x8,%esp
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	78 3a                	js     8017e2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a8:	83 ec 08             	sub    $0x8,%esp
  8017ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ae:	50                   	push   %eax
  8017af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b2:	ff 30                	pushl  (%eax)
  8017b4:	e8 eb fc ff ff       	call   8014a4 <dev_lookup>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	78 22                	js     8017e2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017c7:	74 1e                	je     8017e7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017cc:	8b 52 0c             	mov    0xc(%edx),%edx
  8017cf:	85 d2                	test   %edx,%edx
  8017d1:	74 35                	je     801808 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017d3:	83 ec 04             	sub    $0x4,%esp
  8017d6:	ff 75 10             	pushl  0x10(%ebp)
  8017d9:	ff 75 0c             	pushl  0xc(%ebp)
  8017dc:	50                   	push   %eax
  8017dd:	ff d2                	call   *%edx
  8017df:	83 c4 10             	add    $0x10,%esp
}
  8017e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017e7:	a1 04 50 80 00       	mov    0x805004,%eax
  8017ec:	8b 40 48             	mov    0x48(%eax),%eax
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	53                   	push   %ebx
  8017f3:	50                   	push   %eax
  8017f4:	68 c1 2e 80 00       	push   $0x802ec1
  8017f9:	e8 cd ed ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801806:	eb da                	jmp    8017e2 <write+0x55>
		return -E_NOT_SUPP;
  801808:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80180d:	eb d3                	jmp    8017e2 <write+0x55>

0080180f <seek>:

int
seek(int fdnum, off_t offset)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801815:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801818:	50                   	push   %eax
  801819:	ff 75 08             	pushl  0x8(%ebp)
  80181c:	e8 2d fc ff ff       	call   80144e <fd_lookup>
  801821:	83 c4 08             	add    $0x8,%esp
  801824:	85 c0                	test   %eax,%eax
  801826:	78 0e                	js     801836 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801831:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	53                   	push   %ebx
  80183c:	83 ec 14             	sub    $0x14,%esp
  80183f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801842:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801845:	50                   	push   %eax
  801846:	53                   	push   %ebx
  801847:	e8 02 fc ff ff       	call   80144e <fd_lookup>
  80184c:	83 c4 08             	add    $0x8,%esp
  80184f:	85 c0                	test   %eax,%eax
  801851:	78 37                	js     80188a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185d:	ff 30                	pushl  (%eax)
  80185f:	e8 40 fc ff ff       	call   8014a4 <dev_lookup>
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 1f                	js     80188a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801872:	74 1b                	je     80188f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801877:	8b 52 18             	mov    0x18(%edx),%edx
  80187a:	85 d2                	test   %edx,%edx
  80187c:	74 32                	je     8018b0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80187e:	83 ec 08             	sub    $0x8,%esp
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	50                   	push   %eax
  801885:	ff d2                	call   *%edx
  801887:	83 c4 10             	add    $0x10,%esp
}
  80188a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80188f:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801894:	8b 40 48             	mov    0x48(%eax),%eax
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	53                   	push   %ebx
  80189b:	50                   	push   %eax
  80189c:	68 84 2e 80 00       	push   $0x802e84
  8018a1:	e8 25 ed ff ff       	call   8005cb <cprintf>
		return -E_INVAL;
  8018a6:	83 c4 10             	add    $0x10,%esp
  8018a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018ae:	eb da                	jmp    80188a <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018b5:	eb d3                	jmp    80188a <ftruncate+0x52>

008018b7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 14             	sub    $0x14,%esp
  8018be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c4:	50                   	push   %eax
  8018c5:	ff 75 08             	pushl  0x8(%ebp)
  8018c8:	e8 81 fb ff ff       	call   80144e <fd_lookup>
  8018cd:	83 c4 08             	add    $0x8,%esp
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	78 4b                	js     80191f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d4:	83 ec 08             	sub    $0x8,%esp
  8018d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018da:	50                   	push   %eax
  8018db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018de:	ff 30                	pushl  (%eax)
  8018e0:	e8 bf fb ff ff       	call   8014a4 <dev_lookup>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	85 c0                	test   %eax,%eax
  8018ea:	78 33                	js     80191f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ef:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018f3:	74 2f                	je     801924 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018f5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018f8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018ff:	00 00 00 
	stat->st_isdir = 0;
  801902:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801909:	00 00 00 
	stat->st_dev = dev;
  80190c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801912:	83 ec 08             	sub    $0x8,%esp
  801915:	53                   	push   %ebx
  801916:	ff 75 f0             	pushl  -0x10(%ebp)
  801919:	ff 50 14             	call   *0x14(%eax)
  80191c:	83 c4 10             	add    $0x10,%esp
}
  80191f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801922:	c9                   	leave  
  801923:	c3                   	ret    
		return -E_NOT_SUPP;
  801924:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801929:	eb f4                	jmp    80191f <fstat+0x68>

0080192b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801930:	83 ec 08             	sub    $0x8,%esp
  801933:	6a 00                	push   $0x0
  801935:	ff 75 08             	pushl  0x8(%ebp)
  801938:	e8 e7 01 00 00       	call   801b24 <open>
  80193d:	89 c3                	mov    %eax,%ebx
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	78 1b                	js     801961 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801946:	83 ec 08             	sub    $0x8,%esp
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	50                   	push   %eax
  80194d:	e8 65 ff ff ff       	call   8018b7 <fstat>
  801952:	89 c6                	mov    %eax,%esi
	close(fd);
  801954:	89 1c 24             	mov    %ebx,(%esp)
  801957:	e8 27 fc ff ff       	call   801583 <close>
	return r;
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	89 f3                	mov    %esi,%ebx
}
  801961:	89 d8                	mov    %ebx,%eax
  801963:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801966:	5b                   	pop    %ebx
  801967:	5e                   	pop    %esi
  801968:	5d                   	pop    %ebp
  801969:	c3                   	ret    

0080196a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	56                   	push   %esi
  80196e:	53                   	push   %ebx
  80196f:	89 c6                	mov    %eax,%esi
  801971:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801973:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80197a:	74 27                	je     8019a3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80197c:	6a 07                	push   $0x7
  80197e:	68 00 60 80 00       	push   $0x806000
  801983:	56                   	push   %esi
  801984:	ff 35 00 50 80 00    	pushl  0x805000
  80198a:	e8 9e 0c 00 00       	call   80262d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80198f:	83 c4 0c             	add    $0xc,%esp
  801992:	6a 00                	push   $0x0
  801994:	53                   	push   %ebx
  801995:	6a 00                	push   $0x0
  801997:	e8 7a 0c 00 00       	call   802616 <ipc_recv>
}
  80199c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019a3:	83 ec 0c             	sub    $0xc,%esp
  8019a6:	6a 01                	push   $0x1
  8019a8:	e8 97 0c 00 00       	call   802644 <ipc_find_env>
  8019ad:	a3 00 50 80 00       	mov    %eax,0x805000
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	eb c5                	jmp    80197c <fsipc+0x12>

008019b7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8019c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cb:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d5:	b8 02 00 00 00       	mov    $0x2,%eax
  8019da:	e8 8b ff ff ff       	call   80196a <fsipc>
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <devfile_flush>:
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ed:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8019f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8019fc:	e8 69 ff ff ff       	call   80196a <fsipc>
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <devfile_stat>:
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	53                   	push   %ebx
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	8b 40 0c             	mov    0xc(%eax),%eax
  801a13:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a18:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1d:	b8 05 00 00 00       	mov    $0x5,%eax
  801a22:	e8 43 ff ff ff       	call   80196a <fsipc>
  801a27:	85 c0                	test   %eax,%eax
  801a29:	78 2c                	js     801a57 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a2b:	83 ec 08             	sub    $0x8,%esp
  801a2e:	68 00 60 80 00       	push   $0x806000
  801a33:	53                   	push   %ebx
  801a34:	e8 7c f1 ff ff       	call   800bb5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a39:	a1 80 60 80 00       	mov    0x806080,%eax
  801a3e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a44:	a1 84 60 80 00       	mov    0x806084,%eax
  801a49:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a4f:	83 c4 10             	add    $0x10,%esp
  801a52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <devfile_write>:
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 0c             	sub    $0xc,%esp
  801a62:	8b 45 10             	mov    0x10(%ebp),%eax
  801a65:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a6a:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a6f:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a72:	8b 55 08             	mov    0x8(%ebp),%edx
  801a75:	8b 52 0c             	mov    0xc(%edx),%edx
  801a78:	89 15 00 60 80 00    	mov    %edx,0x806000
        fsipcbuf.write.req_n = n;
  801a7e:	a3 04 60 80 00       	mov    %eax,0x806004
        memmove(fsipcbuf.write.req_buf, buf, n);
  801a83:	50                   	push   %eax
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	68 08 60 80 00       	push   $0x806008
  801a8c:	e8 b2 f2 ff ff       	call   800d43 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a91:	ba 00 00 00 00       	mov    $0x0,%edx
  801a96:	b8 04 00 00 00       	mov    $0x4,%eax
  801a9b:	e8 ca fe ff ff       	call   80196a <fsipc>
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <devfile_read>:
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	56                   	push   %esi
  801aa6:	53                   	push   %ebx
  801aa7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ab5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801abb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac0:	b8 03 00 00 00       	mov    $0x3,%eax
  801ac5:	e8 a0 fe ff ff       	call   80196a <fsipc>
  801aca:	89 c3                	mov    %eax,%ebx
  801acc:	85 c0                	test   %eax,%eax
  801ace:	78 1f                	js     801aef <devfile_read+0x4d>
	assert(r <= n);
  801ad0:	39 f0                	cmp    %esi,%eax
  801ad2:	77 24                	ja     801af8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801ad4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ad9:	7f 33                	jg     801b0e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	50                   	push   %eax
  801adf:	68 00 60 80 00       	push   $0x806000
  801ae4:	ff 75 0c             	pushl  0xc(%ebp)
  801ae7:	e8 57 f2 ff ff       	call   800d43 <memmove>
	return r;
  801aec:	83 c4 10             	add    $0x10,%esp
}
  801aef:	89 d8                	mov    %ebx,%eax
  801af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af4:	5b                   	pop    %ebx
  801af5:	5e                   	pop    %esi
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    
	assert(r <= n);
  801af8:	68 f0 2e 80 00       	push   $0x802ef0
  801afd:	68 f7 2e 80 00       	push   $0x802ef7
  801b02:	6a 7c                	push   $0x7c
  801b04:	68 0c 2f 80 00       	push   $0x802f0c
  801b09:	e8 e2 e9 ff ff       	call   8004f0 <_panic>
	assert(r <= PGSIZE);
  801b0e:	68 17 2f 80 00       	push   $0x802f17
  801b13:	68 f7 2e 80 00       	push   $0x802ef7
  801b18:	6a 7d                	push   $0x7d
  801b1a:	68 0c 2f 80 00       	push   $0x802f0c
  801b1f:	e8 cc e9 ff ff       	call   8004f0 <_panic>

00801b24 <open>:
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	56                   	push   %esi
  801b28:	53                   	push   %ebx
  801b29:	83 ec 1c             	sub    $0x1c,%esp
  801b2c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b2f:	56                   	push   %esi
  801b30:	e8 49 f0 ff ff       	call   800b7e <strlen>
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b3d:	7f 6c                	jg     801bab <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b3f:	83 ec 0c             	sub    $0xc,%esp
  801b42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b45:	50                   	push   %eax
  801b46:	e8 b4 f8 ff ff       	call   8013ff <fd_alloc>
  801b4b:	89 c3                	mov    %eax,%ebx
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	85 c0                	test   %eax,%eax
  801b52:	78 3c                	js     801b90 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b54:	83 ec 08             	sub    $0x8,%esp
  801b57:	56                   	push   %esi
  801b58:	68 00 60 80 00       	push   $0x806000
  801b5d:	e8 53 f0 ff ff       	call   800bb5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b65:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b72:	e8 f3 fd ff ff       	call   80196a <fsipc>
  801b77:	89 c3                	mov    %eax,%ebx
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	78 19                	js     801b99 <open+0x75>
	return fd2num(fd);
  801b80:	83 ec 0c             	sub    $0xc,%esp
  801b83:	ff 75 f4             	pushl  -0xc(%ebp)
  801b86:	e8 4d f8 ff ff       	call   8013d8 <fd2num>
  801b8b:	89 c3                	mov    %eax,%ebx
  801b8d:	83 c4 10             	add    $0x10,%esp
}
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b95:	5b                   	pop    %ebx
  801b96:	5e                   	pop    %esi
  801b97:	5d                   	pop    %ebp
  801b98:	c3                   	ret    
		fd_close(fd, 0);
  801b99:	83 ec 08             	sub    $0x8,%esp
  801b9c:	6a 00                	push   $0x0
  801b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba1:	e8 54 f9 ff ff       	call   8014fa <fd_close>
		return r;
  801ba6:	83 c4 10             	add    $0x10,%esp
  801ba9:	eb e5                	jmp    801b90 <open+0x6c>
		return -E_BAD_PATH;
  801bab:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bb0:	eb de                	jmp    801b90 <open+0x6c>

00801bb2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbd:	b8 08 00 00 00       	mov    $0x8,%eax
  801bc2:	e8 a3 fd ff ff       	call   80196a <fsipc>
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	57                   	push   %edi
  801bcd:	56                   	push   %esi
  801bce:	53                   	push   %ebx
  801bcf:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801bd5:	6a 00                	push   $0x0
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	e8 45 ff ff ff       	call   801b24 <open>
  801bdf:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	85 c0                	test   %eax,%eax
  801bea:	0f 88 40 03 00 00    	js     801f30 <spawn+0x367>
  801bf0:	89 c7                	mov    %eax,%edi
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	68 00 02 00 00       	push   $0x200
  801bfa:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801c00:	50                   	push   %eax
  801c01:	57                   	push   %edi
  801c02:	e8 3f fb ff ff       	call   801746 <readn>
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	3d 00 02 00 00       	cmp    $0x200,%eax
  801c0f:	75 5d                	jne    801c6e <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  801c11:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801c18:	45 4c 46 
  801c1b:	75 51                	jne    801c6e <spawn+0xa5>
  801c1d:	b8 07 00 00 00       	mov    $0x7,%eax
  801c22:	cd 30                	int    $0x30
  801c24:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801c2a:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801c30:	85 c0                	test   %eax,%eax
  801c32:	0f 88 81 04 00 00    	js     8020b9 <spawn+0x4f0>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801c38:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c3d:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801c40:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801c46:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801c4c:	b9 11 00 00 00       	mov    $0x11,%ecx
  801c51:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801c53:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801c59:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801c5f:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801c64:	be 00 00 00 00       	mov    $0x0,%esi
  801c69:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c6c:	eb 4b                	jmp    801cb9 <spawn+0xf0>
		close(fd);
  801c6e:	83 ec 0c             	sub    $0xc,%esp
  801c71:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801c77:	e8 07 f9 ff ff       	call   801583 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801c7c:	83 c4 0c             	add    $0xc,%esp
  801c7f:	68 7f 45 4c 46       	push   $0x464c457f
  801c84:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801c8a:	68 23 2f 80 00       	push   $0x802f23
  801c8f:	e8 37 e9 ff ff       	call   8005cb <cprintf>
		return -E_NOT_EXEC;
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801c9e:	ff ff ff 
  801ca1:	e9 8a 02 00 00       	jmp    801f30 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801ca6:	83 ec 0c             	sub    $0xc,%esp
  801ca9:	50                   	push   %eax
  801caa:	e8 cf ee ff ff       	call   800b7e <strlen>
  801caf:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801cb3:	83 c3 01             	add    $0x1,%ebx
  801cb6:	83 c4 10             	add    $0x10,%esp
  801cb9:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801cc0:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	75 df                	jne    801ca6 <spawn+0xdd>
  801cc7:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801ccd:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801cd3:	bf 00 10 40 00       	mov    $0x401000,%edi
  801cd8:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801cda:	89 fa                	mov    %edi,%edx
  801cdc:	83 e2 fc             	and    $0xfffffffc,%edx
  801cdf:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ce6:	29 c2                	sub    %eax,%edx
  801ce8:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801cee:	8d 42 f8             	lea    -0x8(%edx),%eax
  801cf1:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801cf6:	0f 86 ce 03 00 00    	jbe    8020ca <spawn+0x501>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	6a 07                	push   $0x7
  801d01:	68 00 00 40 00       	push   $0x400000
  801d06:	6a 00                	push   $0x0
  801d08:	e8 a1 f2 ff ff       	call   800fae <sys_page_alloc>
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	85 c0                	test   %eax,%eax
  801d12:	0f 88 b7 03 00 00    	js     8020cf <spawn+0x506>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801d18:	be 00 00 00 00       	mov    $0x0,%esi
  801d1d:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801d23:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d26:	eb 30                	jmp    801d58 <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  801d28:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801d2e:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801d34:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801d37:	83 ec 08             	sub    $0x8,%esp
  801d3a:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801d3d:	57                   	push   %edi
  801d3e:	e8 72 ee ff ff       	call   800bb5 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801d43:	83 c4 04             	add    $0x4,%esp
  801d46:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801d49:	e8 30 ee ff ff       	call   800b7e <strlen>
  801d4e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801d52:	83 c6 01             	add    $0x1,%esi
  801d55:	83 c4 10             	add    $0x10,%esp
  801d58:	39 b5 88 fd ff ff    	cmp    %esi,-0x278(%ebp)
  801d5e:	7f c8                	jg     801d28 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801d60:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801d66:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801d6c:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801d73:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801d79:	0f 85 8c 00 00 00    	jne    801e0b <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801d7f:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801d85:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801d8b:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801d8e:	89 f8                	mov    %edi,%eax
  801d90:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801d96:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801d99:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801d9e:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801da4:	83 ec 0c             	sub    $0xc,%esp
  801da7:	6a 07                	push   $0x7
  801da9:	68 00 d0 bf ee       	push   $0xeebfd000
  801dae:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801db4:	68 00 00 40 00       	push   $0x400000
  801db9:	6a 00                	push   $0x0
  801dbb:	e8 31 f2 ff ff       	call   800ff1 <sys_page_map>
  801dc0:	89 c3                	mov    %eax,%ebx
  801dc2:	83 c4 20             	add    $0x20,%esp
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	0f 88 78 03 00 00    	js     802145 <spawn+0x57c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801dcd:	83 ec 08             	sub    $0x8,%esp
  801dd0:	68 00 00 40 00       	push   $0x400000
  801dd5:	6a 00                	push   $0x0
  801dd7:	e8 57 f2 ff ff       	call   801033 <sys_page_unmap>
  801ddc:	89 c3                	mov    %eax,%ebx
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	85 c0                	test   %eax,%eax
  801de3:	0f 88 5c 03 00 00    	js     802145 <spawn+0x57c>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801de9:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801def:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801df6:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801dfc:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801e03:	00 00 00 
  801e06:	e9 56 01 00 00       	jmp    801f61 <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801e0b:	68 98 2f 80 00       	push   $0x802f98
  801e10:	68 f7 2e 80 00       	push   $0x802ef7
  801e15:	68 f2 00 00 00       	push   $0xf2
  801e1a:	68 3d 2f 80 00       	push   $0x802f3d
  801e1f:	e8 cc e6 ff ff       	call   8004f0 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e24:	83 ec 04             	sub    $0x4,%esp
  801e27:	6a 07                	push   $0x7
  801e29:	68 00 00 40 00       	push   $0x400000
  801e2e:	6a 00                	push   $0x0
  801e30:	e8 79 f1 ff ff       	call   800fae <sys_page_alloc>
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	0f 88 9a 02 00 00    	js     8020da <spawn+0x511>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801e40:	83 ec 08             	sub    $0x8,%esp
  801e43:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801e49:	01 f0                	add    %esi,%eax
  801e4b:	50                   	push   %eax
  801e4c:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801e52:	e8 b8 f9 ff ff       	call   80180f <seek>
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	0f 88 7f 02 00 00    	js     8020e1 <spawn+0x518>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e6b:	29 f0                	sub    %esi,%eax
  801e6d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e72:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801e77:	0f 47 c1             	cmova  %ecx,%eax
  801e7a:	50                   	push   %eax
  801e7b:	68 00 00 40 00       	push   $0x400000
  801e80:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801e86:	e8 bb f8 ff ff       	call   801746 <readn>
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	0f 88 52 02 00 00    	js     8020e8 <spawn+0x51f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	57                   	push   %edi
  801e9a:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  801ea0:	56                   	push   %esi
  801ea1:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ea7:	68 00 00 40 00       	push   $0x400000
  801eac:	6a 00                	push   $0x0
  801eae:	e8 3e f1 ff ff       	call   800ff1 <sys_page_map>
  801eb3:	83 c4 20             	add    $0x20,%esp
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	0f 88 80 00 00 00    	js     801f3e <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801ebe:	83 ec 08             	sub    $0x8,%esp
  801ec1:	68 00 00 40 00       	push   $0x400000
  801ec6:	6a 00                	push   $0x0
  801ec8:	e8 66 f1 ff ff       	call   801033 <sys_page_unmap>
  801ecd:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801ed0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ed6:	89 de                	mov    %ebx,%esi
  801ed8:	39 9d 88 fd ff ff    	cmp    %ebx,-0x278(%ebp)
  801ede:	76 73                	jbe    801f53 <spawn+0x38a>
		if (i >= filesz) {
  801ee0:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801ee6:	0f 87 38 ff ff ff    	ja     801e24 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801eec:	83 ec 04             	sub    $0x4,%esp
  801eef:	57                   	push   %edi
  801ef0:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  801ef6:	56                   	push   %esi
  801ef7:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801efd:	e8 ac f0 ff ff       	call   800fae <sys_page_alloc>
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	85 c0                	test   %eax,%eax
  801f07:	79 c7                	jns    801ed0 <spawn+0x307>
  801f09:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801f0b:	83 ec 0c             	sub    $0xc,%esp
  801f0e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f14:	e8 16 f0 ff ff       	call   800f2f <sys_env_destroy>
	close(fd);
  801f19:	83 c4 04             	add    $0x4,%esp
  801f1c:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801f22:	e8 5c f6 ff ff       	call   801583 <close>
	return r;
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801f30:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f39:	5b                   	pop    %ebx
  801f3a:	5e                   	pop    %esi
  801f3b:	5f                   	pop    %edi
  801f3c:	5d                   	pop    %ebp
  801f3d:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801f3e:	50                   	push   %eax
  801f3f:	68 49 2f 80 00       	push   $0x802f49
  801f44:	68 25 01 00 00       	push   $0x125
  801f49:	68 3d 2f 80 00       	push   $0x802f3d
  801f4e:	e8 9d e5 ff ff       	call   8004f0 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f53:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801f5a:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801f61:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801f68:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801f6e:	7e 71                	jle    801fe1 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801f70:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801f76:	83 39 01             	cmpl   $0x1,(%ecx)
  801f79:	75 d8                	jne    801f53 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801f7b:	8b 41 18             	mov    0x18(%ecx),%eax
  801f7e:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801f81:	83 f8 01             	cmp    $0x1,%eax
  801f84:	19 ff                	sbb    %edi,%edi
  801f86:	83 e7 fe             	and    $0xfffffffe,%edi
  801f89:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801f8c:	8b 71 04             	mov    0x4(%ecx),%esi
  801f8f:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801f95:	8b 59 10             	mov    0x10(%ecx),%ebx
  801f98:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801f9e:	8b 41 14             	mov    0x14(%ecx),%eax
  801fa1:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801fa7:	8b 51 08             	mov    0x8(%ecx),%edx
  801faa:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	if ((i = PGOFF(va))) {
  801fb0:	89 d0                	mov    %edx,%eax
  801fb2:	25 ff 0f 00 00       	and    $0xfff,%eax
  801fb7:	74 1e                	je     801fd7 <spawn+0x40e>
		va -= i;
  801fb9:	29 c2                	sub    %eax,%edx
  801fbb:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		memsz += i;
  801fc1:	01 85 88 fd ff ff    	add    %eax,-0x278(%ebp)
		filesz += i;
  801fc7:	01 c3                	add    %eax,%ebx
  801fc9:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801fcf:	29 c6                	sub    %eax,%esi
  801fd1:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801fd7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fdc:	e9 f5 fe ff ff       	jmp    801ed6 <spawn+0x30d>
	close(fd);
  801fe1:	83 ec 0c             	sub    $0xc,%esp
  801fe4:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801fea:	e8 94 f5 ff ff       	call   801583 <close>
  801fef:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i, j, pn, r;

        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  801ff2:	bf 02 00 00 00       	mov    $0x2,%edi
  801ff7:	eb 7c                	jmp    802075 <spawn+0x4ac>
  801ff9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
                if (uvpd[i] & PTE_P) {
                        for (j = 0; j < NPTENTRIES; j++) {
  801fff:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  802005:	74 63                	je     80206a <spawn+0x4a1>
                                pn = PGNUM(PGADDR(i, j, 0));
  802007:	89 da                	mov    %ebx,%edx
  802009:	09 f2                	or     %esi,%edx
  80200b:	89 d0                	mov    %edx,%eax
  80200d:	c1 e8 0c             	shr    $0xc,%eax
                                if (pn == PGNUM(UXSTACKTOP - PGSIZE))
  802010:	3d ff eb 0e 00       	cmp    $0xeebff,%eax
  802015:	74 53                	je     80206a <spawn+0x4a1>
                                        break;
                                if ((uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  802017:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  80201e:	f6 c1 01             	test   $0x1,%cl
  802021:	74 d6                	je     801ff9 <spawn+0x430>
  802023:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  80202a:	f6 c5 04             	test   $0x4,%ch
  80202d:	74 ca                	je     801ff9 <spawn+0x430>
                                        if ((r = sys_page_map(0, (void *)PGADDR(i, j, 0), child, (void *)PGADDR(i, j, 0), uvpt[pn] & PTE_SYSCALL)) < 0)
  80202f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802036:	83 ec 0c             	sub    $0xc,%esp
  802039:	25 07 0e 00 00       	and    $0xe07,%eax
  80203e:	50                   	push   %eax
  80203f:	52                   	push   %edx
  802040:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802046:	52                   	push   %edx
  802047:	6a 00                	push   $0x0
  802049:	e8 a3 ef ff ff       	call   800ff1 <sys_page_map>
  80204e:	83 c4 20             	add    $0x20,%esp
  802051:	85 c0                	test   %eax,%eax
  802053:	79 a4                	jns    801ff9 <spawn+0x430>
		panic("copy_shared_pages: %e", r);
  802055:	50                   	push   %eax
  802056:	68 80 2f 80 00       	push   $0x802f80
  80205b:	68 82 00 00 00       	push   $0x82
  802060:	68 3d 2f 80 00       	push   $0x802f3d
  802065:	e8 86 e4 ff ff       	call   8004f0 <_panic>
        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  80206a:	83 c7 01             	add    $0x1,%edi
  80206d:	81 ff bb 03 00 00    	cmp    $0x3bb,%edi
  802073:	74 7a                	je     8020ef <spawn+0x526>
                if (uvpd[i] & PTE_P) {
  802075:	8b 04 bd 00 d0 7b ef 	mov    -0x10843000(,%edi,4),%eax
  80207c:	a8 01                	test   $0x1,%al
  80207e:	74 ea                	je     80206a <spawn+0x4a1>
  802080:	89 fe                	mov    %edi,%esi
  802082:	c1 e6 16             	shl    $0x16,%esi
  802085:	bb 00 00 00 00       	mov    $0x0,%ebx
  80208a:	e9 78 ff ff ff       	jmp    802007 <spawn+0x43e>
		panic("sys_env_set_trapframe: %e", r);
  80208f:	50                   	push   %eax
  802090:	68 66 2f 80 00       	push   $0x802f66
  802095:	68 86 00 00 00       	push   $0x86
  80209a:	68 3d 2f 80 00       	push   $0x802f3d
  80209f:	e8 4c e4 ff ff       	call   8004f0 <_panic>
		panic("sys_env_set_status: %e", r);
  8020a4:	50                   	push   %eax
  8020a5:	68 cd 2d 80 00       	push   $0x802dcd
  8020aa:	68 89 00 00 00       	push   $0x89
  8020af:	68 3d 2f 80 00       	push   $0x802f3d
  8020b4:	e8 37 e4 ff ff       	call   8004f0 <_panic>
		return r;
  8020b9:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8020bf:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8020c5:	e9 66 fe ff ff       	jmp    801f30 <spawn+0x367>
		return -E_NO_MEM;
  8020ca:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  8020cf:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8020d5:	e9 56 fe ff ff       	jmp    801f30 <spawn+0x367>
  8020da:	89 c7                	mov    %eax,%edi
  8020dc:	e9 2a fe ff ff       	jmp    801f0b <spawn+0x342>
  8020e1:	89 c7                	mov    %eax,%edi
  8020e3:	e9 23 fe ff ff       	jmp    801f0b <spawn+0x342>
  8020e8:	89 c7                	mov    %eax,%edi
  8020ea:	e9 1c fe ff ff       	jmp    801f0b <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8020ef:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8020f6:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8020f9:	83 ec 08             	sub    $0x8,%esp
  8020fc:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802102:	50                   	push   %eax
  802103:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802109:	e8 a9 ef ff ff       	call   8010b7 <sys_env_set_trapframe>
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	85 c0                	test   %eax,%eax
  802113:	0f 88 76 ff ff ff    	js     80208f <spawn+0x4c6>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802119:	83 ec 08             	sub    $0x8,%esp
  80211c:	6a 02                	push   $0x2
  80211e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802124:	e8 4c ef ff ff       	call   801075 <sys_env_set_status>
  802129:	83 c4 10             	add    $0x10,%esp
  80212c:	85 c0                	test   %eax,%eax
  80212e:	0f 88 70 ff ff ff    	js     8020a4 <spawn+0x4db>
	return child;
  802134:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80213a:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802140:	e9 eb fd ff ff       	jmp    801f30 <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  802145:	83 ec 08             	sub    $0x8,%esp
  802148:	68 00 00 40 00       	push   $0x400000
  80214d:	6a 00                	push   $0x0
  80214f:	e8 df ee ff ff       	call   801033 <sys_page_unmap>
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  80215d:	e9 ce fd ff ff       	jmp    801f30 <spawn+0x367>

00802162 <spawnl>:
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	57                   	push   %edi
  802166:	56                   	push   %esi
  802167:	53                   	push   %ebx
  802168:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  80216b:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  80216e:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802173:	eb 05                	jmp    80217a <spawnl+0x18>
		argc++;
  802175:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802178:	89 ca                	mov    %ecx,%edx
  80217a:	8d 4a 04             	lea    0x4(%edx),%ecx
  80217d:	83 3a 00             	cmpl   $0x0,(%edx)
  802180:	75 f3                	jne    802175 <spawnl+0x13>
	const char *argv[argc+2];
  802182:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  802189:	83 e2 f0             	and    $0xfffffff0,%edx
  80218c:	29 d4                	sub    %edx,%esp
  80218e:	8d 54 24 03          	lea    0x3(%esp),%edx
  802192:	c1 ea 02             	shr    $0x2,%edx
  802195:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  80219c:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80219e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021a1:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8021a8:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8021af:	00 
	va_start(vl, arg0);
  8021b0:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8021b3:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8021b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ba:	eb 0b                	jmp    8021c7 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  8021bc:	83 c0 01             	add    $0x1,%eax
  8021bf:	8b 39                	mov    (%ecx),%edi
  8021c1:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  8021c4:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  8021c7:	39 d0                	cmp    %edx,%eax
  8021c9:	75 f1                	jne    8021bc <spawnl+0x5a>
	return spawn(prog, argv);
  8021cb:	83 ec 08             	sub    $0x8,%esp
  8021ce:	56                   	push   %esi
  8021cf:	ff 75 08             	pushl  0x8(%ebp)
  8021d2:	e8 f2 f9 ff ff       	call   801bc9 <spawn>
}
  8021d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021da:	5b                   	pop    %ebx
  8021db:	5e                   	pop    %esi
  8021dc:	5f                   	pop    %edi
  8021dd:	5d                   	pop    %ebp
  8021de:	c3                   	ret    

008021df <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	56                   	push   %esi
  8021e3:	53                   	push   %ebx
  8021e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021e7:	83 ec 0c             	sub    $0xc,%esp
  8021ea:	ff 75 08             	pushl  0x8(%ebp)
  8021ed:	e8 f6 f1 ff ff       	call   8013e8 <fd2data>
  8021f2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021f4:	83 c4 08             	add    $0x8,%esp
  8021f7:	68 c0 2f 80 00       	push   $0x802fc0
  8021fc:	53                   	push   %ebx
  8021fd:	e8 b3 e9 ff ff       	call   800bb5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802202:	8b 46 04             	mov    0x4(%esi),%eax
  802205:	2b 06                	sub    (%esi),%eax
  802207:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80220d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802214:	00 00 00 
	stat->st_dev = &devpipe;
  802217:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80221e:	40 80 00 
	return 0;
}
  802221:	b8 00 00 00 00       	mov    $0x0,%eax
  802226:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802229:	5b                   	pop    %ebx
  80222a:	5e                   	pop    %esi
  80222b:	5d                   	pop    %ebp
  80222c:	c3                   	ret    

0080222d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	53                   	push   %ebx
  802231:	83 ec 0c             	sub    $0xc,%esp
  802234:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802237:	53                   	push   %ebx
  802238:	6a 00                	push   $0x0
  80223a:	e8 f4 ed ff ff       	call   801033 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80223f:	89 1c 24             	mov    %ebx,(%esp)
  802242:	e8 a1 f1 ff ff       	call   8013e8 <fd2data>
  802247:	83 c4 08             	add    $0x8,%esp
  80224a:	50                   	push   %eax
  80224b:	6a 00                	push   $0x0
  80224d:	e8 e1 ed ff ff       	call   801033 <sys_page_unmap>
}
  802252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <_pipeisclosed>:
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	57                   	push   %edi
  80225b:	56                   	push   %esi
  80225c:	53                   	push   %ebx
  80225d:	83 ec 1c             	sub    $0x1c,%esp
  802260:	89 c7                	mov    %eax,%edi
  802262:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802264:	a1 04 50 80 00       	mov    0x805004,%eax
  802269:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80226c:	83 ec 0c             	sub    $0xc,%esp
  80226f:	57                   	push   %edi
  802270:	e8 08 04 00 00       	call   80267d <pageref>
  802275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802278:	89 34 24             	mov    %esi,(%esp)
  80227b:	e8 fd 03 00 00       	call   80267d <pageref>
		nn = thisenv->env_runs;
  802280:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802286:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802289:	83 c4 10             	add    $0x10,%esp
  80228c:	39 cb                	cmp    %ecx,%ebx
  80228e:	74 1b                	je     8022ab <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802290:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802293:	75 cf                	jne    802264 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802295:	8b 42 58             	mov    0x58(%edx),%eax
  802298:	6a 01                	push   $0x1
  80229a:	50                   	push   %eax
  80229b:	53                   	push   %ebx
  80229c:	68 c7 2f 80 00       	push   $0x802fc7
  8022a1:	e8 25 e3 ff ff       	call   8005cb <cprintf>
  8022a6:	83 c4 10             	add    $0x10,%esp
  8022a9:	eb b9                	jmp    802264 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8022ab:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022ae:	0f 94 c0             	sete   %al
  8022b1:	0f b6 c0             	movzbl %al,%eax
}
  8022b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022b7:	5b                   	pop    %ebx
  8022b8:	5e                   	pop    %esi
  8022b9:	5f                   	pop    %edi
  8022ba:	5d                   	pop    %ebp
  8022bb:	c3                   	ret    

008022bc <devpipe_write>:
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	57                   	push   %edi
  8022c0:	56                   	push   %esi
  8022c1:	53                   	push   %ebx
  8022c2:	83 ec 28             	sub    $0x28,%esp
  8022c5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8022c8:	56                   	push   %esi
  8022c9:	e8 1a f1 ff ff       	call   8013e8 <fd2data>
  8022ce:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022d0:	83 c4 10             	add    $0x10,%esp
  8022d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022db:	74 4f                	je     80232c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022dd:	8b 43 04             	mov    0x4(%ebx),%eax
  8022e0:	8b 0b                	mov    (%ebx),%ecx
  8022e2:	8d 51 20             	lea    0x20(%ecx),%edx
  8022e5:	39 d0                	cmp    %edx,%eax
  8022e7:	72 14                	jb     8022fd <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8022e9:	89 da                	mov    %ebx,%edx
  8022eb:	89 f0                	mov    %esi,%eax
  8022ed:	e8 65 ff ff ff       	call   802257 <_pipeisclosed>
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	75 3a                	jne    802330 <devpipe_write+0x74>
			sys_yield();
  8022f6:	e8 94 ec ff ff       	call   800f8f <sys_yield>
  8022fb:	eb e0                	jmp    8022dd <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802300:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802304:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802307:	89 c2                	mov    %eax,%edx
  802309:	c1 fa 1f             	sar    $0x1f,%edx
  80230c:	89 d1                	mov    %edx,%ecx
  80230e:	c1 e9 1b             	shr    $0x1b,%ecx
  802311:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802314:	83 e2 1f             	and    $0x1f,%edx
  802317:	29 ca                	sub    %ecx,%edx
  802319:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80231d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802321:	83 c0 01             	add    $0x1,%eax
  802324:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802327:	83 c7 01             	add    $0x1,%edi
  80232a:	eb ac                	jmp    8022d8 <devpipe_write+0x1c>
	return i;
  80232c:	89 f8                	mov    %edi,%eax
  80232e:	eb 05                	jmp    802335 <devpipe_write+0x79>
				return 0;
  802330:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802335:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802338:	5b                   	pop    %ebx
  802339:	5e                   	pop    %esi
  80233a:	5f                   	pop    %edi
  80233b:	5d                   	pop    %ebp
  80233c:	c3                   	ret    

0080233d <devpipe_read>:
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	57                   	push   %edi
  802341:	56                   	push   %esi
  802342:	53                   	push   %ebx
  802343:	83 ec 18             	sub    $0x18,%esp
  802346:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802349:	57                   	push   %edi
  80234a:	e8 99 f0 ff ff       	call   8013e8 <fd2data>
  80234f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802351:	83 c4 10             	add    $0x10,%esp
  802354:	be 00 00 00 00       	mov    $0x0,%esi
  802359:	3b 75 10             	cmp    0x10(%ebp),%esi
  80235c:	74 47                	je     8023a5 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80235e:	8b 03                	mov    (%ebx),%eax
  802360:	3b 43 04             	cmp    0x4(%ebx),%eax
  802363:	75 22                	jne    802387 <devpipe_read+0x4a>
			if (i > 0)
  802365:	85 f6                	test   %esi,%esi
  802367:	75 14                	jne    80237d <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802369:	89 da                	mov    %ebx,%edx
  80236b:	89 f8                	mov    %edi,%eax
  80236d:	e8 e5 fe ff ff       	call   802257 <_pipeisclosed>
  802372:	85 c0                	test   %eax,%eax
  802374:	75 33                	jne    8023a9 <devpipe_read+0x6c>
			sys_yield();
  802376:	e8 14 ec ff ff       	call   800f8f <sys_yield>
  80237b:	eb e1                	jmp    80235e <devpipe_read+0x21>
				return i;
  80237d:	89 f0                	mov    %esi,%eax
}
  80237f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802382:	5b                   	pop    %ebx
  802383:	5e                   	pop    %esi
  802384:	5f                   	pop    %edi
  802385:	5d                   	pop    %ebp
  802386:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802387:	99                   	cltd   
  802388:	c1 ea 1b             	shr    $0x1b,%edx
  80238b:	01 d0                	add    %edx,%eax
  80238d:	83 e0 1f             	and    $0x1f,%eax
  802390:	29 d0                	sub    %edx,%eax
  802392:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802397:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80239a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80239d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8023a0:	83 c6 01             	add    $0x1,%esi
  8023a3:	eb b4                	jmp    802359 <devpipe_read+0x1c>
	return i;
  8023a5:	89 f0                	mov    %esi,%eax
  8023a7:	eb d6                	jmp    80237f <devpipe_read+0x42>
				return 0;
  8023a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ae:	eb cf                	jmp    80237f <devpipe_read+0x42>

008023b0 <pipe>:
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	56                   	push   %esi
  8023b4:	53                   	push   %ebx
  8023b5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8023b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023bb:	50                   	push   %eax
  8023bc:	e8 3e f0 ff ff       	call   8013ff <fd_alloc>
  8023c1:	89 c3                	mov    %eax,%ebx
  8023c3:	83 c4 10             	add    $0x10,%esp
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	78 5b                	js     802425 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023ca:	83 ec 04             	sub    $0x4,%esp
  8023cd:	68 07 04 00 00       	push   $0x407
  8023d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8023d5:	6a 00                	push   $0x0
  8023d7:	e8 d2 eb ff ff       	call   800fae <sys_page_alloc>
  8023dc:	89 c3                	mov    %eax,%ebx
  8023de:	83 c4 10             	add    $0x10,%esp
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	78 40                	js     802425 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8023e5:	83 ec 0c             	sub    $0xc,%esp
  8023e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023eb:	50                   	push   %eax
  8023ec:	e8 0e f0 ff ff       	call   8013ff <fd_alloc>
  8023f1:	89 c3                	mov    %eax,%ebx
  8023f3:	83 c4 10             	add    $0x10,%esp
  8023f6:	85 c0                	test   %eax,%eax
  8023f8:	78 1b                	js     802415 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023fa:	83 ec 04             	sub    $0x4,%esp
  8023fd:	68 07 04 00 00       	push   $0x407
  802402:	ff 75 f0             	pushl  -0x10(%ebp)
  802405:	6a 00                	push   $0x0
  802407:	e8 a2 eb ff ff       	call   800fae <sys_page_alloc>
  80240c:	89 c3                	mov    %eax,%ebx
  80240e:	83 c4 10             	add    $0x10,%esp
  802411:	85 c0                	test   %eax,%eax
  802413:	79 19                	jns    80242e <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802415:	83 ec 08             	sub    $0x8,%esp
  802418:	ff 75 f4             	pushl  -0xc(%ebp)
  80241b:	6a 00                	push   $0x0
  80241d:	e8 11 ec ff ff       	call   801033 <sys_page_unmap>
  802422:	83 c4 10             	add    $0x10,%esp
}
  802425:	89 d8                	mov    %ebx,%eax
  802427:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80242a:	5b                   	pop    %ebx
  80242b:	5e                   	pop    %esi
  80242c:	5d                   	pop    %ebp
  80242d:	c3                   	ret    
	va = fd2data(fd0);
  80242e:	83 ec 0c             	sub    $0xc,%esp
  802431:	ff 75 f4             	pushl  -0xc(%ebp)
  802434:	e8 af ef ff ff       	call   8013e8 <fd2data>
  802439:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243b:	83 c4 0c             	add    $0xc,%esp
  80243e:	68 07 04 00 00       	push   $0x407
  802443:	50                   	push   %eax
  802444:	6a 00                	push   $0x0
  802446:	e8 63 eb ff ff       	call   800fae <sys_page_alloc>
  80244b:	89 c3                	mov    %eax,%ebx
  80244d:	83 c4 10             	add    $0x10,%esp
  802450:	85 c0                	test   %eax,%eax
  802452:	0f 88 8c 00 00 00    	js     8024e4 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802458:	83 ec 0c             	sub    $0xc,%esp
  80245b:	ff 75 f0             	pushl  -0x10(%ebp)
  80245e:	e8 85 ef ff ff       	call   8013e8 <fd2data>
  802463:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80246a:	50                   	push   %eax
  80246b:	6a 00                	push   $0x0
  80246d:	56                   	push   %esi
  80246e:	6a 00                	push   $0x0
  802470:	e8 7c eb ff ff       	call   800ff1 <sys_page_map>
  802475:	89 c3                	mov    %eax,%ebx
  802477:	83 c4 20             	add    $0x20,%esp
  80247a:	85 c0                	test   %eax,%eax
  80247c:	78 58                	js     8024d6 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802487:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802496:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80249c:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80249e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024a8:	83 ec 0c             	sub    $0xc,%esp
  8024ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ae:	e8 25 ef ff ff       	call   8013d8 <fd2num>
  8024b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024b6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024b8:	83 c4 04             	add    $0x4,%esp
  8024bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8024be:	e8 15 ef ff ff       	call   8013d8 <fd2num>
  8024c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024c6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024c9:	83 c4 10             	add    $0x10,%esp
  8024cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024d1:	e9 4f ff ff ff       	jmp    802425 <pipe+0x75>
	sys_page_unmap(0, va);
  8024d6:	83 ec 08             	sub    $0x8,%esp
  8024d9:	56                   	push   %esi
  8024da:	6a 00                	push   $0x0
  8024dc:	e8 52 eb ff ff       	call   801033 <sys_page_unmap>
  8024e1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8024e4:	83 ec 08             	sub    $0x8,%esp
  8024e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8024ea:	6a 00                	push   $0x0
  8024ec:	e8 42 eb ff ff       	call   801033 <sys_page_unmap>
  8024f1:	83 c4 10             	add    $0x10,%esp
  8024f4:	e9 1c ff ff ff       	jmp    802415 <pipe+0x65>

008024f9 <pipeisclosed>:
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802502:	50                   	push   %eax
  802503:	ff 75 08             	pushl  0x8(%ebp)
  802506:	e8 43 ef ff ff       	call   80144e <fd_lookup>
  80250b:	83 c4 10             	add    $0x10,%esp
  80250e:	85 c0                	test   %eax,%eax
  802510:	78 18                	js     80252a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802512:	83 ec 0c             	sub    $0xc,%esp
  802515:	ff 75 f4             	pushl  -0xc(%ebp)
  802518:	e8 cb ee ff ff       	call   8013e8 <fd2data>
	return _pipeisclosed(fd, p);
  80251d:	89 c2                	mov    %eax,%edx
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	e8 30 fd ff ff       	call   802257 <_pipeisclosed>
  802527:	83 c4 10             	add    $0x10,%esp
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	56                   	push   %esi
  802530:	53                   	push   %ebx
  802531:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802534:	85 f6                	test   %esi,%esi
  802536:	74 13                	je     80254b <wait+0x1f>
	e = &envs[ENVX(envid)];
  802538:	89 f3                	mov    %esi,%ebx
  80253a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802540:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802543:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802549:	eb 1b                	jmp    802566 <wait+0x3a>
	assert(envid != 0);
  80254b:	68 df 2f 80 00       	push   $0x802fdf
  802550:	68 f7 2e 80 00       	push   $0x802ef7
  802555:	6a 09                	push   $0x9
  802557:	68 ea 2f 80 00       	push   $0x802fea
  80255c:	e8 8f df ff ff       	call   8004f0 <_panic>
		sys_yield();
  802561:	e8 29 ea ff ff       	call   800f8f <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802566:	8b 43 48             	mov    0x48(%ebx),%eax
  802569:	39 f0                	cmp    %esi,%eax
  80256b:	75 07                	jne    802574 <wait+0x48>
  80256d:	8b 43 54             	mov    0x54(%ebx),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	75 ed                	jne    802561 <wait+0x35>
}
  802574:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802577:	5b                   	pop    %ebx
  802578:	5e                   	pop    %esi
  802579:	5d                   	pop    %ebp
  80257a:	c3                   	ret    

0080257b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	53                   	push   %ebx
  80257f:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  802582:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802589:	74 0d                	je     802598 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802596:	c9                   	leave  
  802597:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  802598:	e8 d3 e9 ff ff       	call   800f70 <sys_getenvid>
  80259d:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  80259f:	83 ec 04             	sub    $0x4,%esp
  8025a2:	6a 07                	push   $0x7
  8025a4:	68 00 f0 bf ee       	push   $0xeebff000
  8025a9:	50                   	push   %eax
  8025aa:	e8 ff e9 ff ff       	call   800fae <sys_page_alloc>
        	if (r < 0) {
  8025af:	83 c4 10             	add    $0x10,%esp
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	78 27                	js     8025dd <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  8025b6:	83 ec 08             	sub    $0x8,%esp
  8025b9:	68 ef 25 80 00       	push   $0x8025ef
  8025be:	53                   	push   %ebx
  8025bf:	e8 35 eb ff ff       	call   8010f9 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  8025c4:	83 c4 10             	add    $0x10,%esp
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	79 c0                	jns    80258b <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  8025cb:	50                   	push   %eax
  8025cc:	68 f5 2f 80 00       	push   $0x802ff5
  8025d1:	6a 28                	push   $0x28
  8025d3:	68 09 30 80 00       	push   $0x803009
  8025d8:	e8 13 df ff ff       	call   8004f0 <_panic>
            		panic("pgfault_handler: %e", r);
  8025dd:	50                   	push   %eax
  8025de:	68 f5 2f 80 00       	push   $0x802ff5
  8025e3:	6a 24                	push   $0x24
  8025e5:	68 09 30 80 00       	push   $0x803009
  8025ea:	e8 01 df ff ff       	call   8004f0 <_panic>

008025ef <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025ef:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025f0:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8025f5:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025f7:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  8025fa:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  8025fe:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  802601:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  802605:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  802609:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80260c:	83 c4 08             	add    $0x8,%esp
	popal
  80260f:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  802610:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  802613:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  802614:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  802615:	c3                   	ret    

00802616 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  80261c:	68 17 30 80 00       	push   $0x803017
  802621:	6a 1a                	push   $0x1a
  802623:	68 30 30 80 00       	push   $0x803030
  802628:	e8 c3 de ff ff       	call   8004f0 <_panic>

0080262d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
  802630:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  802633:	68 3a 30 80 00       	push   $0x80303a
  802638:	6a 2a                	push   $0x2a
  80263a:	68 30 30 80 00       	push   $0x803030
  80263f:	e8 ac de ff ff       	call   8004f0 <_panic>

00802644 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80264a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80264f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802652:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802658:	8b 52 50             	mov    0x50(%edx),%edx
  80265b:	39 ca                	cmp    %ecx,%edx
  80265d:	74 11                	je     802670 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80265f:	83 c0 01             	add    $0x1,%eax
  802662:	3d 00 04 00 00       	cmp    $0x400,%eax
  802667:	75 e6                	jne    80264f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
  80266e:	eb 0b                	jmp    80267b <ipc_find_env+0x37>
			return envs[i].env_id;
  802670:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802673:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802678:	8b 40 48             	mov    0x48(%eax),%eax
}
  80267b:	5d                   	pop    %ebp
  80267c:	c3                   	ret    

0080267d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80267d:	55                   	push   %ebp
  80267e:	89 e5                	mov    %esp,%ebp
  802680:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802683:	89 d0                	mov    %edx,%eax
  802685:	c1 e8 16             	shr    $0x16,%eax
  802688:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80268f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802694:	f6 c1 01             	test   $0x1,%cl
  802697:	74 1d                	je     8026b6 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802699:	c1 ea 0c             	shr    $0xc,%edx
  80269c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8026a3:	f6 c2 01             	test   $0x1,%dl
  8026a6:	74 0e                	je     8026b6 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026a8:	c1 ea 0c             	shr    $0xc,%edx
  8026ab:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8026b2:	ef 
  8026b3:	0f b7 c0             	movzwl %ax,%eax
}
  8026b6:	5d                   	pop    %ebp
  8026b7:	c3                   	ret    
  8026b8:	66 90                	xchg   %ax,%ax
  8026ba:	66 90                	xchg   %ax,%ax
  8026bc:	66 90                	xchg   %ax,%ax
  8026be:	66 90                	xchg   %ax,%ax

008026c0 <__udivdi3>:
  8026c0:	55                   	push   %ebp
  8026c1:	57                   	push   %edi
  8026c2:	56                   	push   %esi
  8026c3:	53                   	push   %ebx
  8026c4:	83 ec 1c             	sub    $0x1c,%esp
  8026c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8026cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8026cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8026d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8026d7:	85 d2                	test   %edx,%edx
  8026d9:	75 35                	jne    802710 <__udivdi3+0x50>
  8026db:	39 f3                	cmp    %esi,%ebx
  8026dd:	0f 87 bd 00 00 00    	ja     8027a0 <__udivdi3+0xe0>
  8026e3:	85 db                	test   %ebx,%ebx
  8026e5:	89 d9                	mov    %ebx,%ecx
  8026e7:	75 0b                	jne    8026f4 <__udivdi3+0x34>
  8026e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ee:	31 d2                	xor    %edx,%edx
  8026f0:	f7 f3                	div    %ebx
  8026f2:	89 c1                	mov    %eax,%ecx
  8026f4:	31 d2                	xor    %edx,%edx
  8026f6:	89 f0                	mov    %esi,%eax
  8026f8:	f7 f1                	div    %ecx
  8026fa:	89 c6                	mov    %eax,%esi
  8026fc:	89 e8                	mov    %ebp,%eax
  8026fe:	89 f7                	mov    %esi,%edi
  802700:	f7 f1                	div    %ecx
  802702:	89 fa                	mov    %edi,%edx
  802704:	83 c4 1c             	add    $0x1c,%esp
  802707:	5b                   	pop    %ebx
  802708:	5e                   	pop    %esi
  802709:	5f                   	pop    %edi
  80270a:	5d                   	pop    %ebp
  80270b:	c3                   	ret    
  80270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802710:	39 f2                	cmp    %esi,%edx
  802712:	77 7c                	ja     802790 <__udivdi3+0xd0>
  802714:	0f bd fa             	bsr    %edx,%edi
  802717:	83 f7 1f             	xor    $0x1f,%edi
  80271a:	0f 84 98 00 00 00    	je     8027b8 <__udivdi3+0xf8>
  802720:	89 f9                	mov    %edi,%ecx
  802722:	b8 20 00 00 00       	mov    $0x20,%eax
  802727:	29 f8                	sub    %edi,%eax
  802729:	d3 e2                	shl    %cl,%edx
  80272b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80272f:	89 c1                	mov    %eax,%ecx
  802731:	89 da                	mov    %ebx,%edx
  802733:	d3 ea                	shr    %cl,%edx
  802735:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802739:	09 d1                	or     %edx,%ecx
  80273b:	89 f2                	mov    %esi,%edx
  80273d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802741:	89 f9                	mov    %edi,%ecx
  802743:	d3 e3                	shl    %cl,%ebx
  802745:	89 c1                	mov    %eax,%ecx
  802747:	d3 ea                	shr    %cl,%edx
  802749:	89 f9                	mov    %edi,%ecx
  80274b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80274f:	d3 e6                	shl    %cl,%esi
  802751:	89 eb                	mov    %ebp,%ebx
  802753:	89 c1                	mov    %eax,%ecx
  802755:	d3 eb                	shr    %cl,%ebx
  802757:	09 de                	or     %ebx,%esi
  802759:	89 f0                	mov    %esi,%eax
  80275b:	f7 74 24 08          	divl   0x8(%esp)
  80275f:	89 d6                	mov    %edx,%esi
  802761:	89 c3                	mov    %eax,%ebx
  802763:	f7 64 24 0c          	mull   0xc(%esp)
  802767:	39 d6                	cmp    %edx,%esi
  802769:	72 0c                	jb     802777 <__udivdi3+0xb7>
  80276b:	89 f9                	mov    %edi,%ecx
  80276d:	d3 e5                	shl    %cl,%ebp
  80276f:	39 c5                	cmp    %eax,%ebp
  802771:	73 5d                	jae    8027d0 <__udivdi3+0x110>
  802773:	39 d6                	cmp    %edx,%esi
  802775:	75 59                	jne    8027d0 <__udivdi3+0x110>
  802777:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80277a:	31 ff                	xor    %edi,%edi
  80277c:	89 fa                	mov    %edi,%edx
  80277e:	83 c4 1c             	add    $0x1c,%esp
  802781:	5b                   	pop    %ebx
  802782:	5e                   	pop    %esi
  802783:	5f                   	pop    %edi
  802784:	5d                   	pop    %ebp
  802785:	c3                   	ret    
  802786:	8d 76 00             	lea    0x0(%esi),%esi
  802789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802790:	31 ff                	xor    %edi,%edi
  802792:	31 c0                	xor    %eax,%eax
  802794:	89 fa                	mov    %edi,%edx
  802796:	83 c4 1c             	add    $0x1c,%esp
  802799:	5b                   	pop    %ebx
  80279a:	5e                   	pop    %esi
  80279b:	5f                   	pop    %edi
  80279c:	5d                   	pop    %ebp
  80279d:	c3                   	ret    
  80279e:	66 90                	xchg   %ax,%ax
  8027a0:	31 ff                	xor    %edi,%edi
  8027a2:	89 e8                	mov    %ebp,%eax
  8027a4:	89 f2                	mov    %esi,%edx
  8027a6:	f7 f3                	div    %ebx
  8027a8:	89 fa                	mov    %edi,%edx
  8027aa:	83 c4 1c             	add    $0x1c,%esp
  8027ad:	5b                   	pop    %ebx
  8027ae:	5e                   	pop    %esi
  8027af:	5f                   	pop    %edi
  8027b0:	5d                   	pop    %ebp
  8027b1:	c3                   	ret    
  8027b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027b8:	39 f2                	cmp    %esi,%edx
  8027ba:	72 06                	jb     8027c2 <__udivdi3+0x102>
  8027bc:	31 c0                	xor    %eax,%eax
  8027be:	39 eb                	cmp    %ebp,%ebx
  8027c0:	77 d2                	ja     802794 <__udivdi3+0xd4>
  8027c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c7:	eb cb                	jmp    802794 <__udivdi3+0xd4>
  8027c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027d0:	89 d8                	mov    %ebx,%eax
  8027d2:	31 ff                	xor    %edi,%edi
  8027d4:	eb be                	jmp    802794 <__udivdi3+0xd4>
  8027d6:	66 90                	xchg   %ax,%ax
  8027d8:	66 90                	xchg   %ax,%ax
  8027da:	66 90                	xchg   %ax,%ax
  8027dc:	66 90                	xchg   %ax,%ax
  8027de:	66 90                	xchg   %ax,%ax

008027e0 <__umoddi3>:
  8027e0:	55                   	push   %ebp
  8027e1:	57                   	push   %edi
  8027e2:	56                   	push   %esi
  8027e3:	53                   	push   %ebx
  8027e4:	83 ec 1c             	sub    $0x1c,%esp
  8027e7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8027eb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8027ef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8027f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027f7:	85 ed                	test   %ebp,%ebp
  8027f9:	89 f0                	mov    %esi,%eax
  8027fb:	89 da                	mov    %ebx,%edx
  8027fd:	75 19                	jne    802818 <__umoddi3+0x38>
  8027ff:	39 df                	cmp    %ebx,%edi
  802801:	0f 86 b1 00 00 00    	jbe    8028b8 <__umoddi3+0xd8>
  802807:	f7 f7                	div    %edi
  802809:	89 d0                	mov    %edx,%eax
  80280b:	31 d2                	xor    %edx,%edx
  80280d:	83 c4 1c             	add    $0x1c,%esp
  802810:	5b                   	pop    %ebx
  802811:	5e                   	pop    %esi
  802812:	5f                   	pop    %edi
  802813:	5d                   	pop    %ebp
  802814:	c3                   	ret    
  802815:	8d 76 00             	lea    0x0(%esi),%esi
  802818:	39 dd                	cmp    %ebx,%ebp
  80281a:	77 f1                	ja     80280d <__umoddi3+0x2d>
  80281c:	0f bd cd             	bsr    %ebp,%ecx
  80281f:	83 f1 1f             	xor    $0x1f,%ecx
  802822:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802826:	0f 84 b4 00 00 00    	je     8028e0 <__umoddi3+0x100>
  80282c:	b8 20 00 00 00       	mov    $0x20,%eax
  802831:	89 c2                	mov    %eax,%edx
  802833:	8b 44 24 04          	mov    0x4(%esp),%eax
  802837:	29 c2                	sub    %eax,%edx
  802839:	89 c1                	mov    %eax,%ecx
  80283b:	89 f8                	mov    %edi,%eax
  80283d:	d3 e5                	shl    %cl,%ebp
  80283f:	89 d1                	mov    %edx,%ecx
  802841:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802845:	d3 e8                	shr    %cl,%eax
  802847:	09 c5                	or     %eax,%ebp
  802849:	8b 44 24 04          	mov    0x4(%esp),%eax
  80284d:	89 c1                	mov    %eax,%ecx
  80284f:	d3 e7                	shl    %cl,%edi
  802851:	89 d1                	mov    %edx,%ecx
  802853:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802857:	89 df                	mov    %ebx,%edi
  802859:	d3 ef                	shr    %cl,%edi
  80285b:	89 c1                	mov    %eax,%ecx
  80285d:	89 f0                	mov    %esi,%eax
  80285f:	d3 e3                	shl    %cl,%ebx
  802861:	89 d1                	mov    %edx,%ecx
  802863:	89 fa                	mov    %edi,%edx
  802865:	d3 e8                	shr    %cl,%eax
  802867:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80286c:	09 d8                	or     %ebx,%eax
  80286e:	f7 f5                	div    %ebp
  802870:	d3 e6                	shl    %cl,%esi
  802872:	89 d1                	mov    %edx,%ecx
  802874:	f7 64 24 08          	mull   0x8(%esp)
  802878:	39 d1                	cmp    %edx,%ecx
  80287a:	89 c3                	mov    %eax,%ebx
  80287c:	89 d7                	mov    %edx,%edi
  80287e:	72 06                	jb     802886 <__umoddi3+0xa6>
  802880:	75 0e                	jne    802890 <__umoddi3+0xb0>
  802882:	39 c6                	cmp    %eax,%esi
  802884:	73 0a                	jae    802890 <__umoddi3+0xb0>
  802886:	2b 44 24 08          	sub    0x8(%esp),%eax
  80288a:	19 ea                	sbb    %ebp,%edx
  80288c:	89 d7                	mov    %edx,%edi
  80288e:	89 c3                	mov    %eax,%ebx
  802890:	89 ca                	mov    %ecx,%edx
  802892:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802897:	29 de                	sub    %ebx,%esi
  802899:	19 fa                	sbb    %edi,%edx
  80289b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80289f:	89 d0                	mov    %edx,%eax
  8028a1:	d3 e0                	shl    %cl,%eax
  8028a3:	89 d9                	mov    %ebx,%ecx
  8028a5:	d3 ee                	shr    %cl,%esi
  8028a7:	d3 ea                	shr    %cl,%edx
  8028a9:	09 f0                	or     %esi,%eax
  8028ab:	83 c4 1c             	add    $0x1c,%esp
  8028ae:	5b                   	pop    %ebx
  8028af:	5e                   	pop    %esi
  8028b0:	5f                   	pop    %edi
  8028b1:	5d                   	pop    %ebp
  8028b2:	c3                   	ret    
  8028b3:	90                   	nop
  8028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028b8:	85 ff                	test   %edi,%edi
  8028ba:	89 f9                	mov    %edi,%ecx
  8028bc:	75 0b                	jne    8028c9 <__umoddi3+0xe9>
  8028be:	b8 01 00 00 00       	mov    $0x1,%eax
  8028c3:	31 d2                	xor    %edx,%edx
  8028c5:	f7 f7                	div    %edi
  8028c7:	89 c1                	mov    %eax,%ecx
  8028c9:	89 d8                	mov    %ebx,%eax
  8028cb:	31 d2                	xor    %edx,%edx
  8028cd:	f7 f1                	div    %ecx
  8028cf:	89 f0                	mov    %esi,%eax
  8028d1:	f7 f1                	div    %ecx
  8028d3:	e9 31 ff ff ff       	jmp    802809 <__umoddi3+0x29>
  8028d8:	90                   	nop
  8028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028e0:	39 dd                	cmp    %ebx,%ebp
  8028e2:	72 08                	jb     8028ec <__umoddi3+0x10c>
  8028e4:	39 f7                	cmp    %esi,%edi
  8028e6:	0f 87 21 ff ff ff    	ja     80280d <__umoddi3+0x2d>
  8028ec:	89 da                	mov    %ebx,%edx
  8028ee:	89 f0                	mov    %esi,%eax
  8028f0:	29 f8                	sub    %edi,%eax
  8028f2:	19 ea                	sbb    %ebp,%edx
  8028f4:	e9 14 ff ff ff       	jmp    80280d <__umoddi3+0x2d>
