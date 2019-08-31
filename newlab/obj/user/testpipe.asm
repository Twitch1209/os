
obj/user/testpipe.debug：     文件格式 elf32-i386


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
  80002c:	e8 a5 02 00 00       	call   8002d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 30 80 00 c0 	movl   $0x8022c0,0x803004
  800042:	22 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	e8 92 1b 00 00       	call   801be0 <pipe>
  80004e:	89 c6                	mov    %eax,%esi
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	0f 88 1f 01 00 00    	js     80017a <umain+0x147>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005b:	e8 9c 0f 00 00       	call   800ffc <fork>
  800060:	89 c3                	mov    %eax,%ebx
  800062:	85 c0                	test   %eax,%eax
  800064:	0f 88 22 01 00 00    	js     80018c <umain+0x159>
		panic("fork: %e", i);

	if (pid == 0) {
  80006a:	85 c0                	test   %eax,%eax
  80006c:	0f 85 58 01 00 00    	jne    8001ca <umain+0x197>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800072:	a1 04 40 80 00       	mov    0x804004,%eax
  800077:	8b 40 48             	mov    0x48(%eax),%eax
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	ff 75 90             	pushl  -0x70(%ebp)
  800080:	50                   	push   %eax
  800081:	68 ee 22 80 00       	push   $0x8022ee
  800086:	e8 86 03 00 00       	call   800411 <cprintf>
		close(p[1]);
  80008b:	83 c4 04             	add    $0x4,%esp
  80008e:	ff 75 90             	pushl  -0x70(%ebp)
  800091:	e8 33 13 00 00       	call   8013c9 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800096:	a1 04 40 80 00       	mov    0x804004,%eax
  80009b:	8b 40 48             	mov    0x48(%eax),%eax
  80009e:	83 c4 0c             	add    $0xc,%esp
  8000a1:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a4:	50                   	push   %eax
  8000a5:	68 0b 23 80 00       	push   $0x80230b
  8000aa:	e8 62 03 00 00       	call   800411 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000af:	83 c4 0c             	add    $0xc,%esp
  8000b2:	6a 63                	push   $0x63
  8000b4:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b7:	50                   	push   %eax
  8000b8:	ff 75 8c             	pushl  -0x74(%ebp)
  8000bb:	e8 cc 14 00 00       	call   80158c <readn>
  8000c0:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	85 c0                	test   %eax,%eax
  8000c7:	0f 88 d1 00 00 00    	js     80019e <umain+0x16b>
			panic("read: %e", i);
		buf[i] = 0;
  8000cd:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	ff 35 00 30 80 00    	pushl  0x803000
  8000db:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000de:	50                   	push   %eax
  8000df:	e8 bd 09 00 00       	call   800aa1 <strcmp>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	85 c0                	test   %eax,%eax
  8000e9:	0f 85 c1 00 00 00    	jne    8001b0 <umain+0x17d>
			cprintf("\npipe read closed properly\n");
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 31 23 80 00       	push   $0x802331
  8000f7:	e8 15 03 00 00       	call   800411 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  8000ff:	e8 18 02 00 00       	call   80031c <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	53                   	push   %ebx
  800108:	e8 4f 1c 00 00       	call   801d5c <wait>

	binaryname = "pipewriteeof";
  80010d:	c7 05 04 30 80 00 87 	movl   $0x802387,0x803004
  800114:	23 80 00 
	if ((i = pipe(p)) < 0)
  800117:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80011a:	89 04 24             	mov    %eax,(%esp)
  80011d:	e8 be 1a 00 00       	call   801be0 <pipe>
  800122:	89 c6                	mov    %eax,%esi
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	85 c0                	test   %eax,%eax
  800129:	0f 88 34 01 00 00    	js     800263 <umain+0x230>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80012f:	e8 c8 0e 00 00       	call   800ffc <fork>
  800134:	89 c3                	mov    %eax,%ebx
  800136:	85 c0                	test   %eax,%eax
  800138:	0f 88 37 01 00 00    	js     800275 <umain+0x242>
		panic("fork: %e", i);

	if (pid == 0) {
  80013e:	85 c0                	test   %eax,%eax
  800140:	0f 84 41 01 00 00    	je     800287 <umain+0x254>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 8c             	pushl  -0x74(%ebp)
  80014c:	e8 78 12 00 00       	call   8013c9 <close>
	close(p[1]);
  800151:	83 c4 04             	add    $0x4,%esp
  800154:	ff 75 90             	pushl  -0x70(%ebp)
  800157:	e8 6d 12 00 00       	call   8013c9 <close>
	wait(pid);
  80015c:	89 1c 24             	mov    %ebx,(%esp)
  80015f:	e8 f8 1b 00 00       	call   801d5c <wait>

	cprintf("pipe tests passed\n");
  800164:	c7 04 24 b5 23 80 00 	movl   $0x8023b5,(%esp)
  80016b:	e8 a1 02 00 00       	call   800411 <cprintf>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
		panic("pipe: %e", i);
  80017a:	50                   	push   %eax
  80017b:	68 cc 22 80 00       	push   $0x8022cc
  800180:	6a 0e                	push   $0xe
  800182:	68 d5 22 80 00       	push   $0x8022d5
  800187:	e8 aa 01 00 00       	call   800336 <_panic>
		panic("fork: %e", i);
  80018c:	56                   	push   %esi
  80018d:	68 e5 22 80 00       	push   $0x8022e5
  800192:	6a 11                	push   $0x11
  800194:	68 d5 22 80 00       	push   $0x8022d5
  800199:	e8 98 01 00 00       	call   800336 <_panic>
			panic("read: %e", i);
  80019e:	50                   	push   %eax
  80019f:	68 28 23 80 00       	push   $0x802328
  8001a4:	6a 19                	push   $0x19
  8001a6:	68 d5 22 80 00       	push   $0x8022d5
  8001ab:	e8 86 01 00 00       	call   800336 <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	56                   	push   %esi
  8001b8:	68 4d 23 80 00       	push   $0x80234d
  8001bd:	e8 4f 02 00 00       	call   800411 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	e9 35 ff ff ff       	jmp    8000ff <umain+0xcc>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001ca:	a1 04 40 80 00       	mov    0x804004,%eax
  8001cf:	8b 40 48             	mov    0x48(%eax),%eax
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d8:	50                   	push   %eax
  8001d9:	68 ee 22 80 00       	push   $0x8022ee
  8001de:	e8 2e 02 00 00       	call   800411 <cprintf>
		close(p[0]);
  8001e3:	83 c4 04             	add    $0x4,%esp
  8001e6:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e9:	e8 db 11 00 00       	call   8013c9 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ee:	a1 04 40 80 00       	mov    0x804004,%eax
  8001f3:	8b 40 48             	mov    0x48(%eax),%eax
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	ff 75 90             	pushl  -0x70(%ebp)
  8001fc:	50                   	push   %eax
  8001fd:	68 60 23 80 00       	push   $0x802360
  800202:	e8 0a 02 00 00       	call   800411 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800207:	83 c4 04             	add    $0x4,%esp
  80020a:	ff 35 00 30 80 00    	pushl  0x803000
  800210:	e8 af 07 00 00       	call   8009c4 <strlen>
  800215:	83 c4 0c             	add    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	ff 35 00 30 80 00    	pushl  0x803000
  80021f:	ff 75 90             	pushl  -0x70(%ebp)
  800222:	e8 ac 13 00 00       	call   8015d3 <write>
  800227:	89 c6                	mov    %eax,%esi
  800229:	83 c4 04             	add    $0x4,%esp
  80022c:	ff 35 00 30 80 00    	pushl  0x803000
  800232:	e8 8d 07 00 00       	call   8009c4 <strlen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	39 f0                	cmp    %esi,%eax
  80023c:	75 13                	jne    800251 <umain+0x21e>
		close(p[1]);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 90             	pushl  -0x70(%ebp)
  800244:	e8 80 11 00 00       	call   8013c9 <close>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	e9 b3 fe ff ff       	jmp    800104 <umain+0xd1>
			panic("write: %e", i);
  800251:	56                   	push   %esi
  800252:	68 7d 23 80 00       	push   $0x80237d
  800257:	6a 25                	push   $0x25
  800259:	68 d5 22 80 00       	push   $0x8022d5
  80025e:	e8 d3 00 00 00       	call   800336 <_panic>
		panic("pipe: %e", i);
  800263:	50                   	push   %eax
  800264:	68 cc 22 80 00       	push   $0x8022cc
  800269:	6a 2c                	push   $0x2c
  80026b:	68 d5 22 80 00       	push   $0x8022d5
  800270:	e8 c1 00 00 00       	call   800336 <_panic>
		panic("fork: %e", i);
  800275:	56                   	push   %esi
  800276:	68 e5 22 80 00       	push   $0x8022e5
  80027b:	6a 2f                	push   $0x2f
  80027d:	68 d5 22 80 00       	push   $0x8022d5
  800282:	e8 af 00 00 00       	call   800336 <_panic>
		close(p[0]);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 8c             	pushl  -0x74(%ebp)
  80028d:	e8 37 11 00 00       	call   8013c9 <close>
  800292:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 94 23 80 00       	push   $0x802394
  80029d:	e8 6f 01 00 00       	call   800411 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002a2:	83 c4 0c             	add    $0xc,%esp
  8002a5:	6a 01                	push   $0x1
  8002a7:	68 96 23 80 00       	push   $0x802396
  8002ac:	ff 75 90             	pushl  -0x70(%ebp)
  8002af:	e8 1f 13 00 00       	call   8015d3 <write>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	83 f8 01             	cmp    $0x1,%eax
  8002ba:	74 d9                	je     800295 <umain+0x262>
		cprintf("\npipe write closed properly\n");
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 23 80 00       	push   $0x802398
  8002c4:	e8 48 01 00 00       	call   800411 <cprintf>
		exit();
  8002c9:	e8 4e 00 00 00       	call   80031c <exit>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	e9 70 fe ff ff       	jmp    800146 <umain+0x113>

008002d6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002de:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e1:	e8 d0 0a 00 00       	call   800db6 <sys_getenvid>
  8002e6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002eb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f3:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	85 db                	test   %ebx,%ebx
  8002fa:	7e 07                	jle    800303 <libmain+0x2d>
		binaryname = argv[0];
  8002fc:	8b 06                	mov    (%esi),%eax
  8002fe:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	e8 26 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80030d:	e8 0a 00 00 00       	call   80031c <exit>
}
  800312:	83 c4 10             	add    $0x10,%esp
  800315:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800318:	5b                   	pop    %ebx
  800319:	5e                   	pop    %esi
  80031a:	5d                   	pop    %ebp
  80031b:	c3                   	ret    

0080031c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800322:	e8 cd 10 00 00       	call   8013f4 <close_all>
	sys_env_destroy(0);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	6a 00                	push   $0x0
  80032c:	e8 44 0a 00 00       	call   800d75 <sys_env_destroy>
}
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	c9                   	leave  
  800335:	c3                   	ret    

00800336 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	56                   	push   %esi
  80033a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80033b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80033e:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800344:	e8 6d 0a 00 00       	call   800db6 <sys_getenvid>
  800349:	83 ec 0c             	sub    $0xc,%esp
  80034c:	ff 75 0c             	pushl  0xc(%ebp)
  80034f:	ff 75 08             	pushl  0x8(%ebp)
  800352:	56                   	push   %esi
  800353:	50                   	push   %eax
  800354:	68 18 24 80 00       	push   $0x802418
  800359:	e8 b3 00 00 00       	call   800411 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80035e:	83 c4 18             	add    $0x18,%esp
  800361:	53                   	push   %ebx
  800362:	ff 75 10             	pushl  0x10(%ebp)
  800365:	e8 56 00 00 00       	call   8003c0 <vcprintf>
	cprintf("\n");
  80036a:	c7 04 24 09 23 80 00 	movl   $0x802309,(%esp)
  800371:	e8 9b 00 00 00       	call   800411 <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800379:	cc                   	int3   
  80037a:	eb fd                	jmp    800379 <_panic+0x43>

0080037c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	53                   	push   %ebx
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800386:	8b 13                	mov    (%ebx),%edx
  800388:	8d 42 01             	lea    0x1(%edx),%eax
  80038b:	89 03                	mov    %eax,(%ebx)
  80038d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800390:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800394:	3d ff 00 00 00       	cmp    $0xff,%eax
  800399:	74 09                	je     8003a4 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80039b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80039f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a2:	c9                   	leave  
  8003a3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	68 ff 00 00 00       	push   $0xff
  8003ac:	8d 43 08             	lea    0x8(%ebx),%eax
  8003af:	50                   	push   %eax
  8003b0:	e8 83 09 00 00       	call   800d38 <sys_cputs>
		b->idx = 0;
  8003b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	eb db                	jmp    80039b <putch+0x1f>

008003c0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d0:	00 00 00 
	b.cnt = 0;
  8003d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003da:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003dd:	ff 75 0c             	pushl  0xc(%ebp)
  8003e0:	ff 75 08             	pushl  0x8(%ebp)
  8003e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e9:	50                   	push   %eax
  8003ea:	68 7c 03 80 00       	push   $0x80037c
  8003ef:	e8 1a 01 00 00       	call   80050e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003f4:	83 c4 08             	add    $0x8,%esp
  8003f7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003fd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800403:	50                   	push   %eax
  800404:	e8 2f 09 00 00       	call   800d38 <sys_cputs>

	return b.cnt;
}
  800409:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80040f:	c9                   	leave  
  800410:	c3                   	ret    

00800411 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800411:	55                   	push   %ebp
  800412:	89 e5                	mov    %esp,%ebp
  800414:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800417:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80041a:	50                   	push   %eax
  80041b:	ff 75 08             	pushl  0x8(%ebp)
  80041e:	e8 9d ff ff ff       	call   8003c0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800423:	c9                   	leave  
  800424:	c3                   	ret    

00800425 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800425:	55                   	push   %ebp
  800426:	89 e5                	mov    %esp,%ebp
  800428:	57                   	push   %edi
  800429:	56                   	push   %esi
  80042a:	53                   	push   %ebx
  80042b:	83 ec 1c             	sub    $0x1c,%esp
  80042e:	89 c7                	mov    %eax,%edi
  800430:	89 d6                	mov    %edx,%esi
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	8b 55 0c             	mov    0xc(%ebp),%edx
  800438:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80043b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80043e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800441:	bb 00 00 00 00       	mov    $0x0,%ebx
  800446:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800449:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80044c:	39 d3                	cmp    %edx,%ebx
  80044e:	72 05                	jb     800455 <printnum+0x30>
  800450:	39 45 10             	cmp    %eax,0x10(%ebp)
  800453:	77 7a                	ja     8004cf <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	ff 75 18             	pushl  0x18(%ebp)
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800461:	53                   	push   %ebx
  800462:	ff 75 10             	pushl  0x10(%ebp)
  800465:	83 ec 08             	sub    $0x8,%esp
  800468:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046b:	ff 75 e0             	pushl  -0x20(%ebp)
  80046e:	ff 75 dc             	pushl  -0x24(%ebp)
  800471:	ff 75 d8             	pushl  -0x28(%ebp)
  800474:	e8 f7 1b 00 00       	call   802070 <__udivdi3>
  800479:	83 c4 18             	add    $0x18,%esp
  80047c:	52                   	push   %edx
  80047d:	50                   	push   %eax
  80047e:	89 f2                	mov    %esi,%edx
  800480:	89 f8                	mov    %edi,%eax
  800482:	e8 9e ff ff ff       	call   800425 <printnum>
  800487:	83 c4 20             	add    $0x20,%esp
  80048a:	eb 13                	jmp    80049f <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	56                   	push   %esi
  800490:	ff 75 18             	pushl  0x18(%ebp)
  800493:	ff d7                	call   *%edi
  800495:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800498:	83 eb 01             	sub    $0x1,%ebx
  80049b:	85 db                	test   %ebx,%ebx
  80049d:	7f ed                	jg     80048c <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	56                   	push   %esi
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8004af:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b2:	e8 d9 1c 00 00       	call   802190 <__umoddi3>
  8004b7:	83 c4 14             	add    $0x14,%esp
  8004ba:	0f be 80 3b 24 80 00 	movsbl 0x80243b(%eax),%eax
  8004c1:	50                   	push   %eax
  8004c2:	ff d7                	call   *%edi
}
  8004c4:	83 c4 10             	add    $0x10,%esp
  8004c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ca:	5b                   	pop    %ebx
  8004cb:	5e                   	pop    %esi
  8004cc:	5f                   	pop    %edi
  8004cd:	5d                   	pop    %ebp
  8004ce:	c3                   	ret    
  8004cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004d2:	eb c4                	jmp    800498 <printnum+0x73>

008004d4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004da:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004de:	8b 10                	mov    (%eax),%edx
  8004e0:	3b 50 04             	cmp    0x4(%eax),%edx
  8004e3:	73 0a                	jae    8004ef <sprintputch+0x1b>
		*b->buf++ = ch;
  8004e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004e8:	89 08                	mov    %ecx,(%eax)
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	88 02                	mov    %al,(%edx)
}
  8004ef:	5d                   	pop    %ebp
  8004f0:	c3                   	ret    

008004f1 <printfmt>:
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004f7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004fa:	50                   	push   %eax
  8004fb:	ff 75 10             	pushl  0x10(%ebp)
  8004fe:	ff 75 0c             	pushl  0xc(%ebp)
  800501:	ff 75 08             	pushl  0x8(%ebp)
  800504:	e8 05 00 00 00       	call   80050e <vprintfmt>
}
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	c9                   	leave  
  80050d:	c3                   	ret    

0080050e <vprintfmt>:
{
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	57                   	push   %edi
  800512:	56                   	push   %esi
  800513:	53                   	push   %ebx
  800514:	83 ec 2c             	sub    $0x2c,%esp
  800517:	8b 75 08             	mov    0x8(%ebp),%esi
  80051a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80051d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800520:	e9 8c 03 00 00       	jmp    8008b1 <vprintfmt+0x3a3>
		padc = ' ';
  800525:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800529:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800530:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800537:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80053e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800543:	8d 47 01             	lea    0x1(%edi),%eax
  800546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800549:	0f b6 17             	movzbl (%edi),%edx
  80054c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80054f:	3c 55                	cmp    $0x55,%al
  800551:	0f 87 dd 03 00 00    	ja     800934 <vprintfmt+0x426>
  800557:	0f b6 c0             	movzbl %al,%eax
  80055a:	ff 24 85 80 25 80 00 	jmp    *0x802580(,%eax,4)
  800561:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800564:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800568:	eb d9                	jmp    800543 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80056a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80056d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800571:	eb d0                	jmp    800543 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800573:	0f b6 d2             	movzbl %dl,%edx
  800576:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800579:	b8 00 00 00 00       	mov    $0x0,%eax
  80057e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800581:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800584:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800588:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80058b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80058e:	83 f9 09             	cmp    $0x9,%ecx
  800591:	77 55                	ja     8005e8 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800593:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800596:	eb e9                	jmp    800581 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8d 40 04             	lea    0x4(%eax),%eax
  8005a6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b0:	79 91                	jns    800543 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005bf:	eb 82                	jmp    800543 <vprintfmt+0x35>
  8005c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	0f 49 d0             	cmovns %eax,%edx
  8005ce:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005d4:	e9 6a ff ff ff       	jmp    800543 <vprintfmt+0x35>
  8005d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005dc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005e3:	e9 5b ff ff ff       	jmp    800543 <vprintfmt+0x35>
  8005e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ee:	eb bc                	jmp    8005ac <vprintfmt+0x9e>
			lflag++;
  8005f0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f6:	e9 48 ff ff ff       	jmp    800543 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8d 78 04             	lea    0x4(%eax),%edi
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	53                   	push   %ebx
  800605:	ff 30                	pushl  (%eax)
  800607:	ff d6                	call   *%esi
			break;
  800609:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80060c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80060f:	e9 9a 02 00 00       	jmp    8008ae <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8d 78 04             	lea    0x4(%eax),%edi
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	99                   	cltd   
  80061d:	31 d0                	xor    %edx,%eax
  80061f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800621:	83 f8 0f             	cmp    $0xf,%eax
  800624:	7f 23                	jg     800649 <vprintfmt+0x13b>
  800626:	8b 14 85 e0 26 80 00 	mov    0x8026e0(,%eax,4),%edx
  80062d:	85 d2                	test   %edx,%edx
  80062f:	74 18                	je     800649 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800631:	52                   	push   %edx
  800632:	68 cd 28 80 00       	push   $0x8028cd
  800637:	53                   	push   %ebx
  800638:	56                   	push   %esi
  800639:	e8 b3 fe ff ff       	call   8004f1 <printfmt>
  80063e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800641:	89 7d 14             	mov    %edi,0x14(%ebp)
  800644:	e9 65 02 00 00       	jmp    8008ae <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800649:	50                   	push   %eax
  80064a:	68 53 24 80 00       	push   $0x802453
  80064f:	53                   	push   %ebx
  800650:	56                   	push   %esi
  800651:	e8 9b fe ff ff       	call   8004f1 <printfmt>
  800656:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800659:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80065c:	e9 4d 02 00 00       	jmp    8008ae <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	83 c0 04             	add    $0x4,%eax
  800667:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80066f:	85 ff                	test   %edi,%edi
  800671:	b8 4c 24 80 00       	mov    $0x80244c,%eax
  800676:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800679:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067d:	0f 8e bd 00 00 00    	jle    800740 <vprintfmt+0x232>
  800683:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800687:	75 0e                	jne    800697 <vprintfmt+0x189>
  800689:	89 75 08             	mov    %esi,0x8(%ebp)
  80068c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80068f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800692:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800695:	eb 6d                	jmp    800704 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 d0             	pushl  -0x30(%ebp)
  80069d:	57                   	push   %edi
  80069e:	e8 39 03 00 00       	call   8009dc <strnlen>
  8006a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006a6:	29 c1                	sub    %eax,%ecx
  8006a8:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8006ab:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006ae:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006b8:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ba:	eb 0f                	jmp    8006cb <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c5:	83 ef 01             	sub    $0x1,%edi
  8006c8:	83 c4 10             	add    $0x10,%esp
  8006cb:	85 ff                	test   %edi,%edi
  8006cd:	7f ed                	jg     8006bc <vprintfmt+0x1ae>
  8006cf:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006d2:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006d5:	85 c9                	test   %ecx,%ecx
  8006d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006dc:	0f 49 c1             	cmovns %ecx,%eax
  8006df:	29 c1                	sub    %eax,%ecx
  8006e1:	89 75 08             	mov    %esi,0x8(%ebp)
  8006e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006e7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006ea:	89 cb                	mov    %ecx,%ebx
  8006ec:	eb 16                	jmp    800704 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006f2:	75 31                	jne    800725 <vprintfmt+0x217>
					putch(ch, putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 0c             	pushl  0xc(%ebp)
  8006fa:	50                   	push   %eax
  8006fb:	ff 55 08             	call   *0x8(%ebp)
  8006fe:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800701:	83 eb 01             	sub    $0x1,%ebx
  800704:	83 c7 01             	add    $0x1,%edi
  800707:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80070b:	0f be c2             	movsbl %dl,%eax
  80070e:	85 c0                	test   %eax,%eax
  800710:	74 59                	je     80076b <vprintfmt+0x25d>
  800712:	85 f6                	test   %esi,%esi
  800714:	78 d8                	js     8006ee <vprintfmt+0x1e0>
  800716:	83 ee 01             	sub    $0x1,%esi
  800719:	79 d3                	jns    8006ee <vprintfmt+0x1e0>
  80071b:	89 df                	mov    %ebx,%edi
  80071d:	8b 75 08             	mov    0x8(%ebp),%esi
  800720:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800723:	eb 37                	jmp    80075c <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800725:	0f be d2             	movsbl %dl,%edx
  800728:	83 ea 20             	sub    $0x20,%edx
  80072b:	83 fa 5e             	cmp    $0x5e,%edx
  80072e:	76 c4                	jbe    8006f4 <vprintfmt+0x1e6>
					putch('?', putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	6a 3f                	push   $0x3f
  800738:	ff 55 08             	call   *0x8(%ebp)
  80073b:	83 c4 10             	add    $0x10,%esp
  80073e:	eb c1                	jmp    800701 <vprintfmt+0x1f3>
  800740:	89 75 08             	mov    %esi,0x8(%ebp)
  800743:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800746:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800749:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80074c:	eb b6                	jmp    800704 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 20                	push   $0x20
  800754:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800756:	83 ef 01             	sub    $0x1,%edi
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	85 ff                	test   %edi,%edi
  80075e:	7f ee                	jg     80074e <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800760:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
  800766:	e9 43 01 00 00       	jmp    8008ae <vprintfmt+0x3a0>
  80076b:	89 df                	mov    %ebx,%edi
  80076d:	8b 75 08             	mov    0x8(%ebp),%esi
  800770:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800773:	eb e7                	jmp    80075c <vprintfmt+0x24e>
	if (lflag >= 2)
  800775:	83 f9 01             	cmp    $0x1,%ecx
  800778:	7e 3f                	jle    8007b9 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 50 04             	mov    0x4(%eax),%edx
  800780:	8b 00                	mov    (%eax),%eax
  800782:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800785:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 40 08             	lea    0x8(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800791:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800795:	79 5c                	jns    8007f3 <vprintfmt+0x2e5>
				putch('-', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	53                   	push   %ebx
  80079b:	6a 2d                	push   $0x2d
  80079d:	ff d6                	call   *%esi
				num = -(long long) num;
  80079f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007a5:	f7 da                	neg    %edx
  8007a7:	83 d1 00             	adc    $0x0,%ecx
  8007aa:	f7 d9                	neg    %ecx
  8007ac:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b4:	e9 db 00 00 00       	jmp    800894 <vprintfmt+0x386>
	else if (lflag)
  8007b9:	85 c9                	test   %ecx,%ecx
  8007bb:	75 1b                	jne    8007d8 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c5:	89 c1                	mov    %eax,%ecx
  8007c7:	c1 f9 1f             	sar    $0x1f,%ecx
  8007ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8d 40 04             	lea    0x4(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d6:	eb b9                	jmp    800791 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e0:	89 c1                	mov    %eax,%ecx
  8007e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8007e5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8d 40 04             	lea    0x4(%eax),%eax
  8007ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f1:	eb 9e                	jmp    800791 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007f6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007f9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fe:	e9 91 00 00 00       	jmp    800894 <vprintfmt+0x386>
	if (lflag >= 2)
  800803:	83 f9 01             	cmp    $0x1,%ecx
  800806:	7e 15                	jle    80081d <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 10                	mov    (%eax),%edx
  80080d:	8b 48 04             	mov    0x4(%eax),%ecx
  800810:	8d 40 08             	lea    0x8(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800816:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081b:	eb 77                	jmp    800894 <vprintfmt+0x386>
	else if (lflag)
  80081d:	85 c9                	test   %ecx,%ecx
  80081f:	75 17                	jne    800838 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	8b 10                	mov    (%eax),%edx
  800826:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082b:	8d 40 04             	lea    0x4(%eax),%eax
  80082e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800831:	b8 0a 00 00 00       	mov    $0xa,%eax
  800836:	eb 5c                	jmp    800894 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8b 10                	mov    (%eax),%edx
  80083d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800842:	8d 40 04             	lea    0x4(%eax),%eax
  800845:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800848:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084d:	eb 45                	jmp    800894 <vprintfmt+0x386>
			putch('X', putdat);
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	53                   	push   %ebx
  800853:	6a 58                	push   $0x58
  800855:	ff d6                	call   *%esi
			putch('X', putdat);
  800857:	83 c4 08             	add    $0x8,%esp
  80085a:	53                   	push   %ebx
  80085b:	6a 58                	push   $0x58
  80085d:	ff d6                	call   *%esi
			putch('X', putdat);
  80085f:	83 c4 08             	add    $0x8,%esp
  800862:	53                   	push   %ebx
  800863:	6a 58                	push   $0x58
  800865:	ff d6                	call   *%esi
			break;
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	eb 42                	jmp    8008ae <vprintfmt+0x3a0>
			putch('0', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	53                   	push   %ebx
  800870:	6a 30                	push   $0x30
  800872:	ff d6                	call   *%esi
			putch('x', putdat);
  800874:	83 c4 08             	add    $0x8,%esp
  800877:	53                   	push   %ebx
  800878:	6a 78                	push   $0x78
  80087a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8b 10                	mov    (%eax),%edx
  800881:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800886:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800889:	8d 40 04             	lea    0x4(%eax),%eax
  80088c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80088f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800894:	83 ec 0c             	sub    $0xc,%esp
  800897:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80089b:	57                   	push   %edi
  80089c:	ff 75 e0             	pushl  -0x20(%ebp)
  80089f:	50                   	push   %eax
  8008a0:	51                   	push   %ecx
  8008a1:	52                   	push   %edx
  8008a2:	89 da                	mov    %ebx,%edx
  8008a4:	89 f0                	mov    %esi,%eax
  8008a6:	e8 7a fb ff ff       	call   800425 <printnum>
			break;
  8008ab:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b1:	83 c7 01             	add    $0x1,%edi
  8008b4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008b8:	83 f8 25             	cmp    $0x25,%eax
  8008bb:	0f 84 64 fc ff ff    	je     800525 <vprintfmt+0x17>
			if (ch == '\0')
  8008c1:	85 c0                	test   %eax,%eax
  8008c3:	0f 84 8b 00 00 00    	je     800954 <vprintfmt+0x446>
			putch(ch, putdat);
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	53                   	push   %ebx
  8008cd:	50                   	push   %eax
  8008ce:	ff d6                	call   *%esi
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	eb dc                	jmp    8008b1 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8008d5:	83 f9 01             	cmp    $0x1,%ecx
  8008d8:	7e 15                	jle    8008ef <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	8b 10                	mov    (%eax),%edx
  8008df:	8b 48 04             	mov    0x4(%eax),%ecx
  8008e2:	8d 40 08             	lea    0x8(%eax),%eax
  8008e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e8:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ed:	eb a5                	jmp    800894 <vprintfmt+0x386>
	else if (lflag)
  8008ef:	85 c9                	test   %ecx,%ecx
  8008f1:	75 17                	jne    80090a <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	8b 10                	mov    (%eax),%edx
  8008f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008fd:	8d 40 04             	lea    0x4(%eax),%eax
  800900:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800903:	b8 10 00 00 00       	mov    $0x10,%eax
  800908:	eb 8a                	jmp    800894 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	8b 10                	mov    (%eax),%edx
  80090f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800914:	8d 40 04             	lea    0x4(%eax),%eax
  800917:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091a:	b8 10 00 00 00       	mov    $0x10,%eax
  80091f:	e9 70 ff ff ff       	jmp    800894 <vprintfmt+0x386>
			putch(ch, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	53                   	push   %ebx
  800928:	6a 25                	push   $0x25
  80092a:	ff d6                	call   *%esi
			break;
  80092c:	83 c4 10             	add    $0x10,%esp
  80092f:	e9 7a ff ff ff       	jmp    8008ae <vprintfmt+0x3a0>
			putch('%', putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	53                   	push   %ebx
  800938:	6a 25                	push   $0x25
  80093a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80093c:	83 c4 10             	add    $0x10,%esp
  80093f:	89 f8                	mov    %edi,%eax
  800941:	eb 03                	jmp    800946 <vprintfmt+0x438>
  800943:	83 e8 01             	sub    $0x1,%eax
  800946:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80094a:	75 f7                	jne    800943 <vprintfmt+0x435>
  80094c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80094f:	e9 5a ff ff ff       	jmp    8008ae <vprintfmt+0x3a0>
}
  800954:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800957:	5b                   	pop    %ebx
  800958:	5e                   	pop    %esi
  800959:	5f                   	pop    %edi
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 18             	sub    $0x18,%esp
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800968:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80096b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80096f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800979:	85 c0                	test   %eax,%eax
  80097b:	74 26                	je     8009a3 <vsnprintf+0x47>
  80097d:	85 d2                	test   %edx,%edx
  80097f:	7e 22                	jle    8009a3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800981:	ff 75 14             	pushl  0x14(%ebp)
  800984:	ff 75 10             	pushl  0x10(%ebp)
  800987:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80098a:	50                   	push   %eax
  80098b:	68 d4 04 80 00       	push   $0x8004d4
  800990:	e8 79 fb ff ff       	call   80050e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800998:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80099b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80099e:	83 c4 10             	add    $0x10,%esp
}
  8009a1:	c9                   	leave  
  8009a2:	c3                   	ret    
		return -E_INVAL;
  8009a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009a8:	eb f7                	jmp    8009a1 <vsnprintf+0x45>

008009aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009b0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 10             	pushl  0x10(%ebp)
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	ff 75 08             	pushl  0x8(%ebp)
  8009bd:	e8 9a ff ff ff       	call   80095c <vsnprintf>
	va_end(ap);

	return rc;
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cf:	eb 03                	jmp    8009d4 <strlen+0x10>
		n++;
  8009d1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8009d4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009d8:	75 f7                	jne    8009d1 <strlen+0xd>
	return n;
}
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ea:	eb 03                	jmp    8009ef <strnlen+0x13>
		n++;
  8009ec:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ef:	39 d0                	cmp    %edx,%eax
  8009f1:	74 06                	je     8009f9 <strnlen+0x1d>
  8009f3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009f7:	75 f3                	jne    8009ec <strnlen+0x10>
	return n;
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	53                   	push   %ebx
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a05:	89 c2                	mov    %eax,%edx
  800a07:	83 c1 01             	add    $0x1,%ecx
  800a0a:	83 c2 01             	add    $0x1,%edx
  800a0d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a11:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a14:	84 db                	test   %bl,%bl
  800a16:	75 ef                	jne    800a07 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a18:	5b                   	pop    %ebx
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	53                   	push   %ebx
  800a1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a22:	53                   	push   %ebx
  800a23:	e8 9c ff ff ff       	call   8009c4 <strlen>
  800a28:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	01 d8                	add    %ebx,%eax
  800a30:	50                   	push   %eax
  800a31:	e8 c5 ff ff ff       	call   8009fb <strcpy>
	return dst;
}
  800a36:	89 d8                	mov    %ebx,%eax
  800a38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	8b 75 08             	mov    0x8(%ebp),%esi
  800a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a48:	89 f3                	mov    %esi,%ebx
  800a4a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a4d:	89 f2                	mov    %esi,%edx
  800a4f:	eb 0f                	jmp    800a60 <strncpy+0x23>
		*dst++ = *src;
  800a51:	83 c2 01             	add    $0x1,%edx
  800a54:	0f b6 01             	movzbl (%ecx),%eax
  800a57:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a5a:	80 39 01             	cmpb   $0x1,(%ecx)
  800a5d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a60:	39 da                	cmp    %ebx,%edx
  800a62:	75 ed                	jne    800a51 <strncpy+0x14>
	}
	return ret;
}
  800a64:	89 f0                	mov    %esi,%eax
  800a66:	5b                   	pop    %ebx
  800a67:	5e                   	pop    %esi
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	56                   	push   %esi
  800a6e:	53                   	push   %ebx
  800a6f:	8b 75 08             	mov    0x8(%ebp),%esi
  800a72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a78:	89 f0                	mov    %esi,%eax
  800a7a:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a7e:	85 c9                	test   %ecx,%ecx
  800a80:	75 0b                	jne    800a8d <strlcpy+0x23>
  800a82:	eb 17                	jmp    800a9b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a84:	83 c2 01             	add    $0x1,%edx
  800a87:	83 c0 01             	add    $0x1,%eax
  800a8a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a8d:	39 d8                	cmp    %ebx,%eax
  800a8f:	74 07                	je     800a98 <strlcpy+0x2e>
  800a91:	0f b6 0a             	movzbl (%edx),%ecx
  800a94:	84 c9                	test   %cl,%cl
  800a96:	75 ec                	jne    800a84 <strlcpy+0x1a>
		*dst = '\0';
  800a98:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a9b:	29 f0                	sub    %esi,%eax
}
  800a9d:	5b                   	pop    %ebx
  800a9e:	5e                   	pop    %esi
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aaa:	eb 06                	jmp    800ab2 <strcmp+0x11>
		p++, q++;
  800aac:	83 c1 01             	add    $0x1,%ecx
  800aaf:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800ab2:	0f b6 01             	movzbl (%ecx),%eax
  800ab5:	84 c0                	test   %al,%al
  800ab7:	74 04                	je     800abd <strcmp+0x1c>
  800ab9:	3a 02                	cmp    (%edx),%al
  800abb:	74 ef                	je     800aac <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800abd:	0f b6 c0             	movzbl %al,%eax
  800ac0:	0f b6 12             	movzbl (%edx),%edx
  800ac3:	29 d0                	sub    %edx,%eax
}
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	53                   	push   %ebx
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad1:	89 c3                	mov    %eax,%ebx
  800ad3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ad6:	eb 06                	jmp    800ade <strncmp+0x17>
		n--, p++, q++;
  800ad8:	83 c0 01             	add    $0x1,%eax
  800adb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ade:	39 d8                	cmp    %ebx,%eax
  800ae0:	74 16                	je     800af8 <strncmp+0x31>
  800ae2:	0f b6 08             	movzbl (%eax),%ecx
  800ae5:	84 c9                	test   %cl,%cl
  800ae7:	74 04                	je     800aed <strncmp+0x26>
  800ae9:	3a 0a                	cmp    (%edx),%cl
  800aeb:	74 eb                	je     800ad8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aed:	0f b6 00             	movzbl (%eax),%eax
  800af0:	0f b6 12             	movzbl (%edx),%edx
  800af3:	29 d0                	sub    %edx,%eax
}
  800af5:	5b                   	pop    %ebx
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    
		return 0;
  800af8:	b8 00 00 00 00       	mov    $0x0,%eax
  800afd:	eb f6                	jmp    800af5 <strncmp+0x2e>

00800aff <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b09:	0f b6 10             	movzbl (%eax),%edx
  800b0c:	84 d2                	test   %dl,%dl
  800b0e:	74 09                	je     800b19 <strchr+0x1a>
		if (*s == c)
  800b10:	38 ca                	cmp    %cl,%dl
  800b12:	74 0a                	je     800b1e <strchr+0x1f>
	for (; *s; s++)
  800b14:	83 c0 01             	add    $0x1,%eax
  800b17:	eb f0                	jmp    800b09 <strchr+0xa>
			return (char *) s;
	return 0;
  800b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    

00800b20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b2a:	eb 03                	jmp    800b2f <strfind+0xf>
  800b2c:	83 c0 01             	add    $0x1,%eax
  800b2f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b32:	38 ca                	cmp    %cl,%dl
  800b34:	74 04                	je     800b3a <strfind+0x1a>
  800b36:	84 d2                	test   %dl,%dl
  800b38:	75 f2                	jne    800b2c <strfind+0xc>
			break;
	return (char *) s;
}
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	57                   	push   %edi
  800b40:	56                   	push   %esi
  800b41:	53                   	push   %ebx
  800b42:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b45:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b48:	85 c9                	test   %ecx,%ecx
  800b4a:	74 13                	je     800b5f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b4c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b52:	75 05                	jne    800b59 <memset+0x1d>
  800b54:	f6 c1 03             	test   $0x3,%cl
  800b57:	74 0d                	je     800b66 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5c:	fc                   	cld    
  800b5d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b5f:	89 f8                	mov    %edi,%eax
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    
		c &= 0xFF;
  800b66:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b6a:	89 d3                	mov    %edx,%ebx
  800b6c:	c1 e3 08             	shl    $0x8,%ebx
  800b6f:	89 d0                	mov    %edx,%eax
  800b71:	c1 e0 18             	shl    $0x18,%eax
  800b74:	89 d6                	mov    %edx,%esi
  800b76:	c1 e6 10             	shl    $0x10,%esi
  800b79:	09 f0                	or     %esi,%eax
  800b7b:	09 c2                	or     %eax,%edx
  800b7d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b7f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b82:	89 d0                	mov    %edx,%eax
  800b84:	fc                   	cld    
  800b85:	f3 ab                	rep stos %eax,%es:(%edi)
  800b87:	eb d6                	jmp    800b5f <memset+0x23>

00800b89 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	57                   	push   %edi
  800b8d:	56                   	push   %esi
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b94:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b97:	39 c6                	cmp    %eax,%esi
  800b99:	73 35                	jae    800bd0 <memmove+0x47>
  800b9b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b9e:	39 c2                	cmp    %eax,%edx
  800ba0:	76 2e                	jbe    800bd0 <memmove+0x47>
		s += n;
		d += n;
  800ba2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ba5:	89 d6                	mov    %edx,%esi
  800ba7:	09 fe                	or     %edi,%esi
  800ba9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800baf:	74 0c                	je     800bbd <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bb1:	83 ef 01             	sub    $0x1,%edi
  800bb4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bb7:	fd                   	std    
  800bb8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bba:	fc                   	cld    
  800bbb:	eb 21                	jmp    800bde <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bbd:	f6 c1 03             	test   $0x3,%cl
  800bc0:	75 ef                	jne    800bb1 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bc2:	83 ef 04             	sub    $0x4,%edi
  800bc5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bc8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bcb:	fd                   	std    
  800bcc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bce:	eb ea                	jmp    800bba <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd0:	89 f2                	mov    %esi,%edx
  800bd2:	09 c2                	or     %eax,%edx
  800bd4:	f6 c2 03             	test   $0x3,%dl
  800bd7:	74 09                	je     800be2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bd9:	89 c7                	mov    %eax,%edi
  800bdb:	fc                   	cld    
  800bdc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bde:	5e                   	pop    %esi
  800bdf:	5f                   	pop    %edi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be2:	f6 c1 03             	test   $0x3,%cl
  800be5:	75 f2                	jne    800bd9 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800be7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bea:	89 c7                	mov    %eax,%edi
  800bec:	fc                   	cld    
  800bed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bef:	eb ed                	jmp    800bde <memmove+0x55>

00800bf1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800bf4:	ff 75 10             	pushl  0x10(%ebp)
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	ff 75 08             	pushl  0x8(%ebp)
  800bfd:	e8 87 ff ff ff       	call   800b89 <memmove>
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0f:	89 c6                	mov    %eax,%esi
  800c11:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c14:	39 f0                	cmp    %esi,%eax
  800c16:	74 1c                	je     800c34 <memcmp+0x30>
		if (*s1 != *s2)
  800c18:	0f b6 08             	movzbl (%eax),%ecx
  800c1b:	0f b6 1a             	movzbl (%edx),%ebx
  800c1e:	38 d9                	cmp    %bl,%cl
  800c20:	75 08                	jne    800c2a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c22:	83 c0 01             	add    $0x1,%eax
  800c25:	83 c2 01             	add    $0x1,%edx
  800c28:	eb ea                	jmp    800c14 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c2a:	0f b6 c1             	movzbl %cl,%eax
  800c2d:	0f b6 db             	movzbl %bl,%ebx
  800c30:	29 d8                	sub    %ebx,%eax
  800c32:	eb 05                	jmp    800c39 <memcmp+0x35>
	}

	return 0;
  800c34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c39:	5b                   	pop    %ebx
  800c3a:	5e                   	pop    %esi
  800c3b:	5d                   	pop    %ebp
  800c3c:	c3                   	ret    

00800c3d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c46:	89 c2                	mov    %eax,%edx
  800c48:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c4b:	39 d0                	cmp    %edx,%eax
  800c4d:	73 09                	jae    800c58 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c4f:	38 08                	cmp    %cl,(%eax)
  800c51:	74 05                	je     800c58 <memfind+0x1b>
	for (; s < ends; s++)
  800c53:	83 c0 01             	add    $0x1,%eax
  800c56:	eb f3                	jmp    800c4b <memfind+0xe>
			break;
	return (void *) s;
}
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	57                   	push   %edi
  800c5e:	56                   	push   %esi
  800c5f:	53                   	push   %ebx
  800c60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c66:	eb 03                	jmp    800c6b <strtol+0x11>
		s++;
  800c68:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c6b:	0f b6 01             	movzbl (%ecx),%eax
  800c6e:	3c 20                	cmp    $0x20,%al
  800c70:	74 f6                	je     800c68 <strtol+0xe>
  800c72:	3c 09                	cmp    $0x9,%al
  800c74:	74 f2                	je     800c68 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c76:	3c 2b                	cmp    $0x2b,%al
  800c78:	74 2e                	je     800ca8 <strtol+0x4e>
	int neg = 0;
  800c7a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c7f:	3c 2d                	cmp    $0x2d,%al
  800c81:	74 2f                	je     800cb2 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c83:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c89:	75 05                	jne    800c90 <strtol+0x36>
  800c8b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c8e:	74 2c                	je     800cbc <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c90:	85 db                	test   %ebx,%ebx
  800c92:	75 0a                	jne    800c9e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c94:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800c99:	80 39 30             	cmpb   $0x30,(%ecx)
  800c9c:	74 28                	je     800cc6 <strtol+0x6c>
		base = 10;
  800c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ca6:	eb 50                	jmp    800cf8 <strtol+0x9e>
		s++;
  800ca8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cab:	bf 00 00 00 00       	mov    $0x0,%edi
  800cb0:	eb d1                	jmp    800c83 <strtol+0x29>
		s++, neg = 1;
  800cb2:	83 c1 01             	add    $0x1,%ecx
  800cb5:	bf 01 00 00 00       	mov    $0x1,%edi
  800cba:	eb c7                	jmp    800c83 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cbc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cc0:	74 0e                	je     800cd0 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800cc2:	85 db                	test   %ebx,%ebx
  800cc4:	75 d8                	jne    800c9e <strtol+0x44>
		s++, base = 8;
  800cc6:	83 c1 01             	add    $0x1,%ecx
  800cc9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cce:	eb ce                	jmp    800c9e <strtol+0x44>
		s += 2, base = 16;
  800cd0:	83 c1 02             	add    $0x2,%ecx
  800cd3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cd8:	eb c4                	jmp    800c9e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cda:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cdd:	89 f3                	mov    %esi,%ebx
  800cdf:	80 fb 19             	cmp    $0x19,%bl
  800ce2:	77 29                	ja     800d0d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ce4:	0f be d2             	movsbl %dl,%edx
  800ce7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cea:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ced:	7d 30                	jge    800d1f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800cef:	83 c1 01             	add    $0x1,%ecx
  800cf2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cf6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cf8:	0f b6 11             	movzbl (%ecx),%edx
  800cfb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cfe:	89 f3                	mov    %esi,%ebx
  800d00:	80 fb 09             	cmp    $0x9,%bl
  800d03:	77 d5                	ja     800cda <strtol+0x80>
			dig = *s - '0';
  800d05:	0f be d2             	movsbl %dl,%edx
  800d08:	83 ea 30             	sub    $0x30,%edx
  800d0b:	eb dd                	jmp    800cea <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800d0d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d10:	89 f3                	mov    %esi,%ebx
  800d12:	80 fb 19             	cmp    $0x19,%bl
  800d15:	77 08                	ja     800d1f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d17:	0f be d2             	movsbl %dl,%edx
  800d1a:	83 ea 37             	sub    $0x37,%edx
  800d1d:	eb cb                	jmp    800cea <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d23:	74 05                	je     800d2a <strtol+0xd0>
		*endptr = (char *) s;
  800d25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d28:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d2a:	89 c2                	mov    %eax,%edx
  800d2c:	f7 da                	neg    %edx
  800d2e:	85 ff                	test   %edi,%edi
  800d30:	0f 45 c2             	cmovne %edx,%eax
}
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	57                   	push   %edi
  800d3c:	56                   	push   %esi
  800d3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d43:	8b 55 08             	mov    0x8(%ebp),%edx
  800d46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d49:	89 c3                	mov    %eax,%ebx
  800d4b:	89 c7                	mov    %eax,%edi
  800d4d:	89 c6                	mov    %eax,%esi
  800d4f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5f                   	pop    %edi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	57                   	push   %edi
  800d5a:	56                   	push   %esi
  800d5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d61:	b8 01 00 00 00       	mov    $0x1,%eax
  800d66:	89 d1                	mov    %edx,%ecx
  800d68:	89 d3                	mov    %edx,%ebx
  800d6a:	89 d7                	mov    %edx,%edi
  800d6c:	89 d6                	mov    %edx,%esi
  800d6e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	b8 03 00 00 00       	mov    $0x3,%eax
  800d8b:	89 cb                	mov    %ecx,%ebx
  800d8d:	89 cf                	mov    %ecx,%edi
  800d8f:	89 ce                	mov    %ecx,%esi
  800d91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d93:	85 c0                	test   %eax,%eax
  800d95:	7f 08                	jg     800d9f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9f:	83 ec 0c             	sub    $0xc,%esp
  800da2:	50                   	push   %eax
  800da3:	6a 03                	push   $0x3
  800da5:	68 3f 27 80 00       	push   $0x80273f
  800daa:	6a 23                	push   $0x23
  800dac:	68 5c 27 80 00       	push   $0x80275c
  800db1:	e8 80 f5 ff ff       	call   800336 <_panic>

00800db6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc1:	b8 02 00 00 00       	mov    $0x2,%eax
  800dc6:	89 d1                	mov    %edx,%ecx
  800dc8:	89 d3                	mov    %edx,%ebx
  800dca:	89 d7                	mov    %edx,%edi
  800dcc:	89 d6                	mov    %edx,%esi
  800dce:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    

00800dd5 <sys_yield>:

void
sys_yield(void)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	57                   	push   %edi
  800dd9:	56                   	push   %esi
  800dda:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ddb:	ba 00 00 00 00       	mov    $0x0,%edx
  800de0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800de5:	89 d1                	mov    %edx,%ecx
  800de7:	89 d3                	mov    %edx,%ebx
  800de9:	89 d7                	mov    %edx,%edi
  800deb:	89 d6                	mov    %edx,%esi
  800ded:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800def:	5b                   	pop    %ebx
  800df0:	5e                   	pop    %esi
  800df1:	5f                   	pop    %edi
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
  800dfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfd:	be 00 00 00 00       	mov    $0x0,%esi
  800e02:	8b 55 08             	mov    0x8(%ebp),%edx
  800e05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e08:	b8 04 00 00 00       	mov    $0x4,%eax
  800e0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e10:	89 f7                	mov    %esi,%edi
  800e12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e14:	85 c0                	test   %eax,%eax
  800e16:	7f 08                	jg     800e20 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e20:	83 ec 0c             	sub    $0xc,%esp
  800e23:	50                   	push   %eax
  800e24:	6a 04                	push   $0x4
  800e26:	68 3f 27 80 00       	push   $0x80273f
  800e2b:	6a 23                	push   $0x23
  800e2d:	68 5c 27 80 00       	push   $0x80275c
  800e32:	e8 ff f4 ff ff       	call   800336 <_panic>

00800e37 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
  800e3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e46:	b8 05 00 00 00       	mov    $0x5,%eax
  800e4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e4e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e51:	8b 75 18             	mov    0x18(%ebp),%esi
  800e54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e56:	85 c0                	test   %eax,%eax
  800e58:	7f 08                	jg     800e62 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e62:	83 ec 0c             	sub    $0xc,%esp
  800e65:	50                   	push   %eax
  800e66:	6a 05                	push   $0x5
  800e68:	68 3f 27 80 00       	push   $0x80273f
  800e6d:	6a 23                	push   $0x23
  800e6f:	68 5c 27 80 00       	push   $0x80275c
  800e74:	e8 bd f4 ff ff       	call   800336 <_panic>

00800e79 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
  800e7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e87:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e92:	89 df                	mov    %ebx,%edi
  800e94:	89 de                	mov    %ebx,%esi
  800e96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	7f 08                	jg     800ea4 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5f                   	pop    %edi
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea4:	83 ec 0c             	sub    $0xc,%esp
  800ea7:	50                   	push   %eax
  800ea8:	6a 06                	push   $0x6
  800eaa:	68 3f 27 80 00       	push   $0x80273f
  800eaf:	6a 23                	push   $0x23
  800eb1:	68 5c 27 80 00       	push   $0x80275c
  800eb6:	e8 7b f4 ff ff       	call   800336 <_panic>

00800ebb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	57                   	push   %edi
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
  800ec1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecf:	b8 08 00 00 00       	mov    $0x8,%eax
  800ed4:	89 df                	mov    %ebx,%edi
  800ed6:	89 de                	mov    %ebx,%esi
  800ed8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eda:	85 c0                	test   %eax,%eax
  800edc:	7f 08                	jg     800ee6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	50                   	push   %eax
  800eea:	6a 08                	push   $0x8
  800eec:	68 3f 27 80 00       	push   $0x80273f
  800ef1:	6a 23                	push   $0x23
  800ef3:	68 5c 27 80 00       	push   $0x80275c
  800ef8:	e8 39 f4 ff ff       	call   800336 <_panic>

00800efd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
  800f03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f11:	b8 09 00 00 00       	mov    $0x9,%eax
  800f16:	89 df                	mov    %ebx,%edi
  800f18:	89 de                	mov    %ebx,%esi
  800f1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	7f 08                	jg     800f28 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f23:	5b                   	pop    %ebx
  800f24:	5e                   	pop    %esi
  800f25:	5f                   	pop    %edi
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f28:	83 ec 0c             	sub    $0xc,%esp
  800f2b:	50                   	push   %eax
  800f2c:	6a 09                	push   $0x9
  800f2e:	68 3f 27 80 00       	push   $0x80273f
  800f33:	6a 23                	push   $0x23
  800f35:	68 5c 27 80 00       	push   $0x80275c
  800f3a:	e8 f7 f3 ff ff       	call   800336 <_panic>

00800f3f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f53:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f58:	89 df                	mov    %ebx,%edi
  800f5a:	89 de                	mov    %ebx,%esi
  800f5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	7f 08                	jg     800f6a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6a:	83 ec 0c             	sub    $0xc,%esp
  800f6d:	50                   	push   %eax
  800f6e:	6a 0a                	push   $0xa
  800f70:	68 3f 27 80 00       	push   $0x80273f
  800f75:	6a 23                	push   $0x23
  800f77:	68 5c 27 80 00       	push   $0x80275c
  800f7c:	e8 b5 f3 ff ff       	call   800336 <_panic>

00800f81 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	57                   	push   %edi
  800f85:	56                   	push   %esi
  800f86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f87:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f92:	be 00 00 00 00       	mov    $0x0,%esi
  800f97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f9a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f9d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f9f:	5b                   	pop    %ebx
  800fa0:	5e                   	pop    %esi
  800fa1:	5f                   	pop    %edi
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
  800faa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fad:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fba:	89 cb                	mov    %ecx,%ebx
  800fbc:	89 cf                	mov    %ecx,%edi
  800fbe:	89 ce                	mov    %ecx,%esi
  800fc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	7f 08                	jg     800fce <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc9:	5b                   	pop    %ebx
  800fca:	5e                   	pop    %esi
  800fcb:	5f                   	pop    %edi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fce:	83 ec 0c             	sub    $0xc,%esp
  800fd1:	50                   	push   %eax
  800fd2:	6a 0d                	push   $0xd
  800fd4:	68 3f 27 80 00       	push   $0x80273f
  800fd9:	6a 23                	push   $0x23
  800fdb:	68 5c 27 80 00       	push   $0x80275c
  800fe0:	e8 51 f3 ff ff       	call   800336 <_panic>

00800fe5 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800feb:	68 6a 27 80 00       	push   $0x80276a
  800ff0:	6a 25                	push   $0x25
  800ff2:	68 82 27 80 00       	push   $0x802782
  800ff7:	e8 3a f3 ff ff       	call   800336 <_panic>

00800ffc <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	57                   	push   %edi
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
  801002:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  801005:	68 e5 0f 80 00       	push   $0x800fe5
  80100a:	e8 19 0f 00 00       	call   801f28 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80100f:	b8 07 00 00 00       	mov    $0x7,%eax
  801014:	cd 30                	int    $0x30
  801016:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  80101c:	83 c4 10             	add    $0x10,%esp
  80101f:	85 c0                	test   %eax,%eax
  801021:	78 27                	js     80104a <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  801023:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  801028:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80102c:	75 65                	jne    801093 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  80102e:	e8 83 fd ff ff       	call   800db6 <sys_getenvid>
  801033:	25 ff 03 00 00       	and    $0x3ff,%eax
  801038:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80103b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801040:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801045:	e9 11 01 00 00       	jmp    80115b <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  80104a:	50                   	push   %eax
  80104b:	68 e5 22 80 00       	push   $0x8022e5
  801050:	6a 6f                	push   $0x6f
  801052:	68 82 27 80 00       	push   $0x802782
  801057:	e8 da f2 ff ff       	call   800336 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  80105c:	e8 55 fd ff ff       	call   800db6 <sys_getenvid>
  801061:	83 ec 0c             	sub    $0xc,%esp
  801064:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  80106a:	56                   	push   %esi
  80106b:	57                   	push   %edi
  80106c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80106f:	57                   	push   %edi
  801070:	50                   	push   %eax
  801071:	e8 c1 fd ff ff       	call   800e37 <sys_page_map>
  801076:	83 c4 20             	add    $0x20,%esp
  801079:	85 c0                	test   %eax,%eax
  80107b:	0f 88 84 00 00 00    	js     801105 <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  801081:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801087:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80108d:	0f 84 84 00 00 00    	je     801117 <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  801093:	89 d8                	mov    %ebx,%eax
  801095:	c1 e8 16             	shr    $0x16,%eax
  801098:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80109f:	a8 01                	test   $0x1,%al
  8010a1:	74 de                	je     801081 <fork+0x85>
  8010a3:	89 d8                	mov    %ebx,%eax
  8010a5:	c1 e8 0c             	shr    $0xc,%eax
  8010a8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010af:	f6 c2 01             	test   $0x1,%dl
  8010b2:	74 cd                	je     801081 <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  8010b4:	89 c7                	mov    %eax,%edi
  8010b6:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  8010b9:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  8010c0:	f7 c6 00 04 00 00    	test   $0x400,%esi
  8010c6:	75 94                	jne    80105c <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  8010c8:	f7 c6 02 08 00 00    	test   $0x802,%esi
  8010ce:	0f 85 d1 00 00 00    	jne    8011a5 <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  8010d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8010d9:	8b 40 48             	mov    0x48(%eax),%eax
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	6a 05                	push   $0x5
  8010e1:	57                   	push   %edi
  8010e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010e5:	57                   	push   %edi
  8010e6:	50                   	push   %eax
  8010e7:	e8 4b fd ff ff       	call   800e37 <sys_page_map>
  8010ec:	83 c4 20             	add    $0x20,%esp
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	79 8e                	jns    801081 <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  8010f3:	50                   	push   %eax
  8010f4:	68 dc 27 80 00       	push   $0x8027dc
  8010f9:	6a 4a                	push   $0x4a
  8010fb:	68 82 27 80 00       	push   $0x802782
  801100:	e8 31 f2 ff ff       	call   800336 <_panic>
                        panic("duppage: page mapping failed %e", r);
  801105:	50                   	push   %eax
  801106:	68 bc 27 80 00       	push   $0x8027bc
  80110b:	6a 41                	push   $0x41
  80110d:	68 82 27 80 00       	push   $0x802782
  801112:	e8 1f f2 ff ff       	call   800336 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	6a 07                	push   $0x7
  80111c:	68 00 f0 bf ee       	push   $0xeebff000
  801121:	ff 75 e0             	pushl  -0x20(%ebp)
  801124:	e8 cb fc ff ff       	call   800df4 <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  801129:	83 c4 10             	add    $0x10,%esp
  80112c:	85 c0                	test   %eax,%eax
  80112e:	78 36                	js     801166 <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	68 9c 1f 80 00       	push   $0x801f9c
  801138:	ff 75 e0             	pushl  -0x20(%ebp)
  80113b:	e8 ff fd ff ff       	call   800f3f <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801140:	83 c4 10             	add    $0x10,%esp
  801143:	85 c0                	test   %eax,%eax
  801145:	78 34                	js     80117b <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801147:	83 ec 08             	sub    $0x8,%esp
  80114a:	6a 02                	push   $0x2
  80114c:	ff 75 e0             	pushl  -0x20(%ebp)
  80114f:	e8 67 fd ff ff       	call   800ebb <sys_env_set_status>
  801154:	83 c4 10             	add    $0x10,%esp
  801157:	85 c0                	test   %eax,%eax
  801159:	78 35                	js     801190 <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  80115b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80115e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801161:	5b                   	pop    %ebx
  801162:	5e                   	pop    %esi
  801163:	5f                   	pop    %edi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  801166:	50                   	push   %eax
  801167:	68 e5 22 80 00       	push   $0x8022e5
  80116c:	68 82 00 00 00       	push   $0x82
  801171:	68 82 27 80 00       	push   $0x802782
  801176:	e8 bb f1 ff ff       	call   800336 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80117b:	50                   	push   %eax
  80117c:	68 00 28 80 00       	push   $0x802800
  801181:	68 87 00 00 00       	push   $0x87
  801186:	68 82 27 80 00       	push   $0x802782
  80118b:	e8 a6 f1 ff ff       	call   800336 <_panic>
        	panic("sys_env_set_status: %e", r);
  801190:	50                   	push   %eax
  801191:	68 8d 27 80 00       	push   $0x80278d
  801196:	68 8b 00 00 00       	push   $0x8b
  80119b:	68 82 27 80 00       	push   $0x802782
  8011a0:	e8 91 f1 ff ff       	call   800336 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  8011a5:	a1 04 40 80 00       	mov    0x804004,%eax
  8011aa:	8b 40 48             	mov    0x48(%eax),%eax
  8011ad:	83 ec 0c             	sub    $0xc,%esp
  8011b0:	68 05 08 00 00       	push   $0x805
  8011b5:	57                   	push   %edi
  8011b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b9:	57                   	push   %edi
  8011ba:	50                   	push   %eax
  8011bb:	e8 77 fc ff ff       	call   800e37 <sys_page_map>
  8011c0:	83 c4 20             	add    $0x20,%esp
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	0f 88 28 ff ff ff    	js     8010f3 <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  8011cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8011d0:	8b 50 48             	mov    0x48(%eax),%edx
  8011d3:	8b 40 48             	mov    0x48(%eax),%eax
  8011d6:	83 ec 0c             	sub    $0xc,%esp
  8011d9:	68 05 08 00 00       	push   $0x805
  8011de:	57                   	push   %edi
  8011df:	52                   	push   %edx
  8011e0:	57                   	push   %edi
  8011e1:	50                   	push   %eax
  8011e2:	e8 50 fc ff ff       	call   800e37 <sys_page_map>
  8011e7:	83 c4 20             	add    $0x20,%esp
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	0f 89 8f fe ff ff    	jns    801081 <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  8011f2:	50                   	push   %eax
  8011f3:	68 dc 27 80 00       	push   $0x8027dc
  8011f8:	6a 4f                	push   $0x4f
  8011fa:	68 82 27 80 00       	push   $0x802782
  8011ff:	e8 32 f1 ff ff       	call   800336 <_panic>

00801204 <sfork>:

// Challenge!
int
sfork(void)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80120a:	68 a4 27 80 00       	push   $0x8027a4
  80120f:	68 94 00 00 00       	push   $0x94
  801214:	68 82 27 80 00       	push   $0x802782
  801219:	e8 18 f1 ff ff       	call   800336 <_panic>

0080121e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	05 00 00 00 30       	add    $0x30000000,%eax
  801229:	c1 e8 0c             	shr    $0xc,%eax
}
  80122c:	5d                   	pop    %ebp
  80122d:	c3                   	ret    

0080122e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801239:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80123e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801243:	5d                   	pop    %ebp
  801244:	c3                   	ret    

00801245 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80124b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801250:	89 c2                	mov    %eax,%edx
  801252:	c1 ea 16             	shr    $0x16,%edx
  801255:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80125c:	f6 c2 01             	test   $0x1,%dl
  80125f:	74 2a                	je     80128b <fd_alloc+0x46>
  801261:	89 c2                	mov    %eax,%edx
  801263:	c1 ea 0c             	shr    $0xc,%edx
  801266:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80126d:	f6 c2 01             	test   $0x1,%dl
  801270:	74 19                	je     80128b <fd_alloc+0x46>
  801272:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801277:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80127c:	75 d2                	jne    801250 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80127e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801284:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801289:	eb 07                	jmp    801292 <fd_alloc+0x4d>
			*fd_store = fd;
  80128b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80128d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801292:	5d                   	pop    %ebp
  801293:	c3                   	ret    

00801294 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80129a:	83 f8 1f             	cmp    $0x1f,%eax
  80129d:	77 36                	ja     8012d5 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80129f:	c1 e0 0c             	shl    $0xc,%eax
  8012a2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012a7:	89 c2                	mov    %eax,%edx
  8012a9:	c1 ea 16             	shr    $0x16,%edx
  8012ac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012b3:	f6 c2 01             	test   $0x1,%dl
  8012b6:	74 24                	je     8012dc <fd_lookup+0x48>
  8012b8:	89 c2                	mov    %eax,%edx
  8012ba:	c1 ea 0c             	shr    $0xc,%edx
  8012bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012c4:	f6 c2 01             	test   $0x1,%dl
  8012c7:	74 1a                	je     8012e3 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012cc:	89 02                	mov    %eax,(%edx)
	return 0;
  8012ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    
		return -E_INVAL;
  8012d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012da:	eb f7                	jmp    8012d3 <fd_lookup+0x3f>
		return -E_INVAL;
  8012dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e1:	eb f0                	jmp    8012d3 <fd_lookup+0x3f>
  8012e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e8:	eb e9                	jmp    8012d3 <fd_lookup+0x3f>

008012ea <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f3:	ba a4 28 80 00       	mov    $0x8028a4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012f8:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012fd:	39 08                	cmp    %ecx,(%eax)
  8012ff:	74 33                	je     801334 <dev_lookup+0x4a>
  801301:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801304:	8b 02                	mov    (%edx),%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	75 f3                	jne    8012fd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80130a:	a1 04 40 80 00       	mov    0x804004,%eax
  80130f:	8b 40 48             	mov    0x48(%eax),%eax
  801312:	83 ec 04             	sub    $0x4,%esp
  801315:	51                   	push   %ecx
  801316:	50                   	push   %eax
  801317:	68 24 28 80 00       	push   $0x802824
  80131c:	e8 f0 f0 ff ff       	call   800411 <cprintf>
	*dev = 0;
  801321:	8b 45 0c             	mov    0xc(%ebp),%eax
  801324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    
			*dev = devtab[i];
  801334:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801337:	89 01                	mov    %eax,(%ecx)
			return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	eb f2                	jmp    801332 <dev_lookup+0x48>

00801340 <fd_close>:
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	57                   	push   %edi
  801344:	56                   	push   %esi
  801345:	53                   	push   %ebx
  801346:	83 ec 1c             	sub    $0x1c,%esp
  801349:	8b 75 08             	mov    0x8(%ebp),%esi
  80134c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80134f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801352:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801353:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801359:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80135c:	50                   	push   %eax
  80135d:	e8 32 ff ff ff       	call   801294 <fd_lookup>
  801362:	89 c3                	mov    %eax,%ebx
  801364:	83 c4 08             	add    $0x8,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	78 05                	js     801370 <fd_close+0x30>
	    || fd != fd2)
  80136b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80136e:	74 16                	je     801386 <fd_close+0x46>
		return (must_exist ? r : 0);
  801370:	89 f8                	mov    %edi,%eax
  801372:	84 c0                	test   %al,%al
  801374:	b8 00 00 00 00       	mov    $0x0,%eax
  801379:	0f 44 d8             	cmove  %eax,%ebx
}
  80137c:	89 d8                	mov    %ebx,%eax
  80137e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801381:	5b                   	pop    %ebx
  801382:	5e                   	pop    %esi
  801383:	5f                   	pop    %edi
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801386:	83 ec 08             	sub    $0x8,%esp
  801389:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80138c:	50                   	push   %eax
  80138d:	ff 36                	pushl  (%esi)
  80138f:	e8 56 ff ff ff       	call   8012ea <dev_lookup>
  801394:	89 c3                	mov    %eax,%ebx
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	85 c0                	test   %eax,%eax
  80139b:	78 15                	js     8013b2 <fd_close+0x72>
		if (dev->dev_close)
  80139d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a0:	8b 40 10             	mov    0x10(%eax),%eax
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	74 1b                	je     8013c2 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	56                   	push   %esi
  8013ab:	ff d0                	call   *%eax
  8013ad:	89 c3                	mov    %eax,%ebx
  8013af:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	56                   	push   %esi
  8013b6:	6a 00                	push   $0x0
  8013b8:	e8 bc fa ff ff       	call   800e79 <sys_page_unmap>
	return r;
  8013bd:	83 c4 10             	add    $0x10,%esp
  8013c0:	eb ba                	jmp    80137c <fd_close+0x3c>
			r = 0;
  8013c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c7:	eb e9                	jmp    8013b2 <fd_close+0x72>

008013c9 <close>:

int
close(int fdnum)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d2:	50                   	push   %eax
  8013d3:	ff 75 08             	pushl  0x8(%ebp)
  8013d6:	e8 b9 fe ff ff       	call   801294 <fd_lookup>
  8013db:	83 c4 08             	add    $0x8,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 10                	js     8013f2 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	6a 01                	push   $0x1
  8013e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ea:	e8 51 ff ff ff       	call   801340 <fd_close>
  8013ef:	83 c4 10             	add    $0x10,%esp
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <close_all>:

void
close_all(void)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	53                   	push   %ebx
  8013f8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013fb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	53                   	push   %ebx
  801404:	e8 c0 ff ff ff       	call   8013c9 <close>
	for (i = 0; i < MAXFD; i++)
  801409:	83 c3 01             	add    $0x1,%ebx
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	83 fb 20             	cmp    $0x20,%ebx
  801412:	75 ec                	jne    801400 <close_all+0xc>
}
  801414:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801417:	c9                   	leave  
  801418:	c3                   	ret    

00801419 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	57                   	push   %edi
  80141d:	56                   	push   %esi
  80141e:	53                   	push   %ebx
  80141f:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801422:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801425:	50                   	push   %eax
  801426:	ff 75 08             	pushl  0x8(%ebp)
  801429:	e8 66 fe ff ff       	call   801294 <fd_lookup>
  80142e:	89 c3                	mov    %eax,%ebx
  801430:	83 c4 08             	add    $0x8,%esp
  801433:	85 c0                	test   %eax,%eax
  801435:	0f 88 81 00 00 00    	js     8014bc <dup+0xa3>
		return r;
	close(newfdnum);
  80143b:	83 ec 0c             	sub    $0xc,%esp
  80143e:	ff 75 0c             	pushl  0xc(%ebp)
  801441:	e8 83 ff ff ff       	call   8013c9 <close>

	newfd = INDEX2FD(newfdnum);
  801446:	8b 75 0c             	mov    0xc(%ebp),%esi
  801449:	c1 e6 0c             	shl    $0xc,%esi
  80144c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801452:	83 c4 04             	add    $0x4,%esp
  801455:	ff 75 e4             	pushl  -0x1c(%ebp)
  801458:	e8 d1 fd ff ff       	call   80122e <fd2data>
  80145d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80145f:	89 34 24             	mov    %esi,(%esp)
  801462:	e8 c7 fd ff ff       	call   80122e <fd2data>
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80146c:	89 d8                	mov    %ebx,%eax
  80146e:	c1 e8 16             	shr    $0x16,%eax
  801471:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801478:	a8 01                	test   $0x1,%al
  80147a:	74 11                	je     80148d <dup+0x74>
  80147c:	89 d8                	mov    %ebx,%eax
  80147e:	c1 e8 0c             	shr    $0xc,%eax
  801481:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801488:	f6 c2 01             	test   $0x1,%dl
  80148b:	75 39                	jne    8014c6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80148d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801490:	89 d0                	mov    %edx,%eax
  801492:	c1 e8 0c             	shr    $0xc,%eax
  801495:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80149c:	83 ec 0c             	sub    $0xc,%esp
  80149f:	25 07 0e 00 00       	and    $0xe07,%eax
  8014a4:	50                   	push   %eax
  8014a5:	56                   	push   %esi
  8014a6:	6a 00                	push   $0x0
  8014a8:	52                   	push   %edx
  8014a9:	6a 00                	push   $0x0
  8014ab:	e8 87 f9 ff ff       	call   800e37 <sys_page_map>
  8014b0:	89 c3                	mov    %eax,%ebx
  8014b2:	83 c4 20             	add    $0x20,%esp
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	78 31                	js     8014ea <dup+0xd1>
		goto err;

	return newfdnum;
  8014b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014bc:	89 d8                	mov    %ebx,%eax
  8014be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c1:	5b                   	pop    %ebx
  8014c2:	5e                   	pop    %esi
  8014c3:	5f                   	pop    %edi
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014cd:	83 ec 0c             	sub    $0xc,%esp
  8014d0:	25 07 0e 00 00       	and    $0xe07,%eax
  8014d5:	50                   	push   %eax
  8014d6:	57                   	push   %edi
  8014d7:	6a 00                	push   $0x0
  8014d9:	53                   	push   %ebx
  8014da:	6a 00                	push   $0x0
  8014dc:	e8 56 f9 ff ff       	call   800e37 <sys_page_map>
  8014e1:	89 c3                	mov    %eax,%ebx
  8014e3:	83 c4 20             	add    $0x20,%esp
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	79 a3                	jns    80148d <dup+0x74>
	sys_page_unmap(0, newfd);
  8014ea:	83 ec 08             	sub    $0x8,%esp
  8014ed:	56                   	push   %esi
  8014ee:	6a 00                	push   $0x0
  8014f0:	e8 84 f9 ff ff       	call   800e79 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014f5:	83 c4 08             	add    $0x8,%esp
  8014f8:	57                   	push   %edi
  8014f9:	6a 00                	push   $0x0
  8014fb:	e8 79 f9 ff ff       	call   800e79 <sys_page_unmap>
	return r;
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	eb b7                	jmp    8014bc <dup+0xa3>

00801505 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	53                   	push   %ebx
  801509:	83 ec 14             	sub    $0x14,%esp
  80150c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801512:	50                   	push   %eax
  801513:	53                   	push   %ebx
  801514:	e8 7b fd ff ff       	call   801294 <fd_lookup>
  801519:	83 c4 08             	add    $0x8,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 3f                	js     80155f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801520:	83 ec 08             	sub    $0x8,%esp
  801523:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801526:	50                   	push   %eax
  801527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152a:	ff 30                	pushl  (%eax)
  80152c:	e8 b9 fd ff ff       	call   8012ea <dev_lookup>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 27                	js     80155f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801538:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80153b:	8b 42 08             	mov    0x8(%edx),%eax
  80153e:	83 e0 03             	and    $0x3,%eax
  801541:	83 f8 01             	cmp    $0x1,%eax
  801544:	74 1e                	je     801564 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801549:	8b 40 08             	mov    0x8(%eax),%eax
  80154c:	85 c0                	test   %eax,%eax
  80154e:	74 35                	je     801585 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801550:	83 ec 04             	sub    $0x4,%esp
  801553:	ff 75 10             	pushl  0x10(%ebp)
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	52                   	push   %edx
  80155a:	ff d0                	call   *%eax
  80155c:	83 c4 10             	add    $0x10,%esp
}
  80155f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801562:	c9                   	leave  
  801563:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801564:	a1 04 40 80 00       	mov    0x804004,%eax
  801569:	8b 40 48             	mov    0x48(%eax),%eax
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	53                   	push   %ebx
  801570:	50                   	push   %eax
  801571:	68 68 28 80 00       	push   $0x802868
  801576:	e8 96 ee ff ff       	call   800411 <cprintf>
		return -E_INVAL;
  80157b:	83 c4 10             	add    $0x10,%esp
  80157e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801583:	eb da                	jmp    80155f <read+0x5a>
		return -E_NOT_SUPP;
  801585:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158a:	eb d3                	jmp    80155f <read+0x5a>

0080158c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	57                   	push   %edi
  801590:	56                   	push   %esi
  801591:	53                   	push   %ebx
  801592:	83 ec 0c             	sub    $0xc,%esp
  801595:	8b 7d 08             	mov    0x8(%ebp),%edi
  801598:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80159b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a0:	39 f3                	cmp    %esi,%ebx
  8015a2:	73 25                	jae    8015c9 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015a4:	83 ec 04             	sub    $0x4,%esp
  8015a7:	89 f0                	mov    %esi,%eax
  8015a9:	29 d8                	sub    %ebx,%eax
  8015ab:	50                   	push   %eax
  8015ac:	89 d8                	mov    %ebx,%eax
  8015ae:	03 45 0c             	add    0xc(%ebp),%eax
  8015b1:	50                   	push   %eax
  8015b2:	57                   	push   %edi
  8015b3:	e8 4d ff ff ff       	call   801505 <read>
		if (m < 0)
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	78 08                	js     8015c7 <readn+0x3b>
			return m;
		if (m == 0)
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	74 06                	je     8015c9 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8015c3:	01 c3                	add    %eax,%ebx
  8015c5:	eb d9                	jmp    8015a0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015c7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015c9:	89 d8                	mov    %ebx,%eax
  8015cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ce:	5b                   	pop    %ebx
  8015cf:	5e                   	pop    %esi
  8015d0:	5f                   	pop    %edi
  8015d1:	5d                   	pop    %ebp
  8015d2:	c3                   	ret    

008015d3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	53                   	push   %ebx
  8015d7:	83 ec 14             	sub    $0x14,%esp
  8015da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e0:	50                   	push   %eax
  8015e1:	53                   	push   %ebx
  8015e2:	e8 ad fc ff ff       	call   801294 <fd_lookup>
  8015e7:	83 c4 08             	add    $0x8,%esp
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	78 3a                	js     801628 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ee:	83 ec 08             	sub    $0x8,%esp
  8015f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f4:	50                   	push   %eax
  8015f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f8:	ff 30                	pushl  (%eax)
  8015fa:	e8 eb fc ff ff       	call   8012ea <dev_lookup>
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	78 22                	js     801628 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801609:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80160d:	74 1e                	je     80162d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80160f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801612:	8b 52 0c             	mov    0xc(%edx),%edx
  801615:	85 d2                	test   %edx,%edx
  801617:	74 35                	je     80164e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801619:	83 ec 04             	sub    $0x4,%esp
  80161c:	ff 75 10             	pushl  0x10(%ebp)
  80161f:	ff 75 0c             	pushl  0xc(%ebp)
  801622:	50                   	push   %eax
  801623:	ff d2                	call   *%edx
  801625:	83 c4 10             	add    $0x10,%esp
}
  801628:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80162d:	a1 04 40 80 00       	mov    0x804004,%eax
  801632:	8b 40 48             	mov    0x48(%eax),%eax
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	53                   	push   %ebx
  801639:	50                   	push   %eax
  80163a:	68 84 28 80 00       	push   $0x802884
  80163f:	e8 cd ed ff ff       	call   800411 <cprintf>
		return -E_INVAL;
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164c:	eb da                	jmp    801628 <write+0x55>
		return -E_NOT_SUPP;
  80164e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801653:	eb d3                	jmp    801628 <write+0x55>

00801655 <seek>:

int
seek(int fdnum, off_t offset)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80165b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80165e:	50                   	push   %eax
  80165f:	ff 75 08             	pushl  0x8(%ebp)
  801662:	e8 2d fc ff ff       	call   801294 <fd_lookup>
  801667:	83 c4 08             	add    $0x8,%esp
  80166a:	85 c0                	test   %eax,%eax
  80166c:	78 0e                	js     80167c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80166e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801671:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801674:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801677:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	53                   	push   %ebx
  801682:	83 ec 14             	sub    $0x14,%esp
  801685:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801688:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168b:	50                   	push   %eax
  80168c:	53                   	push   %ebx
  80168d:	e8 02 fc ff ff       	call   801294 <fd_lookup>
  801692:	83 c4 08             	add    $0x8,%esp
  801695:	85 c0                	test   %eax,%eax
  801697:	78 37                	js     8016d0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80169f:	50                   	push   %eax
  8016a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a3:	ff 30                	pushl  (%eax)
  8016a5:	e8 40 fc ff ff       	call   8012ea <dev_lookup>
  8016aa:	83 c4 10             	add    $0x10,%esp
  8016ad:	85 c0                	test   %eax,%eax
  8016af:	78 1f                	js     8016d0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016b8:	74 1b                	je     8016d5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016bd:	8b 52 18             	mov    0x18(%edx),%edx
  8016c0:	85 d2                	test   %edx,%edx
  8016c2:	74 32                	je     8016f6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016c4:	83 ec 08             	sub    $0x8,%esp
  8016c7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ca:	50                   	push   %eax
  8016cb:	ff d2                	call   *%edx
  8016cd:	83 c4 10             	add    $0x10,%esp
}
  8016d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016d5:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016da:	8b 40 48             	mov    0x48(%eax),%eax
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	53                   	push   %ebx
  8016e1:	50                   	push   %eax
  8016e2:	68 44 28 80 00       	push   $0x802844
  8016e7:	e8 25 ed ff ff       	call   800411 <cprintf>
		return -E_INVAL;
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f4:	eb da                	jmp    8016d0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fb:	eb d3                	jmp    8016d0 <ftruncate+0x52>

008016fd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	53                   	push   %ebx
  801701:	83 ec 14             	sub    $0x14,%esp
  801704:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801707:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80170a:	50                   	push   %eax
  80170b:	ff 75 08             	pushl  0x8(%ebp)
  80170e:	e8 81 fb ff ff       	call   801294 <fd_lookup>
  801713:	83 c4 08             	add    $0x8,%esp
  801716:	85 c0                	test   %eax,%eax
  801718:	78 4b                	js     801765 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80171a:	83 ec 08             	sub    $0x8,%esp
  80171d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801720:	50                   	push   %eax
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	ff 30                	pushl  (%eax)
  801726:	e8 bf fb ff ff       	call   8012ea <dev_lookup>
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 33                	js     801765 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801735:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801739:	74 2f                	je     80176a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80173b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80173e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801745:	00 00 00 
	stat->st_isdir = 0;
  801748:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80174f:	00 00 00 
	stat->st_dev = dev;
  801752:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801758:	83 ec 08             	sub    $0x8,%esp
  80175b:	53                   	push   %ebx
  80175c:	ff 75 f0             	pushl  -0x10(%ebp)
  80175f:	ff 50 14             	call   *0x14(%eax)
  801762:	83 c4 10             	add    $0x10,%esp
}
  801765:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801768:	c9                   	leave  
  801769:	c3                   	ret    
		return -E_NOT_SUPP;
  80176a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80176f:	eb f4                	jmp    801765 <fstat+0x68>

00801771 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	56                   	push   %esi
  801775:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801776:	83 ec 08             	sub    $0x8,%esp
  801779:	6a 00                	push   $0x0
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	e8 e7 01 00 00       	call   80196a <open>
  801783:	89 c3                	mov    %eax,%ebx
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	85 c0                	test   %eax,%eax
  80178a:	78 1b                	js     8017a7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80178c:	83 ec 08             	sub    $0x8,%esp
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	50                   	push   %eax
  801793:	e8 65 ff ff ff       	call   8016fd <fstat>
  801798:	89 c6                	mov    %eax,%esi
	close(fd);
  80179a:	89 1c 24             	mov    %ebx,(%esp)
  80179d:	e8 27 fc ff ff       	call   8013c9 <close>
	return r;
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	89 f3                	mov    %esi,%ebx
}
  8017a7:	89 d8                	mov    %ebx,%eax
  8017a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ac:	5b                   	pop    %ebx
  8017ad:	5e                   	pop    %esi
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	56                   	push   %esi
  8017b4:	53                   	push   %ebx
  8017b5:	89 c6                	mov    %eax,%esi
  8017b7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017b9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017c0:	74 27                	je     8017e9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017c2:	6a 07                	push   $0x7
  8017c4:	68 00 50 80 00       	push   $0x805000
  8017c9:	56                   	push   %esi
  8017ca:	ff 35 00 40 80 00    	pushl  0x804000
  8017d0:	e8 05 08 00 00       	call   801fda <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017d5:	83 c4 0c             	add    $0xc,%esp
  8017d8:	6a 00                	push   $0x0
  8017da:	53                   	push   %ebx
  8017db:	6a 00                	push   $0x0
  8017dd:	e8 e1 07 00 00       	call   801fc3 <ipc_recv>
}
  8017e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e5:	5b                   	pop    %ebx
  8017e6:	5e                   	pop    %esi
  8017e7:	5d                   	pop    %ebp
  8017e8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017e9:	83 ec 0c             	sub    $0xc,%esp
  8017ec:	6a 01                	push   $0x1
  8017ee:	e8 fe 07 00 00       	call   801ff1 <ipc_find_env>
  8017f3:	a3 00 40 80 00       	mov    %eax,0x804000
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	eb c5                	jmp    8017c2 <fsipc+0x12>

008017fd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	8b 40 0c             	mov    0xc(%eax),%eax
  801809:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80180e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801811:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801816:	ba 00 00 00 00       	mov    $0x0,%edx
  80181b:	b8 02 00 00 00       	mov    $0x2,%eax
  801820:	e8 8b ff ff ff       	call   8017b0 <fsipc>
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <devfile_flush>:
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	8b 40 0c             	mov    0xc(%eax),%eax
  801833:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801838:	ba 00 00 00 00       	mov    $0x0,%edx
  80183d:	b8 06 00 00 00       	mov    $0x6,%eax
  801842:	e8 69 ff ff ff       	call   8017b0 <fsipc>
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <devfile_stat>:
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	53                   	push   %ebx
  80184d:	83 ec 04             	sub    $0x4,%esp
  801850:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	8b 40 0c             	mov    0xc(%eax),%eax
  801859:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80185e:	ba 00 00 00 00       	mov    $0x0,%edx
  801863:	b8 05 00 00 00       	mov    $0x5,%eax
  801868:	e8 43 ff ff ff       	call   8017b0 <fsipc>
  80186d:	85 c0                	test   %eax,%eax
  80186f:	78 2c                	js     80189d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801871:	83 ec 08             	sub    $0x8,%esp
  801874:	68 00 50 80 00       	push   $0x805000
  801879:	53                   	push   %ebx
  80187a:	e8 7c f1 ff ff       	call   8009fb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80187f:	a1 80 50 80 00       	mov    0x805080,%eax
  801884:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80188a:	a1 84 50 80 00       	mov    0x805084,%eax
  80188f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801895:	83 c4 10             	add    $0x10,%esp
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <devfile_write>:
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 0c             	sub    $0xc,%esp
  8018a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ab:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8018b0:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8018b5:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018bb:	8b 52 0c             	mov    0xc(%edx),%edx
  8018be:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8018c4:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8018c9:	50                   	push   %eax
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	68 08 50 80 00       	push   $0x805008
  8018d2:	e8 b2 f2 ff ff       	call   800b89 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8018d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018dc:	b8 04 00 00 00       	mov    $0x4,%eax
  8018e1:	e8 ca fe ff ff       	call   8017b0 <fsipc>
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <devfile_read>:
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	56                   	push   %esi
  8018ec:	53                   	push   %ebx
  8018ed:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018fb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801901:	ba 00 00 00 00       	mov    $0x0,%edx
  801906:	b8 03 00 00 00       	mov    $0x3,%eax
  80190b:	e8 a0 fe ff ff       	call   8017b0 <fsipc>
  801910:	89 c3                	mov    %eax,%ebx
  801912:	85 c0                	test   %eax,%eax
  801914:	78 1f                	js     801935 <devfile_read+0x4d>
	assert(r <= n);
  801916:	39 f0                	cmp    %esi,%eax
  801918:	77 24                	ja     80193e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80191a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80191f:	7f 33                	jg     801954 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	50                   	push   %eax
  801925:	68 00 50 80 00       	push   $0x805000
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	e8 57 f2 ff ff       	call   800b89 <memmove>
	return r;
  801932:	83 c4 10             	add    $0x10,%esp
}
  801935:	89 d8                	mov    %ebx,%eax
  801937:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193a:	5b                   	pop    %ebx
  80193b:	5e                   	pop    %esi
  80193c:	5d                   	pop    %ebp
  80193d:	c3                   	ret    
	assert(r <= n);
  80193e:	68 b4 28 80 00       	push   $0x8028b4
  801943:	68 bb 28 80 00       	push   $0x8028bb
  801948:	6a 7c                	push   $0x7c
  80194a:	68 d0 28 80 00       	push   $0x8028d0
  80194f:	e8 e2 e9 ff ff       	call   800336 <_panic>
	assert(r <= PGSIZE);
  801954:	68 db 28 80 00       	push   $0x8028db
  801959:	68 bb 28 80 00       	push   $0x8028bb
  80195e:	6a 7d                	push   $0x7d
  801960:	68 d0 28 80 00       	push   $0x8028d0
  801965:	e8 cc e9 ff ff       	call   800336 <_panic>

0080196a <open>:
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	56                   	push   %esi
  80196e:	53                   	push   %ebx
  80196f:	83 ec 1c             	sub    $0x1c,%esp
  801972:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801975:	56                   	push   %esi
  801976:	e8 49 f0 ff ff       	call   8009c4 <strlen>
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801983:	7f 6c                	jg     8019f1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801985:	83 ec 0c             	sub    $0xc,%esp
  801988:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198b:	50                   	push   %eax
  80198c:	e8 b4 f8 ff ff       	call   801245 <fd_alloc>
  801991:	89 c3                	mov    %eax,%ebx
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	85 c0                	test   %eax,%eax
  801998:	78 3c                	js     8019d6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80199a:	83 ec 08             	sub    $0x8,%esp
  80199d:	56                   	push   %esi
  80199e:	68 00 50 80 00       	push   $0x805000
  8019a3:	e8 53 f0 ff ff       	call   8009fb <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ab:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b8:	e8 f3 fd ff ff       	call   8017b0 <fsipc>
  8019bd:	89 c3                	mov    %eax,%ebx
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	78 19                	js     8019df <open+0x75>
	return fd2num(fd);
  8019c6:	83 ec 0c             	sub    $0xc,%esp
  8019c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cc:	e8 4d f8 ff ff       	call   80121e <fd2num>
  8019d1:	89 c3                	mov    %eax,%ebx
  8019d3:	83 c4 10             	add    $0x10,%esp
}
  8019d6:	89 d8                	mov    %ebx,%eax
  8019d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019db:	5b                   	pop    %ebx
  8019dc:	5e                   	pop    %esi
  8019dd:	5d                   	pop    %ebp
  8019de:	c3                   	ret    
		fd_close(fd, 0);
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	6a 00                	push   $0x0
  8019e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e7:	e8 54 f9 ff ff       	call   801340 <fd_close>
		return r;
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	eb e5                	jmp    8019d6 <open+0x6c>
		return -E_BAD_PATH;
  8019f1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019f6:	eb de                	jmp    8019d6 <open+0x6c>

008019f8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801a03:	b8 08 00 00 00       	mov    $0x8,%eax
  801a08:	e8 a3 fd ff ff       	call   8017b0 <fsipc>
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	56                   	push   %esi
  801a13:	53                   	push   %ebx
  801a14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a17:	83 ec 0c             	sub    $0xc,%esp
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	e8 0c f8 ff ff       	call   80122e <fd2data>
  801a22:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a24:	83 c4 08             	add    $0x8,%esp
  801a27:	68 e7 28 80 00       	push   $0x8028e7
  801a2c:	53                   	push   %ebx
  801a2d:	e8 c9 ef ff ff       	call   8009fb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a32:	8b 46 04             	mov    0x4(%esi),%eax
  801a35:	2b 06                	sub    (%esi),%eax
  801a37:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a3d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a44:	00 00 00 
	stat->st_dev = &devpipe;
  801a47:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801a4e:	30 80 00 
	return 0;
}
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
  801a56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a59:	5b                   	pop    %ebx
  801a5a:	5e                   	pop    %esi
  801a5b:	5d                   	pop    %ebp
  801a5c:	c3                   	ret    

00801a5d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	53                   	push   %ebx
  801a61:	83 ec 0c             	sub    $0xc,%esp
  801a64:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a67:	53                   	push   %ebx
  801a68:	6a 00                	push   $0x0
  801a6a:	e8 0a f4 ff ff       	call   800e79 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a6f:	89 1c 24             	mov    %ebx,(%esp)
  801a72:	e8 b7 f7 ff ff       	call   80122e <fd2data>
  801a77:	83 c4 08             	add    $0x8,%esp
  801a7a:	50                   	push   %eax
  801a7b:	6a 00                	push   $0x0
  801a7d:	e8 f7 f3 ff ff       	call   800e79 <sys_page_unmap>
}
  801a82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <_pipeisclosed>:
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	57                   	push   %edi
  801a8b:	56                   	push   %esi
  801a8c:	53                   	push   %ebx
  801a8d:	83 ec 1c             	sub    $0x1c,%esp
  801a90:	89 c7                	mov    %eax,%edi
  801a92:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a94:	a1 04 40 80 00       	mov    0x804004,%eax
  801a99:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a9c:	83 ec 0c             	sub    $0xc,%esp
  801a9f:	57                   	push   %edi
  801aa0:	e8 85 05 00 00       	call   80202a <pageref>
  801aa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801aa8:	89 34 24             	mov    %esi,(%esp)
  801aab:	e8 7a 05 00 00       	call   80202a <pageref>
		nn = thisenv->env_runs;
  801ab0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ab6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	39 cb                	cmp    %ecx,%ebx
  801abe:	74 1b                	je     801adb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ac0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ac3:	75 cf                	jne    801a94 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ac5:	8b 42 58             	mov    0x58(%edx),%eax
  801ac8:	6a 01                	push   $0x1
  801aca:	50                   	push   %eax
  801acb:	53                   	push   %ebx
  801acc:	68 ee 28 80 00       	push   $0x8028ee
  801ad1:	e8 3b e9 ff ff       	call   800411 <cprintf>
  801ad6:	83 c4 10             	add    $0x10,%esp
  801ad9:	eb b9                	jmp    801a94 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801adb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ade:	0f 94 c0             	sete   %al
  801ae1:	0f b6 c0             	movzbl %al,%eax
}
  801ae4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ae7:	5b                   	pop    %ebx
  801ae8:	5e                   	pop    %esi
  801ae9:	5f                   	pop    %edi
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <devpipe_write>:
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	57                   	push   %edi
  801af0:	56                   	push   %esi
  801af1:	53                   	push   %ebx
  801af2:	83 ec 28             	sub    $0x28,%esp
  801af5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801af8:	56                   	push   %esi
  801af9:	e8 30 f7 ff ff       	call   80122e <fd2data>
  801afe:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b00:	83 c4 10             	add    $0x10,%esp
  801b03:	bf 00 00 00 00       	mov    $0x0,%edi
  801b08:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b0b:	74 4f                	je     801b5c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b0d:	8b 43 04             	mov    0x4(%ebx),%eax
  801b10:	8b 0b                	mov    (%ebx),%ecx
  801b12:	8d 51 20             	lea    0x20(%ecx),%edx
  801b15:	39 d0                	cmp    %edx,%eax
  801b17:	72 14                	jb     801b2d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b19:	89 da                	mov    %ebx,%edx
  801b1b:	89 f0                	mov    %esi,%eax
  801b1d:	e8 65 ff ff ff       	call   801a87 <_pipeisclosed>
  801b22:	85 c0                	test   %eax,%eax
  801b24:	75 3a                	jne    801b60 <devpipe_write+0x74>
			sys_yield();
  801b26:	e8 aa f2 ff ff       	call   800dd5 <sys_yield>
  801b2b:	eb e0                	jmp    801b0d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b30:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b34:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b37:	89 c2                	mov    %eax,%edx
  801b39:	c1 fa 1f             	sar    $0x1f,%edx
  801b3c:	89 d1                	mov    %edx,%ecx
  801b3e:	c1 e9 1b             	shr    $0x1b,%ecx
  801b41:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b44:	83 e2 1f             	and    $0x1f,%edx
  801b47:	29 ca                	sub    %ecx,%edx
  801b49:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b4d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b51:	83 c0 01             	add    $0x1,%eax
  801b54:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b57:	83 c7 01             	add    $0x1,%edi
  801b5a:	eb ac                	jmp    801b08 <devpipe_write+0x1c>
	return i;
  801b5c:	89 f8                	mov    %edi,%eax
  801b5e:	eb 05                	jmp    801b65 <devpipe_write+0x79>
				return 0;
  801b60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b68:	5b                   	pop    %ebx
  801b69:	5e                   	pop    %esi
  801b6a:	5f                   	pop    %edi
  801b6b:	5d                   	pop    %ebp
  801b6c:	c3                   	ret    

00801b6d <devpipe_read>:
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	57                   	push   %edi
  801b71:	56                   	push   %esi
  801b72:	53                   	push   %ebx
  801b73:	83 ec 18             	sub    $0x18,%esp
  801b76:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b79:	57                   	push   %edi
  801b7a:	e8 af f6 ff ff       	call   80122e <fd2data>
  801b7f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	be 00 00 00 00       	mov    $0x0,%esi
  801b89:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b8c:	74 47                	je     801bd5 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b8e:	8b 03                	mov    (%ebx),%eax
  801b90:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b93:	75 22                	jne    801bb7 <devpipe_read+0x4a>
			if (i > 0)
  801b95:	85 f6                	test   %esi,%esi
  801b97:	75 14                	jne    801bad <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b99:	89 da                	mov    %ebx,%edx
  801b9b:	89 f8                	mov    %edi,%eax
  801b9d:	e8 e5 fe ff ff       	call   801a87 <_pipeisclosed>
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	75 33                	jne    801bd9 <devpipe_read+0x6c>
			sys_yield();
  801ba6:	e8 2a f2 ff ff       	call   800dd5 <sys_yield>
  801bab:	eb e1                	jmp    801b8e <devpipe_read+0x21>
				return i;
  801bad:	89 f0                	mov    %esi,%eax
}
  801baf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bb2:	5b                   	pop    %ebx
  801bb3:	5e                   	pop    %esi
  801bb4:	5f                   	pop    %edi
  801bb5:	5d                   	pop    %ebp
  801bb6:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801bb7:	99                   	cltd   
  801bb8:	c1 ea 1b             	shr    $0x1b,%edx
  801bbb:	01 d0                	add    %edx,%eax
  801bbd:	83 e0 1f             	and    $0x1f,%eax
  801bc0:	29 d0                	sub    %edx,%eax
  801bc2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801bc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bca:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801bcd:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801bd0:	83 c6 01             	add    $0x1,%esi
  801bd3:	eb b4                	jmp    801b89 <devpipe_read+0x1c>
	return i;
  801bd5:	89 f0                	mov    %esi,%eax
  801bd7:	eb d6                	jmp    801baf <devpipe_read+0x42>
				return 0;
  801bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bde:	eb cf                	jmp    801baf <devpipe_read+0x42>

00801be0 <pipe>:
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	56                   	push   %esi
  801be4:	53                   	push   %ebx
  801be5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801be8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801beb:	50                   	push   %eax
  801bec:	e8 54 f6 ff ff       	call   801245 <fd_alloc>
  801bf1:	89 c3                	mov    %eax,%ebx
  801bf3:	83 c4 10             	add    $0x10,%esp
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	78 5b                	js     801c55 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	68 07 04 00 00       	push   $0x407
  801c02:	ff 75 f4             	pushl  -0xc(%ebp)
  801c05:	6a 00                	push   $0x0
  801c07:	e8 e8 f1 ff ff       	call   800df4 <sys_page_alloc>
  801c0c:	89 c3                	mov    %eax,%ebx
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	85 c0                	test   %eax,%eax
  801c13:	78 40                	js     801c55 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801c15:	83 ec 0c             	sub    $0xc,%esp
  801c18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c1b:	50                   	push   %eax
  801c1c:	e8 24 f6 ff ff       	call   801245 <fd_alloc>
  801c21:	89 c3                	mov    %eax,%ebx
  801c23:	83 c4 10             	add    $0x10,%esp
  801c26:	85 c0                	test   %eax,%eax
  801c28:	78 1b                	js     801c45 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c2a:	83 ec 04             	sub    $0x4,%esp
  801c2d:	68 07 04 00 00       	push   $0x407
  801c32:	ff 75 f0             	pushl  -0x10(%ebp)
  801c35:	6a 00                	push   $0x0
  801c37:	e8 b8 f1 ff ff       	call   800df4 <sys_page_alloc>
  801c3c:	89 c3                	mov    %eax,%ebx
  801c3e:	83 c4 10             	add    $0x10,%esp
  801c41:	85 c0                	test   %eax,%eax
  801c43:	79 19                	jns    801c5e <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c45:	83 ec 08             	sub    $0x8,%esp
  801c48:	ff 75 f4             	pushl  -0xc(%ebp)
  801c4b:	6a 00                	push   $0x0
  801c4d:	e8 27 f2 ff ff       	call   800e79 <sys_page_unmap>
  801c52:	83 c4 10             	add    $0x10,%esp
}
  801c55:	89 d8                	mov    %ebx,%eax
  801c57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5a:	5b                   	pop    %ebx
  801c5b:	5e                   	pop    %esi
  801c5c:	5d                   	pop    %ebp
  801c5d:	c3                   	ret    
	va = fd2data(fd0);
  801c5e:	83 ec 0c             	sub    $0xc,%esp
  801c61:	ff 75 f4             	pushl  -0xc(%ebp)
  801c64:	e8 c5 f5 ff ff       	call   80122e <fd2data>
  801c69:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c6b:	83 c4 0c             	add    $0xc,%esp
  801c6e:	68 07 04 00 00       	push   $0x407
  801c73:	50                   	push   %eax
  801c74:	6a 00                	push   $0x0
  801c76:	e8 79 f1 ff ff       	call   800df4 <sys_page_alloc>
  801c7b:	89 c3                	mov    %eax,%ebx
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	85 c0                	test   %eax,%eax
  801c82:	0f 88 8c 00 00 00    	js     801d14 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c88:	83 ec 0c             	sub    $0xc,%esp
  801c8b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c8e:	e8 9b f5 ff ff       	call   80122e <fd2data>
  801c93:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c9a:	50                   	push   %eax
  801c9b:	6a 00                	push   $0x0
  801c9d:	56                   	push   %esi
  801c9e:	6a 00                	push   $0x0
  801ca0:	e8 92 f1 ff ff       	call   800e37 <sys_page_map>
  801ca5:	89 c3                	mov    %eax,%ebx
  801ca7:	83 c4 20             	add    $0x20,%esp
  801caa:	85 c0                	test   %eax,%eax
  801cac:	78 58                	js     801d06 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb1:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801cb7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc6:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801ccc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801cd8:	83 ec 0c             	sub    $0xc,%esp
  801cdb:	ff 75 f4             	pushl  -0xc(%ebp)
  801cde:	e8 3b f5 ff ff       	call   80121e <fd2num>
  801ce3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ce8:	83 c4 04             	add    $0x4,%esp
  801ceb:	ff 75 f0             	pushl  -0x10(%ebp)
  801cee:	e8 2b f5 ff ff       	call   80121e <fd2num>
  801cf3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cf9:	83 c4 10             	add    $0x10,%esp
  801cfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d01:	e9 4f ff ff ff       	jmp    801c55 <pipe+0x75>
	sys_page_unmap(0, va);
  801d06:	83 ec 08             	sub    $0x8,%esp
  801d09:	56                   	push   %esi
  801d0a:	6a 00                	push   $0x0
  801d0c:	e8 68 f1 ff ff       	call   800e79 <sys_page_unmap>
  801d11:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d14:	83 ec 08             	sub    $0x8,%esp
  801d17:	ff 75 f0             	pushl  -0x10(%ebp)
  801d1a:	6a 00                	push   $0x0
  801d1c:	e8 58 f1 ff ff       	call   800e79 <sys_page_unmap>
  801d21:	83 c4 10             	add    $0x10,%esp
  801d24:	e9 1c ff ff ff       	jmp    801c45 <pipe+0x65>

00801d29 <pipeisclosed>:
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d32:	50                   	push   %eax
  801d33:	ff 75 08             	pushl  0x8(%ebp)
  801d36:	e8 59 f5 ff ff       	call   801294 <fd_lookup>
  801d3b:	83 c4 10             	add    $0x10,%esp
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	78 18                	js     801d5a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d42:	83 ec 0c             	sub    $0xc,%esp
  801d45:	ff 75 f4             	pushl  -0xc(%ebp)
  801d48:	e8 e1 f4 ff ff       	call   80122e <fd2data>
	return _pipeisclosed(fd, p);
  801d4d:	89 c2                	mov    %eax,%edx
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	e8 30 fd ff ff       	call   801a87 <_pipeisclosed>
  801d57:	83 c4 10             	add    $0x10,%esp
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	56                   	push   %esi
  801d60:	53                   	push   %ebx
  801d61:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801d64:	85 f6                	test   %esi,%esi
  801d66:	74 13                	je     801d7b <wait+0x1f>
	e = &envs[ENVX(envid)];
  801d68:	89 f3                	mov    %esi,%ebx
  801d6a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801d70:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801d73:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801d79:	eb 1b                	jmp    801d96 <wait+0x3a>
	assert(envid != 0);
  801d7b:	68 06 29 80 00       	push   $0x802906
  801d80:	68 bb 28 80 00       	push   $0x8028bb
  801d85:	6a 09                	push   $0x9
  801d87:	68 11 29 80 00       	push   $0x802911
  801d8c:	e8 a5 e5 ff ff       	call   800336 <_panic>
		sys_yield();
  801d91:	e8 3f f0 ff ff       	call   800dd5 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801d96:	8b 43 48             	mov    0x48(%ebx),%eax
  801d99:	39 f0                	cmp    %esi,%eax
  801d9b:	75 07                	jne    801da4 <wait+0x48>
  801d9d:	8b 43 54             	mov    0x54(%ebx),%eax
  801da0:	85 c0                	test   %eax,%eax
  801da2:	75 ed                	jne    801d91 <wait+0x35>
}
  801da4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5d                   	pop    %ebp
  801daa:	c3                   	ret    

00801dab <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    

00801db5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801dbb:	68 1c 29 80 00       	push   $0x80291c
  801dc0:	ff 75 0c             	pushl  0xc(%ebp)
  801dc3:	e8 33 ec ff ff       	call   8009fb <strcpy>
	return 0;
}
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <devcons_write>:
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	57                   	push   %edi
  801dd3:	56                   	push   %esi
  801dd4:	53                   	push   %ebx
  801dd5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ddb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801de0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801de6:	eb 2f                	jmp    801e17 <devcons_write+0x48>
		m = n - tot;
  801de8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801deb:	29 f3                	sub    %esi,%ebx
  801ded:	83 fb 7f             	cmp    $0x7f,%ebx
  801df0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801df5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801df8:	83 ec 04             	sub    $0x4,%esp
  801dfb:	53                   	push   %ebx
  801dfc:	89 f0                	mov    %esi,%eax
  801dfe:	03 45 0c             	add    0xc(%ebp),%eax
  801e01:	50                   	push   %eax
  801e02:	57                   	push   %edi
  801e03:	e8 81 ed ff ff       	call   800b89 <memmove>
		sys_cputs(buf, m);
  801e08:	83 c4 08             	add    $0x8,%esp
  801e0b:	53                   	push   %ebx
  801e0c:	57                   	push   %edi
  801e0d:	e8 26 ef ff ff       	call   800d38 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e12:	01 de                	add    %ebx,%esi
  801e14:	83 c4 10             	add    $0x10,%esp
  801e17:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e1a:	72 cc                	jb     801de8 <devcons_write+0x19>
}
  801e1c:	89 f0                	mov    %esi,%eax
  801e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e21:	5b                   	pop    %ebx
  801e22:	5e                   	pop    %esi
  801e23:	5f                   	pop    %edi
  801e24:	5d                   	pop    %ebp
  801e25:	c3                   	ret    

00801e26 <devcons_read>:
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 08             	sub    $0x8,%esp
  801e2c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e35:	75 07                	jne    801e3e <devcons_read+0x18>
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    
		sys_yield();
  801e39:	e8 97 ef ff ff       	call   800dd5 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e3e:	e8 13 ef ff ff       	call   800d56 <sys_cgetc>
  801e43:	85 c0                	test   %eax,%eax
  801e45:	74 f2                	je     801e39 <devcons_read+0x13>
	if (c < 0)
  801e47:	85 c0                	test   %eax,%eax
  801e49:	78 ec                	js     801e37 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e4b:	83 f8 04             	cmp    $0x4,%eax
  801e4e:	74 0c                	je     801e5c <devcons_read+0x36>
	*(char*)vbuf = c;
  801e50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e53:	88 02                	mov    %al,(%edx)
	return 1;
  801e55:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5a:	eb db                	jmp    801e37 <devcons_read+0x11>
		return 0;
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e61:	eb d4                	jmp    801e37 <devcons_read+0x11>

00801e63 <cputchar>:
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e6f:	6a 01                	push   $0x1
  801e71:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e74:	50                   	push   %eax
  801e75:	e8 be ee ff ff       	call   800d38 <sys_cputs>
}
  801e7a:	83 c4 10             	add    $0x10,%esp
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <getchar>:
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e85:	6a 01                	push   $0x1
  801e87:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e8a:	50                   	push   %eax
  801e8b:	6a 00                	push   $0x0
  801e8d:	e8 73 f6 ff ff       	call   801505 <read>
	if (r < 0)
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	85 c0                	test   %eax,%eax
  801e97:	78 08                	js     801ea1 <getchar+0x22>
	if (r < 1)
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	7e 06                	jle    801ea3 <getchar+0x24>
	return c;
  801e9d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    
		return -E_EOF;
  801ea3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ea8:	eb f7                	jmp    801ea1 <getchar+0x22>

00801eaa <iscons>:
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb3:	50                   	push   %eax
  801eb4:	ff 75 08             	pushl  0x8(%ebp)
  801eb7:	e8 d8 f3 ff ff       	call   801294 <fd_lookup>
  801ebc:	83 c4 10             	add    $0x10,%esp
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	78 11                	js     801ed4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec6:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801ecc:	39 10                	cmp    %edx,(%eax)
  801ece:	0f 94 c0             	sete   %al
  801ed1:	0f b6 c0             	movzbl %al,%eax
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <opencons>:
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801edc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801edf:	50                   	push   %eax
  801ee0:	e8 60 f3 ff ff       	call   801245 <fd_alloc>
  801ee5:	83 c4 10             	add    $0x10,%esp
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	78 3a                	js     801f26 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801eec:	83 ec 04             	sub    $0x4,%esp
  801eef:	68 07 04 00 00       	push   $0x407
  801ef4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef7:	6a 00                	push   $0x0
  801ef9:	e8 f6 ee ff ff       	call   800df4 <sys_page_alloc>
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 21                	js     801f26 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801f0e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f13:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f1a:	83 ec 0c             	sub    $0xc,%esp
  801f1d:	50                   	push   %eax
  801f1e:	e8 fb f2 ff ff       	call   80121e <fd2num>
  801f23:	83 c4 10             	add    $0x10,%esp
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	53                   	push   %ebx
  801f2c:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f2f:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801f36:	74 0d                	je     801f45 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801f40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801f45:	e8 6c ee ff ff       	call   800db6 <sys_getenvid>
  801f4a:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	6a 07                	push   $0x7
  801f51:	68 00 f0 bf ee       	push   $0xeebff000
  801f56:	50                   	push   %eax
  801f57:	e8 98 ee ff ff       	call   800df4 <sys_page_alloc>
        	if (r < 0) {
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	78 27                	js     801f8a <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801f63:	83 ec 08             	sub    $0x8,%esp
  801f66:	68 9c 1f 80 00       	push   $0x801f9c
  801f6b:	53                   	push   %ebx
  801f6c:	e8 ce ef ff ff       	call   800f3f <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	85 c0                	test   %eax,%eax
  801f76:	79 c0                	jns    801f38 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801f78:	50                   	push   %eax
  801f79:	68 28 29 80 00       	push   $0x802928
  801f7e:	6a 28                	push   $0x28
  801f80:	68 3c 29 80 00       	push   $0x80293c
  801f85:	e8 ac e3 ff ff       	call   800336 <_panic>
            		panic("pgfault_handler: %e", r);
  801f8a:	50                   	push   %eax
  801f8b:	68 28 29 80 00       	push   $0x802928
  801f90:	6a 24                	push   $0x24
  801f92:	68 3c 29 80 00       	push   $0x80293c
  801f97:	e8 9a e3 ff ff       	call   800336 <_panic>

00801f9c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f9c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f9d:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801fa2:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801fa4:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801fa7:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801fab:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801fae:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801fb2:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801fb6:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801fb9:	83 c4 08             	add    $0x8,%esp
	popal
  801fbc:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801fbd:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801fc0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801fc1:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801fc2:	c3                   	ret    

00801fc3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801fc9:	68 4a 29 80 00       	push   $0x80294a
  801fce:	6a 1a                	push   $0x1a
  801fd0:	68 63 29 80 00       	push   $0x802963
  801fd5:	e8 5c e3 ff ff       	call   800336 <_panic>

00801fda <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801fe0:	68 6d 29 80 00       	push   $0x80296d
  801fe5:	6a 2a                	push   $0x2a
  801fe7:	68 63 29 80 00       	push   $0x802963
  801fec:	e8 45 e3 ff ff       	call   800336 <_panic>

00801ff1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801ffc:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fff:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802005:	8b 52 50             	mov    0x50(%edx),%edx
  802008:	39 ca                	cmp    %ecx,%edx
  80200a:	74 11                	je     80201d <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80200c:	83 c0 01             	add    $0x1,%eax
  80200f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802014:	75 e6                	jne    801ffc <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
  80201b:	eb 0b                	jmp    802028 <ipc_find_env+0x37>
			return envs[i].env_id;
  80201d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802020:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802025:	8b 40 48             	mov    0x48(%eax),%eax
}
  802028:	5d                   	pop    %ebp
  802029:	c3                   	ret    

0080202a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802030:	89 d0                	mov    %edx,%eax
  802032:	c1 e8 16             	shr    $0x16,%eax
  802035:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80203c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802041:	f6 c1 01             	test   $0x1,%cl
  802044:	74 1d                	je     802063 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802046:	c1 ea 0c             	shr    $0xc,%edx
  802049:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802050:	f6 c2 01             	test   $0x1,%dl
  802053:	74 0e                	je     802063 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802055:	c1 ea 0c             	shr    $0xc,%edx
  802058:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80205f:	ef 
  802060:	0f b7 c0             	movzwl %ax,%eax
}
  802063:	5d                   	pop    %ebp
  802064:	c3                   	ret    
  802065:	66 90                	xchg   %ax,%ax
  802067:	66 90                	xchg   %ax,%ax
  802069:	66 90                	xchg   %ax,%ax
  80206b:	66 90                	xchg   %ax,%ax
  80206d:	66 90                	xchg   %ax,%ax
  80206f:	90                   	nop

00802070 <__udivdi3>:
  802070:	55                   	push   %ebp
  802071:	57                   	push   %edi
  802072:	56                   	push   %esi
  802073:	53                   	push   %ebx
  802074:	83 ec 1c             	sub    $0x1c,%esp
  802077:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80207b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80207f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802083:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802087:	85 d2                	test   %edx,%edx
  802089:	75 35                	jne    8020c0 <__udivdi3+0x50>
  80208b:	39 f3                	cmp    %esi,%ebx
  80208d:	0f 87 bd 00 00 00    	ja     802150 <__udivdi3+0xe0>
  802093:	85 db                	test   %ebx,%ebx
  802095:	89 d9                	mov    %ebx,%ecx
  802097:	75 0b                	jne    8020a4 <__udivdi3+0x34>
  802099:	b8 01 00 00 00       	mov    $0x1,%eax
  80209e:	31 d2                	xor    %edx,%edx
  8020a0:	f7 f3                	div    %ebx
  8020a2:	89 c1                	mov    %eax,%ecx
  8020a4:	31 d2                	xor    %edx,%edx
  8020a6:	89 f0                	mov    %esi,%eax
  8020a8:	f7 f1                	div    %ecx
  8020aa:	89 c6                	mov    %eax,%esi
  8020ac:	89 e8                	mov    %ebp,%eax
  8020ae:	89 f7                	mov    %esi,%edi
  8020b0:	f7 f1                	div    %ecx
  8020b2:	89 fa                	mov    %edi,%edx
  8020b4:	83 c4 1c             	add    $0x1c,%esp
  8020b7:	5b                   	pop    %ebx
  8020b8:	5e                   	pop    %esi
  8020b9:	5f                   	pop    %edi
  8020ba:	5d                   	pop    %ebp
  8020bb:	c3                   	ret    
  8020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020c0:	39 f2                	cmp    %esi,%edx
  8020c2:	77 7c                	ja     802140 <__udivdi3+0xd0>
  8020c4:	0f bd fa             	bsr    %edx,%edi
  8020c7:	83 f7 1f             	xor    $0x1f,%edi
  8020ca:	0f 84 98 00 00 00    	je     802168 <__udivdi3+0xf8>
  8020d0:	89 f9                	mov    %edi,%ecx
  8020d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020d7:	29 f8                	sub    %edi,%eax
  8020d9:	d3 e2                	shl    %cl,%edx
  8020db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020df:	89 c1                	mov    %eax,%ecx
  8020e1:	89 da                	mov    %ebx,%edx
  8020e3:	d3 ea                	shr    %cl,%edx
  8020e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020e9:	09 d1                	or     %edx,%ecx
  8020eb:	89 f2                	mov    %esi,%edx
  8020ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020f1:	89 f9                	mov    %edi,%ecx
  8020f3:	d3 e3                	shl    %cl,%ebx
  8020f5:	89 c1                	mov    %eax,%ecx
  8020f7:	d3 ea                	shr    %cl,%edx
  8020f9:	89 f9                	mov    %edi,%ecx
  8020fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020ff:	d3 e6                	shl    %cl,%esi
  802101:	89 eb                	mov    %ebp,%ebx
  802103:	89 c1                	mov    %eax,%ecx
  802105:	d3 eb                	shr    %cl,%ebx
  802107:	09 de                	or     %ebx,%esi
  802109:	89 f0                	mov    %esi,%eax
  80210b:	f7 74 24 08          	divl   0x8(%esp)
  80210f:	89 d6                	mov    %edx,%esi
  802111:	89 c3                	mov    %eax,%ebx
  802113:	f7 64 24 0c          	mull   0xc(%esp)
  802117:	39 d6                	cmp    %edx,%esi
  802119:	72 0c                	jb     802127 <__udivdi3+0xb7>
  80211b:	89 f9                	mov    %edi,%ecx
  80211d:	d3 e5                	shl    %cl,%ebp
  80211f:	39 c5                	cmp    %eax,%ebp
  802121:	73 5d                	jae    802180 <__udivdi3+0x110>
  802123:	39 d6                	cmp    %edx,%esi
  802125:	75 59                	jne    802180 <__udivdi3+0x110>
  802127:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80212a:	31 ff                	xor    %edi,%edi
  80212c:	89 fa                	mov    %edi,%edx
  80212e:	83 c4 1c             	add    $0x1c,%esp
  802131:	5b                   	pop    %ebx
  802132:	5e                   	pop    %esi
  802133:	5f                   	pop    %edi
  802134:	5d                   	pop    %ebp
  802135:	c3                   	ret    
  802136:	8d 76 00             	lea    0x0(%esi),%esi
  802139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802140:	31 ff                	xor    %edi,%edi
  802142:	31 c0                	xor    %eax,%eax
  802144:	89 fa                	mov    %edi,%edx
  802146:	83 c4 1c             	add    $0x1c,%esp
  802149:	5b                   	pop    %ebx
  80214a:	5e                   	pop    %esi
  80214b:	5f                   	pop    %edi
  80214c:	5d                   	pop    %ebp
  80214d:	c3                   	ret    
  80214e:	66 90                	xchg   %ax,%ax
  802150:	31 ff                	xor    %edi,%edi
  802152:	89 e8                	mov    %ebp,%eax
  802154:	89 f2                	mov    %esi,%edx
  802156:	f7 f3                	div    %ebx
  802158:	89 fa                	mov    %edi,%edx
  80215a:	83 c4 1c             	add    $0x1c,%esp
  80215d:	5b                   	pop    %ebx
  80215e:	5e                   	pop    %esi
  80215f:	5f                   	pop    %edi
  802160:	5d                   	pop    %ebp
  802161:	c3                   	ret    
  802162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802168:	39 f2                	cmp    %esi,%edx
  80216a:	72 06                	jb     802172 <__udivdi3+0x102>
  80216c:	31 c0                	xor    %eax,%eax
  80216e:	39 eb                	cmp    %ebp,%ebx
  802170:	77 d2                	ja     802144 <__udivdi3+0xd4>
  802172:	b8 01 00 00 00       	mov    $0x1,%eax
  802177:	eb cb                	jmp    802144 <__udivdi3+0xd4>
  802179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802180:	89 d8                	mov    %ebx,%eax
  802182:	31 ff                	xor    %edi,%edi
  802184:	eb be                	jmp    802144 <__udivdi3+0xd4>
  802186:	66 90                	xchg   %ax,%ax
  802188:	66 90                	xchg   %ax,%ax
  80218a:	66 90                	xchg   %ax,%ax
  80218c:	66 90                	xchg   %ax,%ax
  80218e:	66 90                	xchg   %ax,%ax

00802190 <__umoddi3>:
  802190:	55                   	push   %ebp
  802191:	57                   	push   %edi
  802192:	56                   	push   %esi
  802193:	53                   	push   %ebx
  802194:	83 ec 1c             	sub    $0x1c,%esp
  802197:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80219b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80219f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021a7:	85 ed                	test   %ebp,%ebp
  8021a9:	89 f0                	mov    %esi,%eax
  8021ab:	89 da                	mov    %ebx,%edx
  8021ad:	75 19                	jne    8021c8 <__umoddi3+0x38>
  8021af:	39 df                	cmp    %ebx,%edi
  8021b1:	0f 86 b1 00 00 00    	jbe    802268 <__umoddi3+0xd8>
  8021b7:	f7 f7                	div    %edi
  8021b9:	89 d0                	mov    %edx,%eax
  8021bb:	31 d2                	xor    %edx,%edx
  8021bd:	83 c4 1c             	add    $0x1c,%esp
  8021c0:	5b                   	pop    %ebx
  8021c1:	5e                   	pop    %esi
  8021c2:	5f                   	pop    %edi
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    
  8021c5:	8d 76 00             	lea    0x0(%esi),%esi
  8021c8:	39 dd                	cmp    %ebx,%ebp
  8021ca:	77 f1                	ja     8021bd <__umoddi3+0x2d>
  8021cc:	0f bd cd             	bsr    %ebp,%ecx
  8021cf:	83 f1 1f             	xor    $0x1f,%ecx
  8021d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021d6:	0f 84 b4 00 00 00    	je     802290 <__umoddi3+0x100>
  8021dc:	b8 20 00 00 00       	mov    $0x20,%eax
  8021e1:	89 c2                	mov    %eax,%edx
  8021e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021e7:	29 c2                	sub    %eax,%edx
  8021e9:	89 c1                	mov    %eax,%ecx
  8021eb:	89 f8                	mov    %edi,%eax
  8021ed:	d3 e5                	shl    %cl,%ebp
  8021ef:	89 d1                	mov    %edx,%ecx
  8021f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021f5:	d3 e8                	shr    %cl,%eax
  8021f7:	09 c5                	or     %eax,%ebp
  8021f9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021fd:	89 c1                	mov    %eax,%ecx
  8021ff:	d3 e7                	shl    %cl,%edi
  802201:	89 d1                	mov    %edx,%ecx
  802203:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802207:	89 df                	mov    %ebx,%edi
  802209:	d3 ef                	shr    %cl,%edi
  80220b:	89 c1                	mov    %eax,%ecx
  80220d:	89 f0                	mov    %esi,%eax
  80220f:	d3 e3                	shl    %cl,%ebx
  802211:	89 d1                	mov    %edx,%ecx
  802213:	89 fa                	mov    %edi,%edx
  802215:	d3 e8                	shr    %cl,%eax
  802217:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80221c:	09 d8                	or     %ebx,%eax
  80221e:	f7 f5                	div    %ebp
  802220:	d3 e6                	shl    %cl,%esi
  802222:	89 d1                	mov    %edx,%ecx
  802224:	f7 64 24 08          	mull   0x8(%esp)
  802228:	39 d1                	cmp    %edx,%ecx
  80222a:	89 c3                	mov    %eax,%ebx
  80222c:	89 d7                	mov    %edx,%edi
  80222e:	72 06                	jb     802236 <__umoddi3+0xa6>
  802230:	75 0e                	jne    802240 <__umoddi3+0xb0>
  802232:	39 c6                	cmp    %eax,%esi
  802234:	73 0a                	jae    802240 <__umoddi3+0xb0>
  802236:	2b 44 24 08          	sub    0x8(%esp),%eax
  80223a:	19 ea                	sbb    %ebp,%edx
  80223c:	89 d7                	mov    %edx,%edi
  80223e:	89 c3                	mov    %eax,%ebx
  802240:	89 ca                	mov    %ecx,%edx
  802242:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802247:	29 de                	sub    %ebx,%esi
  802249:	19 fa                	sbb    %edi,%edx
  80224b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80224f:	89 d0                	mov    %edx,%eax
  802251:	d3 e0                	shl    %cl,%eax
  802253:	89 d9                	mov    %ebx,%ecx
  802255:	d3 ee                	shr    %cl,%esi
  802257:	d3 ea                	shr    %cl,%edx
  802259:	09 f0                	or     %esi,%eax
  80225b:	83 c4 1c             	add    $0x1c,%esp
  80225e:	5b                   	pop    %ebx
  80225f:	5e                   	pop    %esi
  802260:	5f                   	pop    %edi
  802261:	5d                   	pop    %ebp
  802262:	c3                   	ret    
  802263:	90                   	nop
  802264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802268:	85 ff                	test   %edi,%edi
  80226a:	89 f9                	mov    %edi,%ecx
  80226c:	75 0b                	jne    802279 <__umoddi3+0xe9>
  80226e:	b8 01 00 00 00       	mov    $0x1,%eax
  802273:	31 d2                	xor    %edx,%edx
  802275:	f7 f7                	div    %edi
  802277:	89 c1                	mov    %eax,%ecx
  802279:	89 d8                	mov    %ebx,%eax
  80227b:	31 d2                	xor    %edx,%edx
  80227d:	f7 f1                	div    %ecx
  80227f:	89 f0                	mov    %esi,%eax
  802281:	f7 f1                	div    %ecx
  802283:	e9 31 ff ff ff       	jmp    8021b9 <__umoddi3+0x29>
  802288:	90                   	nop
  802289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802290:	39 dd                	cmp    %ebx,%ebp
  802292:	72 08                	jb     80229c <__umoddi3+0x10c>
  802294:	39 f7                	cmp    %esi,%edi
  802296:	0f 87 21 ff ff ff    	ja     8021bd <__umoddi3+0x2d>
  80229c:	89 da                	mov    %ebx,%edx
  80229e:	89 f0                	mov    %esi,%eax
  8022a0:	29 f8                	sub    %edi,%eax
  8022a2:	19 ea                	sbb    %ebp,%edx
  8022a4:	e9 14 ff ff ff       	jmp    8021bd <__umoddi3+0x2d>
