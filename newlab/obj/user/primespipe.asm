
obj/user/primespipe.debug：     文件格式 elf32-i386


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
  80002c:	e8 04 02 00 00       	call   800235 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	83 ec 04             	sub    $0x4,%esp
  800048:	6a 04                	push   $0x4
  80004a:	56                   	push   %esi
  80004b:	53                   	push   %ebx
  80004c:	e8 9a 14 00 00       	call   8014eb <readn>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	83 f8 04             	cmp    $0x4,%eax
  800057:	75 4b                	jne    8000a4 <primeproc+0x71>
	cprintf("%d\n", p);
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	ff 75 e0             	pushl  -0x20(%ebp)
  80005f:	68 01 22 80 00       	push   $0x802201
  800064:	e8 07 03 00 00       	call   800370 <cprintf>
	if ((i=pipe(pfd)) < 0)
  800069:	89 3c 24             	mov    %edi,(%esp)
  80006c:	e8 ce 1a 00 00       	call   801b3f <pipe>
  800071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	85 c0                	test   %eax,%eax
  800079:	78 49                	js     8000c4 <primeproc+0x91>
		panic("pipe: %e", i);
	if ((id = fork()) < 0)
  80007b:	e8 db 0e 00 00       	call   800f5b <fork>
  800080:	85 c0                	test   %eax,%eax
  800082:	78 52                	js     8000d6 <primeproc+0xa3>
		panic("fork: %e", id);
	if (id == 0) {
  800084:	85 c0                	test   %eax,%eax
  800086:	75 60                	jne    8000e8 <primeproc+0xb5>
		close(fd);
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	53                   	push   %ebx
  80008c:	e8 97 12 00 00       	call   801328 <close>
		close(pfd[1]);
  800091:	83 c4 04             	add    $0x4,%esp
  800094:	ff 75 dc             	pushl  -0x24(%ebp)
  800097:	e8 8c 12 00 00       	call   801328 <close>
		fd = pfd[0];
  80009c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	eb a1                	jmp    800045 <primeproc+0x12>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	85 c0                	test   %eax,%eax
  8000a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ae:	0f 4e d0             	cmovle %eax,%edx
  8000b1:	52                   	push   %edx
  8000b2:	50                   	push   %eax
  8000b3:	68 c0 21 80 00       	push   $0x8021c0
  8000b8:	6a 15                	push   $0x15
  8000ba:	68 ef 21 80 00       	push   $0x8021ef
  8000bf:	e8 d1 01 00 00       	call   800295 <_panic>
		panic("pipe: %e", i);
  8000c4:	50                   	push   %eax
  8000c5:	68 05 22 80 00       	push   $0x802205
  8000ca:	6a 1b                	push   $0x1b
  8000cc:	68 ef 21 80 00       	push   $0x8021ef
  8000d1:	e8 bf 01 00 00       	call   800295 <_panic>
		panic("fork: %e", id);
  8000d6:	50                   	push   %eax
  8000d7:	68 0e 22 80 00       	push   $0x80220e
  8000dc:	6a 1d                	push   $0x1d
  8000de:	68 ef 21 80 00       	push   $0x8021ef
  8000e3:	e8 ad 01 00 00       	call   800295 <_panic>
	}

	close(pfd[0]);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8000ee:	e8 35 12 00 00       	call   801328 <close>
	wfd = pfd[1];
  8000f3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f6:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000f9:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 04                	push   $0x4
  800101:	56                   	push   %esi
  800102:	53                   	push   %ebx
  800103:	e8 e3 13 00 00       	call   8014eb <readn>
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	83 f8 04             	cmp    $0x4,%eax
  80010e:	75 42                	jne    800152 <primeproc+0x11f>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  800110:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800113:	99                   	cltd   
  800114:	f7 7d e0             	idivl  -0x20(%ebp)
  800117:	85 d2                	test   %edx,%edx
  800119:	74 e1                	je     8000fc <primeproc+0xc9>
			if ((r=write(wfd, &i, 4)) != 4)
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 04                	push   $0x4
  800120:	56                   	push   %esi
  800121:	57                   	push   %edi
  800122:	e8 0b 14 00 00       	call   801532 <write>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	83 f8 04             	cmp    $0x4,%eax
  80012d:	74 cd                	je     8000fc <primeproc+0xc9>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80012f:	83 ec 08             	sub    $0x8,%esp
  800132:	85 c0                	test   %eax,%eax
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
  800139:	0f 4e d0             	cmovle %eax,%edx
  80013c:	52                   	push   %edx
  80013d:	50                   	push   %eax
  80013e:	ff 75 e0             	pushl  -0x20(%ebp)
  800141:	68 33 22 80 00       	push   $0x802233
  800146:	6a 2e                	push   $0x2e
  800148:	68 ef 21 80 00       	push   $0x8021ef
  80014d:	e8 43 01 00 00       	call   800295 <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	85 c0                	test   %eax,%eax
  800157:	ba 00 00 00 00       	mov    $0x0,%edx
  80015c:	0f 4e d0             	cmovle %eax,%edx
  80015f:	52                   	push   %edx
  800160:	50                   	push   %eax
  800161:	53                   	push   %ebx
  800162:	ff 75 e0             	pushl  -0x20(%ebp)
  800165:	68 17 22 80 00       	push   $0x802217
  80016a:	6a 2b                	push   $0x2b
  80016c:	68 ef 21 80 00       	push   $0x8021ef
  800171:	e8 1f 01 00 00       	call   800295 <_panic>

00800176 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	53                   	push   %ebx
  80017a:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  80017d:	c7 05 00 30 80 00 4d 	movl   $0x80224d,0x803000
  800184:	22 80 00 

	if ((i=pipe(p)) < 0)
  800187:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80018a:	50                   	push   %eax
  80018b:	e8 af 19 00 00       	call   801b3f <pipe>
  800190:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	85 c0                	test   %eax,%eax
  800198:	78 23                	js     8001bd <umain+0x47>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  80019a:	e8 bc 0d 00 00       	call   800f5b <fork>
  80019f:	85 c0                	test   %eax,%eax
  8001a1:	78 2c                	js     8001cf <umain+0x59>
		panic("fork: %e", id);

	if (id == 0) {
  8001a3:	85 c0                	test   %eax,%eax
  8001a5:	75 3a                	jne    8001e1 <umain+0x6b>
		close(p[1]);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ad:	e8 76 11 00 00       	call   801328 <close>
		primeproc(p[0]);
  8001b2:	83 c4 04             	add    $0x4,%esp
  8001b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b8:	e8 76 fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001bd:	50                   	push   %eax
  8001be:	68 05 22 80 00       	push   $0x802205
  8001c3:	6a 3a                	push   $0x3a
  8001c5:	68 ef 21 80 00       	push   $0x8021ef
  8001ca:	e8 c6 00 00 00       	call   800295 <_panic>
		panic("fork: %e", id);
  8001cf:	50                   	push   %eax
  8001d0:	68 0e 22 80 00       	push   $0x80220e
  8001d5:	6a 3e                	push   $0x3e
  8001d7:	68 ef 21 80 00       	push   $0x8021ef
  8001dc:	e8 b4 00 00 00       	call   800295 <_panic>
	}

	close(p[0]);
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e7:	e8 3c 11 00 00       	call   801328 <close>

	// feed all the integers through
	for (i=2;; i++)
  8001ec:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001f3:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001f6:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001f9:	83 ec 04             	sub    $0x4,%esp
  8001fc:	6a 04                	push   $0x4
  8001fe:	53                   	push   %ebx
  8001ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800202:	e8 2b 13 00 00       	call   801532 <write>
  800207:	83 c4 10             	add    $0x10,%esp
  80020a:	83 f8 04             	cmp    $0x4,%eax
  80020d:	75 06                	jne    800215 <umain+0x9f>
	for (i=2;; i++)
  80020f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  800213:	eb e4                	jmp    8001f9 <umain+0x83>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	85 c0                	test   %eax,%eax
  80021a:	ba 00 00 00 00       	mov    $0x0,%edx
  80021f:	0f 4e d0             	cmovle %eax,%edx
  800222:	52                   	push   %edx
  800223:	50                   	push   %eax
  800224:	68 58 22 80 00       	push   $0x802258
  800229:	6a 4a                	push   $0x4a
  80022b:	68 ef 21 80 00       	push   $0x8021ef
  800230:	e8 60 00 00 00       	call   800295 <_panic>

00800235 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	56                   	push   %esi
  800239:	53                   	push   %ebx
  80023a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80023d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800240:	e8 d0 0a 00 00       	call   800d15 <sys_getenvid>
  800245:	25 ff 03 00 00       	and    $0x3ff,%eax
  80024a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80024d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800252:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800257:	85 db                	test   %ebx,%ebx
  800259:	7e 07                	jle    800262 <libmain+0x2d>
		binaryname = argv[0];
  80025b:	8b 06                	mov    (%esi),%eax
  80025d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	e8 0a ff ff ff       	call   800176 <umain>

	// exit gracefully
	exit();
  80026c:	e8 0a 00 00 00       	call   80027b <exit>
}
  800271:	83 c4 10             	add    $0x10,%esp
  800274:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800277:	5b                   	pop    %ebx
  800278:	5e                   	pop    %esi
  800279:	5d                   	pop    %ebp
  80027a:	c3                   	ret    

0080027b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800281:	e8 cd 10 00 00       	call   801353 <close_all>
	sys_env_destroy(0);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	6a 00                	push   $0x0
  80028b:	e8 44 0a 00 00       	call   800cd4 <sys_env_destroy>
}
  800290:	83 c4 10             	add    $0x10,%esp
  800293:	c9                   	leave  
  800294:	c3                   	ret    

00800295 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80029a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80029d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002a3:	e8 6d 0a 00 00       	call   800d15 <sys_getenvid>
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	ff 75 0c             	pushl  0xc(%ebp)
  8002ae:	ff 75 08             	pushl  0x8(%ebp)
  8002b1:	56                   	push   %esi
  8002b2:	50                   	push   %eax
  8002b3:	68 7c 22 80 00       	push   $0x80227c
  8002b8:	e8 b3 00 00 00       	call   800370 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002bd:	83 c4 18             	add    $0x18,%esp
  8002c0:	53                   	push   %ebx
  8002c1:	ff 75 10             	pushl  0x10(%ebp)
  8002c4:	e8 56 00 00 00       	call   80031f <vcprintf>
	cprintf("\n");
  8002c9:	c7 04 24 03 22 80 00 	movl   $0x802203,(%esp)
  8002d0:	e8 9b 00 00 00       	call   800370 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d8:	cc                   	int3   
  8002d9:	eb fd                	jmp    8002d8 <_panic+0x43>

008002db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	53                   	push   %ebx
  8002df:	83 ec 04             	sub    $0x4,%esp
  8002e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002e5:	8b 13                	mov    (%ebx),%edx
  8002e7:	8d 42 01             	lea    0x1(%edx),%eax
  8002ea:	89 03                	mov    %eax,(%ebx)
  8002ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ef:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f8:	74 09                	je     800303 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002fa:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800301:	c9                   	leave  
  800302:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800303:	83 ec 08             	sub    $0x8,%esp
  800306:	68 ff 00 00 00       	push   $0xff
  80030b:	8d 43 08             	lea    0x8(%ebx),%eax
  80030e:	50                   	push   %eax
  80030f:	e8 83 09 00 00       	call   800c97 <sys_cputs>
		b->idx = 0;
  800314:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	eb db                	jmp    8002fa <putch+0x1f>

0080031f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800328:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032f:	00 00 00 
	b.cnt = 0;
  800332:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800339:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80033c:	ff 75 0c             	pushl  0xc(%ebp)
  80033f:	ff 75 08             	pushl  0x8(%ebp)
  800342:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800348:	50                   	push   %eax
  800349:	68 db 02 80 00       	push   $0x8002db
  80034e:	e8 1a 01 00 00       	call   80046d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800353:	83 c4 08             	add    $0x8,%esp
  800356:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80035c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800362:	50                   	push   %eax
  800363:	e8 2f 09 00 00       	call   800c97 <sys_cputs>

	return b.cnt;
}
  800368:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800376:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800379:	50                   	push   %eax
  80037a:	ff 75 08             	pushl  0x8(%ebp)
  80037d:	e8 9d ff ff ff       	call   80031f <vcprintf>
	va_end(ap);

	return cnt;
}
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	57                   	push   %edi
  800388:	56                   	push   %esi
  800389:	53                   	push   %ebx
  80038a:	83 ec 1c             	sub    $0x1c,%esp
  80038d:	89 c7                	mov    %eax,%edi
  80038f:	89 d6                	mov    %edx,%esi
  800391:	8b 45 08             	mov    0x8(%ebp),%eax
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80039d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003a8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003ab:	39 d3                	cmp    %edx,%ebx
  8003ad:	72 05                	jb     8003b4 <printnum+0x30>
  8003af:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003b2:	77 7a                	ja     80042e <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	ff 75 18             	pushl  0x18(%ebp)
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003c0:	53                   	push   %ebx
  8003c1:	ff 75 10             	pushl  0x10(%ebp)
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8003cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d3:	e8 a8 1b 00 00       	call   801f80 <__udivdi3>
  8003d8:	83 c4 18             	add    $0x18,%esp
  8003db:	52                   	push   %edx
  8003dc:	50                   	push   %eax
  8003dd:	89 f2                	mov    %esi,%edx
  8003df:	89 f8                	mov    %edi,%eax
  8003e1:	e8 9e ff ff ff       	call   800384 <printnum>
  8003e6:	83 c4 20             	add    $0x20,%esp
  8003e9:	eb 13                	jmp    8003fe <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	56                   	push   %esi
  8003ef:	ff 75 18             	pushl  0x18(%ebp)
  8003f2:	ff d7                	call   *%edi
  8003f4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003f7:	83 eb 01             	sub    $0x1,%ebx
  8003fa:	85 db                	test   %ebx,%ebx
  8003fc:	7f ed                	jg     8003eb <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003fe:	83 ec 08             	sub    $0x8,%esp
  800401:	56                   	push   %esi
  800402:	83 ec 04             	sub    $0x4,%esp
  800405:	ff 75 e4             	pushl  -0x1c(%ebp)
  800408:	ff 75 e0             	pushl  -0x20(%ebp)
  80040b:	ff 75 dc             	pushl  -0x24(%ebp)
  80040e:	ff 75 d8             	pushl  -0x28(%ebp)
  800411:	e8 8a 1c 00 00       	call   8020a0 <__umoddi3>
  800416:	83 c4 14             	add    $0x14,%esp
  800419:	0f be 80 9f 22 80 00 	movsbl 0x80229f(%eax),%eax
  800420:	50                   	push   %eax
  800421:	ff d7                	call   *%edi
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800429:	5b                   	pop    %ebx
  80042a:	5e                   	pop    %esi
  80042b:	5f                   	pop    %edi
  80042c:	5d                   	pop    %ebp
  80042d:	c3                   	ret    
  80042e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800431:	eb c4                	jmp    8003f7 <printnum+0x73>

00800433 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800439:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80043d:	8b 10                	mov    (%eax),%edx
  80043f:	3b 50 04             	cmp    0x4(%eax),%edx
  800442:	73 0a                	jae    80044e <sprintputch+0x1b>
		*b->buf++ = ch;
  800444:	8d 4a 01             	lea    0x1(%edx),%ecx
  800447:	89 08                	mov    %ecx,(%eax)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	88 02                	mov    %al,(%edx)
}
  80044e:	5d                   	pop    %ebp
  80044f:	c3                   	ret    

00800450 <printfmt>:
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800456:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800459:	50                   	push   %eax
  80045a:	ff 75 10             	pushl  0x10(%ebp)
  80045d:	ff 75 0c             	pushl  0xc(%ebp)
  800460:	ff 75 08             	pushl  0x8(%ebp)
  800463:	e8 05 00 00 00       	call   80046d <vprintfmt>
}
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	c9                   	leave  
  80046c:	c3                   	ret    

0080046d <vprintfmt>:
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
  800470:	57                   	push   %edi
  800471:	56                   	push   %esi
  800472:	53                   	push   %ebx
  800473:	83 ec 2c             	sub    $0x2c,%esp
  800476:	8b 75 08             	mov    0x8(%ebp),%esi
  800479:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80047c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80047f:	e9 8c 03 00 00       	jmp    800810 <vprintfmt+0x3a3>
		padc = ' ';
  800484:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800488:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80048f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800496:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80049d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a2:	8d 47 01             	lea    0x1(%edi),%eax
  8004a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004a8:	0f b6 17             	movzbl (%edi),%edx
  8004ab:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004ae:	3c 55                	cmp    $0x55,%al
  8004b0:	0f 87 dd 03 00 00    	ja     800893 <vprintfmt+0x426>
  8004b6:	0f b6 c0             	movzbl %al,%eax
  8004b9:	ff 24 85 e0 23 80 00 	jmp    *0x8023e0(,%eax,4)
  8004c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004c3:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004c7:	eb d9                	jmp    8004a2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004cc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004d0:	eb d0                	jmp    8004a2 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004d2:	0f b6 d2             	movzbl %dl,%edx
  8004d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004e3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004e7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004ea:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004ed:	83 f9 09             	cmp    $0x9,%ecx
  8004f0:	77 55                	ja     800547 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8004f2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004f5:	eb e9                	jmp    8004e0 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8d 40 04             	lea    0x4(%eax),%eax
  800505:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800508:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80050b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80050f:	79 91                	jns    8004a2 <vprintfmt+0x35>
				width = precision, precision = -1;
  800511:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800514:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800517:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80051e:	eb 82                	jmp    8004a2 <vprintfmt+0x35>
  800520:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800523:	85 c0                	test   %eax,%eax
  800525:	ba 00 00 00 00       	mov    $0x0,%edx
  80052a:	0f 49 d0             	cmovns %eax,%edx
  80052d:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800530:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800533:	e9 6a ff ff ff       	jmp    8004a2 <vprintfmt+0x35>
  800538:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80053b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800542:	e9 5b ff ff ff       	jmp    8004a2 <vprintfmt+0x35>
  800547:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80054a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80054d:	eb bc                	jmp    80050b <vprintfmt+0x9e>
			lflag++;
  80054f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800555:	e9 48 ff ff ff       	jmp    8004a2 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8d 78 04             	lea    0x4(%eax),%edi
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	53                   	push   %ebx
  800564:	ff 30                	pushl  (%eax)
  800566:	ff d6                	call   *%esi
			break;
  800568:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80056b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80056e:	e9 9a 02 00 00       	jmp    80080d <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8d 78 04             	lea    0x4(%eax),%edi
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	99                   	cltd   
  80057c:	31 d0                	xor    %edx,%eax
  80057e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800580:	83 f8 0f             	cmp    $0xf,%eax
  800583:	7f 23                	jg     8005a8 <vprintfmt+0x13b>
  800585:	8b 14 85 40 25 80 00 	mov    0x802540(,%eax,4),%edx
  80058c:	85 d2                	test   %edx,%edx
  80058e:	74 18                	je     8005a8 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800590:	52                   	push   %edx
  800591:	68 2d 27 80 00       	push   $0x80272d
  800596:	53                   	push   %ebx
  800597:	56                   	push   %esi
  800598:	e8 b3 fe ff ff       	call   800450 <printfmt>
  80059d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005a0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a3:	e9 65 02 00 00       	jmp    80080d <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8005a8:	50                   	push   %eax
  8005a9:	68 b7 22 80 00       	push   $0x8022b7
  8005ae:	53                   	push   %ebx
  8005af:	56                   	push   %esi
  8005b0:	e8 9b fe ff ff       	call   800450 <printfmt>
  8005b5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005bb:	e9 4d 02 00 00       	jmp    80080d <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	83 c0 04             	add    $0x4,%eax
  8005c6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8005ce:	85 ff                	test   %edi,%edi
  8005d0:	b8 b0 22 80 00       	mov    $0x8022b0,%eax
  8005d5:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8005d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005dc:	0f 8e bd 00 00 00    	jle    80069f <vprintfmt+0x232>
  8005e2:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005e6:	75 0e                	jne    8005f6 <vprintfmt+0x189>
  8005e8:	89 75 08             	mov    %esi,0x8(%ebp)
  8005eb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005ee:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005f1:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005f4:	eb 6d                	jmp    800663 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	ff 75 d0             	pushl  -0x30(%ebp)
  8005fc:	57                   	push   %edi
  8005fd:	e8 39 03 00 00       	call   80093b <strnlen>
  800602:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800605:	29 c1                	sub    %eax,%ecx
  800607:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80060a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80060d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800611:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800614:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800617:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800619:	eb 0f                	jmp    80062a <vprintfmt+0x1bd>
					putch(padc, putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	ff 75 e0             	pushl  -0x20(%ebp)
  800622:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800624:	83 ef 01             	sub    $0x1,%edi
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	85 ff                	test   %edi,%edi
  80062c:	7f ed                	jg     80061b <vprintfmt+0x1ae>
  80062e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800631:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800634:	85 c9                	test   %ecx,%ecx
  800636:	b8 00 00 00 00       	mov    $0x0,%eax
  80063b:	0f 49 c1             	cmovns %ecx,%eax
  80063e:	29 c1                	sub    %eax,%ecx
  800640:	89 75 08             	mov    %esi,0x8(%ebp)
  800643:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800646:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800649:	89 cb                	mov    %ecx,%ebx
  80064b:	eb 16                	jmp    800663 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80064d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800651:	75 31                	jne    800684 <vprintfmt+0x217>
					putch(ch, putdat);
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	ff 75 0c             	pushl  0xc(%ebp)
  800659:	50                   	push   %eax
  80065a:	ff 55 08             	call   *0x8(%ebp)
  80065d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800660:	83 eb 01             	sub    $0x1,%ebx
  800663:	83 c7 01             	add    $0x1,%edi
  800666:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80066a:	0f be c2             	movsbl %dl,%eax
  80066d:	85 c0                	test   %eax,%eax
  80066f:	74 59                	je     8006ca <vprintfmt+0x25d>
  800671:	85 f6                	test   %esi,%esi
  800673:	78 d8                	js     80064d <vprintfmt+0x1e0>
  800675:	83 ee 01             	sub    $0x1,%esi
  800678:	79 d3                	jns    80064d <vprintfmt+0x1e0>
  80067a:	89 df                	mov    %ebx,%edi
  80067c:	8b 75 08             	mov    0x8(%ebp),%esi
  80067f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800682:	eb 37                	jmp    8006bb <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800684:	0f be d2             	movsbl %dl,%edx
  800687:	83 ea 20             	sub    $0x20,%edx
  80068a:	83 fa 5e             	cmp    $0x5e,%edx
  80068d:	76 c4                	jbe    800653 <vprintfmt+0x1e6>
					putch('?', putdat);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 0c             	pushl  0xc(%ebp)
  800695:	6a 3f                	push   $0x3f
  800697:	ff 55 08             	call   *0x8(%ebp)
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	eb c1                	jmp    800660 <vprintfmt+0x1f3>
  80069f:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006a8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006ab:	eb b6                	jmp    800663 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 20                	push   $0x20
  8006b3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006b5:	83 ef 01             	sub    $0x1,%edi
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	85 ff                	test   %edi,%edi
  8006bd:	7f ee                	jg     8006ad <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8006bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c5:	e9 43 01 00 00       	jmp    80080d <vprintfmt+0x3a0>
  8006ca:	89 df                	mov    %ebx,%edi
  8006cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8006cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006d2:	eb e7                	jmp    8006bb <vprintfmt+0x24e>
	if (lflag >= 2)
  8006d4:	83 f9 01             	cmp    $0x1,%ecx
  8006d7:	7e 3f                	jle    800718 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 50 04             	mov    0x4(%eax),%edx
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 40 08             	lea    0x8(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f4:	79 5c                	jns    800752 <vprintfmt+0x2e5>
				putch('-', putdat);
  8006f6:	83 ec 08             	sub    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	6a 2d                	push   $0x2d
  8006fc:	ff d6                	call   *%esi
				num = -(long long) num;
  8006fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800701:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800704:	f7 da                	neg    %edx
  800706:	83 d1 00             	adc    $0x0,%ecx
  800709:	f7 d9                	neg    %ecx
  80070b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80070e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800713:	e9 db 00 00 00       	jmp    8007f3 <vprintfmt+0x386>
	else if (lflag)
  800718:	85 c9                	test   %ecx,%ecx
  80071a:	75 1b                	jne    800737 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800724:	89 c1                	mov    %eax,%ecx
  800726:	c1 f9 1f             	sar    $0x1f,%ecx
  800729:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
  800735:	eb b9                	jmp    8006f0 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073f:	89 c1                	mov    %eax,%ecx
  800741:	c1 f9 1f             	sar    $0x1f,%ecx
  800744:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 40 04             	lea    0x4(%eax),%eax
  80074d:	89 45 14             	mov    %eax,0x14(%ebp)
  800750:	eb 9e                	jmp    8006f0 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800752:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800755:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800758:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075d:	e9 91 00 00 00       	jmp    8007f3 <vprintfmt+0x386>
	if (lflag >= 2)
  800762:	83 f9 01             	cmp    $0x1,%ecx
  800765:	7e 15                	jle    80077c <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8b 10                	mov    (%eax),%edx
  80076c:	8b 48 04             	mov    0x4(%eax),%ecx
  80076f:	8d 40 08             	lea    0x8(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800775:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077a:	eb 77                	jmp    8007f3 <vprintfmt+0x386>
	else if (lflag)
  80077c:	85 c9                	test   %ecx,%ecx
  80077e:	75 17                	jne    800797 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8b 10                	mov    (%eax),%edx
  800785:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078a:	8d 40 04             	lea    0x4(%eax),%eax
  80078d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800790:	b8 0a 00 00 00       	mov    $0xa,%eax
  800795:	eb 5c                	jmp    8007f3 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8b 10                	mov    (%eax),%edx
  80079c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a1:	8d 40 04             	lea    0x4(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ac:	eb 45                	jmp    8007f3 <vprintfmt+0x386>
			putch('X', putdat);
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	53                   	push   %ebx
  8007b2:	6a 58                	push   $0x58
  8007b4:	ff d6                	call   *%esi
			putch('X', putdat);
  8007b6:	83 c4 08             	add    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	6a 58                	push   $0x58
  8007bc:	ff d6                	call   *%esi
			putch('X', putdat);
  8007be:	83 c4 08             	add    $0x8,%esp
  8007c1:	53                   	push   %ebx
  8007c2:	6a 58                	push   $0x58
  8007c4:	ff d6                	call   *%esi
			break;
  8007c6:	83 c4 10             	add    $0x10,%esp
  8007c9:	eb 42                	jmp    80080d <vprintfmt+0x3a0>
			putch('0', putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	53                   	push   %ebx
  8007cf:	6a 30                	push   $0x30
  8007d1:	ff d6                	call   *%esi
			putch('x', putdat);
  8007d3:	83 c4 08             	add    $0x8,%esp
  8007d6:	53                   	push   %ebx
  8007d7:	6a 78                	push   $0x78
  8007d9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 10                	mov    (%eax),%edx
  8007e0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007e5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007e8:	8d 40 04             	lea    0x4(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ee:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007f3:	83 ec 0c             	sub    $0xc,%esp
  8007f6:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007fa:	57                   	push   %edi
  8007fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8007fe:	50                   	push   %eax
  8007ff:	51                   	push   %ecx
  800800:	52                   	push   %edx
  800801:	89 da                	mov    %ebx,%edx
  800803:	89 f0                	mov    %esi,%eax
  800805:	e8 7a fb ff ff       	call   800384 <printnum>
			break;
  80080a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80080d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800810:	83 c7 01             	add    $0x1,%edi
  800813:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800817:	83 f8 25             	cmp    $0x25,%eax
  80081a:	0f 84 64 fc ff ff    	je     800484 <vprintfmt+0x17>
			if (ch == '\0')
  800820:	85 c0                	test   %eax,%eax
  800822:	0f 84 8b 00 00 00    	je     8008b3 <vprintfmt+0x446>
			putch(ch, putdat);
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	53                   	push   %ebx
  80082c:	50                   	push   %eax
  80082d:	ff d6                	call   *%esi
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	eb dc                	jmp    800810 <vprintfmt+0x3a3>
	if (lflag >= 2)
  800834:	83 f9 01             	cmp    $0x1,%ecx
  800837:	7e 15                	jle    80084e <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	8b 10                	mov    (%eax),%edx
  80083e:	8b 48 04             	mov    0x4(%eax),%ecx
  800841:	8d 40 08             	lea    0x8(%eax),%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800847:	b8 10 00 00 00       	mov    $0x10,%eax
  80084c:	eb a5                	jmp    8007f3 <vprintfmt+0x386>
	else if (lflag)
  80084e:	85 c9                	test   %ecx,%ecx
  800850:	75 17                	jne    800869 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8b 10                	mov    (%eax),%edx
  800857:	b9 00 00 00 00       	mov    $0x0,%ecx
  80085c:	8d 40 04             	lea    0x4(%eax),%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800862:	b8 10 00 00 00       	mov    $0x10,%eax
  800867:	eb 8a                	jmp    8007f3 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	8b 10                	mov    (%eax),%edx
  80086e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800873:	8d 40 04             	lea    0x4(%eax),%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800879:	b8 10 00 00 00       	mov    $0x10,%eax
  80087e:	e9 70 ff ff ff       	jmp    8007f3 <vprintfmt+0x386>
			putch(ch, putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	53                   	push   %ebx
  800887:	6a 25                	push   $0x25
  800889:	ff d6                	call   *%esi
			break;
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	e9 7a ff ff ff       	jmp    80080d <vprintfmt+0x3a0>
			putch('%', putdat);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	53                   	push   %ebx
  800897:	6a 25                	push   $0x25
  800899:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80089b:	83 c4 10             	add    $0x10,%esp
  80089e:	89 f8                	mov    %edi,%eax
  8008a0:	eb 03                	jmp    8008a5 <vprintfmt+0x438>
  8008a2:	83 e8 01             	sub    $0x1,%eax
  8008a5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008a9:	75 f7                	jne    8008a2 <vprintfmt+0x435>
  8008ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ae:	e9 5a ff ff ff       	jmp    80080d <vprintfmt+0x3a0>
}
  8008b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008b6:	5b                   	pop    %ebx
  8008b7:	5e                   	pop    %esi
  8008b8:	5f                   	pop    %edi
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	83 ec 18             	sub    $0x18,%esp
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ca:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008ce:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d8:	85 c0                	test   %eax,%eax
  8008da:	74 26                	je     800902 <vsnprintf+0x47>
  8008dc:	85 d2                	test   %edx,%edx
  8008de:	7e 22                	jle    800902 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e0:	ff 75 14             	pushl  0x14(%ebp)
  8008e3:	ff 75 10             	pushl  0x10(%ebp)
  8008e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008e9:	50                   	push   %eax
  8008ea:	68 33 04 80 00       	push   $0x800433
  8008ef:	e8 79 fb ff ff       	call   80046d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008fd:	83 c4 10             	add    $0x10,%esp
}
  800900:	c9                   	leave  
  800901:	c3                   	ret    
		return -E_INVAL;
  800902:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800907:	eb f7                	jmp    800900 <vsnprintf+0x45>

00800909 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80090f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800912:	50                   	push   %eax
  800913:	ff 75 10             	pushl  0x10(%ebp)
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	ff 75 08             	pushl  0x8(%ebp)
  80091c:	e8 9a ff ff ff       	call   8008bb <vsnprintf>
	va_end(ap);

	return rc;
}
  800921:	c9                   	leave  
  800922:	c3                   	ret    

00800923 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800929:	b8 00 00 00 00       	mov    $0x0,%eax
  80092e:	eb 03                	jmp    800933 <strlen+0x10>
		n++;
  800930:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800933:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800937:	75 f7                	jne    800930 <strlen+0xd>
	return n;
}
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800941:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
  800949:	eb 03                	jmp    80094e <strnlen+0x13>
		n++;
  80094b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094e:	39 d0                	cmp    %edx,%eax
  800950:	74 06                	je     800958 <strnlen+0x1d>
  800952:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800956:	75 f3                	jne    80094b <strnlen+0x10>
	return n;
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	53                   	push   %ebx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800964:	89 c2                	mov    %eax,%edx
  800966:	83 c1 01             	add    $0x1,%ecx
  800969:	83 c2 01             	add    $0x1,%edx
  80096c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800970:	88 5a ff             	mov    %bl,-0x1(%edx)
  800973:	84 db                	test   %bl,%bl
  800975:	75 ef                	jne    800966 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800977:	5b                   	pop    %ebx
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	53                   	push   %ebx
  80097e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800981:	53                   	push   %ebx
  800982:	e8 9c ff ff ff       	call   800923 <strlen>
  800987:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	01 d8                	add    %ebx,%eax
  80098f:	50                   	push   %eax
  800990:	e8 c5 ff ff ff       	call   80095a <strcpy>
	return dst;
}
  800995:	89 d8                	mov    %ebx,%eax
  800997:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	56                   	push   %esi
  8009a0:	53                   	push   %ebx
  8009a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a7:	89 f3                	mov    %esi,%ebx
  8009a9:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ac:	89 f2                	mov    %esi,%edx
  8009ae:	eb 0f                	jmp    8009bf <strncpy+0x23>
		*dst++ = *src;
  8009b0:	83 c2 01             	add    $0x1,%edx
  8009b3:	0f b6 01             	movzbl (%ecx),%eax
  8009b6:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b9:	80 39 01             	cmpb   $0x1,(%ecx)
  8009bc:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009bf:	39 da                	cmp    %ebx,%edx
  8009c1:	75 ed                	jne    8009b0 <strncpy+0x14>
	}
	return ret;
}
  8009c3:	89 f0                	mov    %esi,%eax
  8009c5:	5b                   	pop    %ebx
  8009c6:	5e                   	pop    %esi
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	56                   	push   %esi
  8009cd:	53                   	push   %ebx
  8009ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009d7:	89 f0                	mov    %esi,%eax
  8009d9:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009dd:	85 c9                	test   %ecx,%ecx
  8009df:	75 0b                	jne    8009ec <strlcpy+0x23>
  8009e1:	eb 17                	jmp    8009fa <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009e3:	83 c2 01             	add    $0x1,%edx
  8009e6:	83 c0 01             	add    $0x1,%eax
  8009e9:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009ec:	39 d8                	cmp    %ebx,%eax
  8009ee:	74 07                	je     8009f7 <strlcpy+0x2e>
  8009f0:	0f b6 0a             	movzbl (%edx),%ecx
  8009f3:	84 c9                	test   %cl,%cl
  8009f5:	75 ec                	jne    8009e3 <strlcpy+0x1a>
		*dst = '\0';
  8009f7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009fa:	29 f0                	sub    %esi,%eax
}
  8009fc:	5b                   	pop    %ebx
  8009fd:	5e                   	pop    %esi
  8009fe:	5d                   	pop    %ebp
  8009ff:	c3                   	ret    

00800a00 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a06:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a09:	eb 06                	jmp    800a11 <strcmp+0x11>
		p++, q++;
  800a0b:	83 c1 01             	add    $0x1,%ecx
  800a0e:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a11:	0f b6 01             	movzbl (%ecx),%eax
  800a14:	84 c0                	test   %al,%al
  800a16:	74 04                	je     800a1c <strcmp+0x1c>
  800a18:	3a 02                	cmp    (%edx),%al
  800a1a:	74 ef                	je     800a0b <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1c:	0f b6 c0             	movzbl %al,%eax
  800a1f:	0f b6 12             	movzbl (%edx),%edx
  800a22:	29 d0                	sub    %edx,%eax
}
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	53                   	push   %ebx
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a30:	89 c3                	mov    %eax,%ebx
  800a32:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a35:	eb 06                	jmp    800a3d <strncmp+0x17>
		n--, p++, q++;
  800a37:	83 c0 01             	add    $0x1,%eax
  800a3a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a3d:	39 d8                	cmp    %ebx,%eax
  800a3f:	74 16                	je     800a57 <strncmp+0x31>
  800a41:	0f b6 08             	movzbl (%eax),%ecx
  800a44:	84 c9                	test   %cl,%cl
  800a46:	74 04                	je     800a4c <strncmp+0x26>
  800a48:	3a 0a                	cmp    (%edx),%cl
  800a4a:	74 eb                	je     800a37 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4c:	0f b6 00             	movzbl (%eax),%eax
  800a4f:	0f b6 12             	movzbl (%edx),%edx
  800a52:	29 d0                	sub    %edx,%eax
}
  800a54:	5b                   	pop    %ebx
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    
		return 0;
  800a57:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5c:	eb f6                	jmp    800a54 <strncmp+0x2e>

00800a5e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a68:	0f b6 10             	movzbl (%eax),%edx
  800a6b:	84 d2                	test   %dl,%dl
  800a6d:	74 09                	je     800a78 <strchr+0x1a>
		if (*s == c)
  800a6f:	38 ca                	cmp    %cl,%dl
  800a71:	74 0a                	je     800a7d <strchr+0x1f>
	for (; *s; s++)
  800a73:	83 c0 01             	add    $0x1,%eax
  800a76:	eb f0                	jmp    800a68 <strchr+0xa>
			return (char *) s;
	return 0;
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7d:	5d                   	pop    %ebp
  800a7e:	c3                   	ret    

00800a7f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a89:	eb 03                	jmp    800a8e <strfind+0xf>
  800a8b:	83 c0 01             	add    $0x1,%eax
  800a8e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a91:	38 ca                	cmp    %cl,%dl
  800a93:	74 04                	je     800a99 <strfind+0x1a>
  800a95:	84 d2                	test   %dl,%dl
  800a97:	75 f2                	jne    800a8b <strfind+0xc>
			break;
	return (char *) s;
}
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	57                   	push   %edi
  800a9f:	56                   	push   %esi
  800aa0:	53                   	push   %ebx
  800aa1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa7:	85 c9                	test   %ecx,%ecx
  800aa9:	74 13                	je     800abe <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aab:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ab1:	75 05                	jne    800ab8 <memset+0x1d>
  800ab3:	f6 c1 03             	test   $0x3,%cl
  800ab6:	74 0d                	je     800ac5 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abb:	fc                   	cld    
  800abc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abe:	89 f8                	mov    %edi,%eax
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5f                   	pop    %edi
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    
		c &= 0xFF;
  800ac5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac9:	89 d3                	mov    %edx,%ebx
  800acb:	c1 e3 08             	shl    $0x8,%ebx
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 18             	shl    $0x18,%eax
  800ad3:	89 d6                	mov    %edx,%esi
  800ad5:	c1 e6 10             	shl    $0x10,%esi
  800ad8:	09 f0                	or     %esi,%eax
  800ada:	09 c2                	or     %eax,%edx
  800adc:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ade:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ae1:	89 d0                	mov    %edx,%eax
  800ae3:	fc                   	cld    
  800ae4:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae6:	eb d6                	jmp    800abe <memset+0x23>

00800ae8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	57                   	push   %edi
  800aec:	56                   	push   %esi
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af6:	39 c6                	cmp    %eax,%esi
  800af8:	73 35                	jae    800b2f <memmove+0x47>
  800afa:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800afd:	39 c2                	cmp    %eax,%edx
  800aff:	76 2e                	jbe    800b2f <memmove+0x47>
		s += n;
		d += n;
  800b01:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b04:	89 d6                	mov    %edx,%esi
  800b06:	09 fe                	or     %edi,%esi
  800b08:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0e:	74 0c                	je     800b1c <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b10:	83 ef 01             	sub    $0x1,%edi
  800b13:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b16:	fd                   	std    
  800b17:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b19:	fc                   	cld    
  800b1a:	eb 21                	jmp    800b3d <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1c:	f6 c1 03             	test   $0x3,%cl
  800b1f:	75 ef                	jne    800b10 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b21:	83 ef 04             	sub    $0x4,%edi
  800b24:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b27:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b2a:	fd                   	std    
  800b2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2d:	eb ea                	jmp    800b19 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2f:	89 f2                	mov    %esi,%edx
  800b31:	09 c2                	or     %eax,%edx
  800b33:	f6 c2 03             	test   $0x3,%dl
  800b36:	74 09                	je     800b41 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b38:	89 c7                	mov    %eax,%edi
  800b3a:	fc                   	cld    
  800b3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3d:	5e                   	pop    %esi
  800b3e:	5f                   	pop    %edi
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b41:	f6 c1 03             	test   $0x3,%cl
  800b44:	75 f2                	jne    800b38 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b46:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b49:	89 c7                	mov    %eax,%edi
  800b4b:	fc                   	cld    
  800b4c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4e:	eb ed                	jmp    800b3d <memmove+0x55>

00800b50 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b53:	ff 75 10             	pushl  0x10(%ebp)
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 87 ff ff ff       	call   800ae8 <memmove>
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	56                   	push   %esi
  800b67:	53                   	push   %ebx
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6e:	89 c6                	mov    %eax,%esi
  800b70:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b73:	39 f0                	cmp    %esi,%eax
  800b75:	74 1c                	je     800b93 <memcmp+0x30>
		if (*s1 != *s2)
  800b77:	0f b6 08             	movzbl (%eax),%ecx
  800b7a:	0f b6 1a             	movzbl (%edx),%ebx
  800b7d:	38 d9                	cmp    %bl,%cl
  800b7f:	75 08                	jne    800b89 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b81:	83 c0 01             	add    $0x1,%eax
  800b84:	83 c2 01             	add    $0x1,%edx
  800b87:	eb ea                	jmp    800b73 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b89:	0f b6 c1             	movzbl %cl,%eax
  800b8c:	0f b6 db             	movzbl %bl,%ebx
  800b8f:	29 d8                	sub    %ebx,%eax
  800b91:	eb 05                	jmp    800b98 <memcmp+0x35>
	}

	return 0;
  800b93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ba5:	89 c2                	mov    %eax,%edx
  800ba7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800baa:	39 d0                	cmp    %edx,%eax
  800bac:	73 09                	jae    800bb7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bae:	38 08                	cmp    %cl,(%eax)
  800bb0:	74 05                	je     800bb7 <memfind+0x1b>
	for (; s < ends; s++)
  800bb2:	83 c0 01             	add    $0x1,%eax
  800bb5:	eb f3                	jmp    800baa <memfind+0xe>
			break;
	return (void *) s;
}
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    

00800bb9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	57                   	push   %edi
  800bbd:	56                   	push   %esi
  800bbe:	53                   	push   %ebx
  800bbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc5:	eb 03                	jmp    800bca <strtol+0x11>
		s++;
  800bc7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bca:	0f b6 01             	movzbl (%ecx),%eax
  800bcd:	3c 20                	cmp    $0x20,%al
  800bcf:	74 f6                	je     800bc7 <strtol+0xe>
  800bd1:	3c 09                	cmp    $0x9,%al
  800bd3:	74 f2                	je     800bc7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bd5:	3c 2b                	cmp    $0x2b,%al
  800bd7:	74 2e                	je     800c07 <strtol+0x4e>
	int neg = 0;
  800bd9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bde:	3c 2d                	cmp    $0x2d,%al
  800be0:	74 2f                	je     800c11 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800be8:	75 05                	jne    800bef <strtol+0x36>
  800bea:	80 39 30             	cmpb   $0x30,(%ecx)
  800bed:	74 2c                	je     800c1b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bef:	85 db                	test   %ebx,%ebx
  800bf1:	75 0a                	jne    800bfd <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf3:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bf8:	80 39 30             	cmpb   $0x30,(%ecx)
  800bfb:	74 28                	je     800c25 <strtol+0x6c>
		base = 10;
  800bfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800c02:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c05:	eb 50                	jmp    800c57 <strtol+0x9e>
		s++;
  800c07:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c0a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c0f:	eb d1                	jmp    800be2 <strtol+0x29>
		s++, neg = 1;
  800c11:	83 c1 01             	add    $0x1,%ecx
  800c14:	bf 01 00 00 00       	mov    $0x1,%edi
  800c19:	eb c7                	jmp    800be2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c1f:	74 0e                	je     800c2f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c21:	85 db                	test   %ebx,%ebx
  800c23:	75 d8                	jne    800bfd <strtol+0x44>
		s++, base = 8;
  800c25:	83 c1 01             	add    $0x1,%ecx
  800c28:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c2d:	eb ce                	jmp    800bfd <strtol+0x44>
		s += 2, base = 16;
  800c2f:	83 c1 02             	add    $0x2,%ecx
  800c32:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c37:	eb c4                	jmp    800bfd <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c39:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c3c:	89 f3                	mov    %esi,%ebx
  800c3e:	80 fb 19             	cmp    $0x19,%bl
  800c41:	77 29                	ja     800c6c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c43:	0f be d2             	movsbl %dl,%edx
  800c46:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c49:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c4c:	7d 30                	jge    800c7e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c4e:	83 c1 01             	add    $0x1,%ecx
  800c51:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c55:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c57:	0f b6 11             	movzbl (%ecx),%edx
  800c5a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c5d:	89 f3                	mov    %esi,%ebx
  800c5f:	80 fb 09             	cmp    $0x9,%bl
  800c62:	77 d5                	ja     800c39 <strtol+0x80>
			dig = *s - '0';
  800c64:	0f be d2             	movsbl %dl,%edx
  800c67:	83 ea 30             	sub    $0x30,%edx
  800c6a:	eb dd                	jmp    800c49 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c6c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c6f:	89 f3                	mov    %esi,%ebx
  800c71:	80 fb 19             	cmp    $0x19,%bl
  800c74:	77 08                	ja     800c7e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c76:	0f be d2             	movsbl %dl,%edx
  800c79:	83 ea 37             	sub    $0x37,%edx
  800c7c:	eb cb                	jmp    800c49 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c82:	74 05                	je     800c89 <strtol+0xd0>
		*endptr = (char *) s;
  800c84:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c87:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c89:	89 c2                	mov    %eax,%edx
  800c8b:	f7 da                	neg    %edx
  800c8d:	85 ff                	test   %edi,%edi
  800c8f:	0f 45 c2             	cmovne %edx,%eax
}
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	57                   	push   %edi
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca8:	89 c3                	mov    %eax,%ebx
  800caa:	89 c7                	mov    %eax,%edi
  800cac:	89 c6                	mov    %eax,%esi
  800cae:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc0:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc5:	89 d1                	mov    %edx,%ecx
  800cc7:	89 d3                	mov    %edx,%ebx
  800cc9:	89 d7                	mov    %edx,%edi
  800ccb:	89 d6                	mov    %edx,%esi
  800ccd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
  800cda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cea:	89 cb                	mov    %ecx,%ebx
  800cec:	89 cf                	mov    %ecx,%edi
  800cee:	89 ce                	mov    %ecx,%esi
  800cf0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf2:	85 c0                	test   %eax,%eax
  800cf4:	7f 08                	jg     800cfe <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf9:	5b                   	pop    %ebx
  800cfa:	5e                   	pop    %esi
  800cfb:	5f                   	pop    %edi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfe:	83 ec 0c             	sub    $0xc,%esp
  800d01:	50                   	push   %eax
  800d02:	6a 03                	push   $0x3
  800d04:	68 9f 25 80 00       	push   $0x80259f
  800d09:	6a 23                	push   $0x23
  800d0b:	68 bc 25 80 00       	push   $0x8025bc
  800d10:	e8 80 f5 ff ff       	call   800295 <_panic>

00800d15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d20:	b8 02 00 00 00       	mov    $0x2,%eax
  800d25:	89 d1                	mov    %edx,%ecx
  800d27:	89 d3                	mov    %edx,%ebx
  800d29:	89 d7                	mov    %edx,%edi
  800d2b:	89 d6                	mov    %edx,%esi
  800d2d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <sys_yield>:

void
sys_yield(void)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d44:	89 d1                	mov    %edx,%ecx
  800d46:	89 d3                	mov    %edx,%ebx
  800d48:	89 d7                	mov    %edx,%edi
  800d4a:	89 d6                	mov    %edx,%esi
  800d4c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
  800d59:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5c:	be 00 00 00 00       	mov    $0x0,%esi
  800d61:	8b 55 08             	mov    0x8(%ebp),%edx
  800d64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d67:	b8 04 00 00 00       	mov    $0x4,%eax
  800d6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6f:	89 f7                	mov    %esi,%edi
  800d71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d73:	85 c0                	test   %eax,%eax
  800d75:	7f 08                	jg     800d7f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7a:	5b                   	pop    %ebx
  800d7b:	5e                   	pop    %esi
  800d7c:	5f                   	pop    %edi
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7f:	83 ec 0c             	sub    $0xc,%esp
  800d82:	50                   	push   %eax
  800d83:	6a 04                	push   $0x4
  800d85:	68 9f 25 80 00       	push   $0x80259f
  800d8a:	6a 23                	push   $0x23
  800d8c:	68 bc 25 80 00       	push   $0x8025bc
  800d91:	e8 ff f4 ff ff       	call   800295 <_panic>

00800d96 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
  800d9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da5:	b8 05 00 00 00       	mov    $0x5,%eax
  800daa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dad:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db0:	8b 75 18             	mov    0x18(%ebp),%esi
  800db3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db5:	85 c0                	test   %eax,%eax
  800db7:	7f 08                	jg     800dc1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5f                   	pop    %edi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc1:	83 ec 0c             	sub    $0xc,%esp
  800dc4:	50                   	push   %eax
  800dc5:	6a 05                	push   $0x5
  800dc7:	68 9f 25 80 00       	push   $0x80259f
  800dcc:	6a 23                	push   $0x23
  800dce:	68 bc 25 80 00       	push   $0x8025bc
  800dd3:	e8 bd f4 ff ff       	call   800295 <_panic>

00800dd8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dec:	b8 06 00 00 00       	mov    $0x6,%eax
  800df1:	89 df                	mov    %ebx,%edi
  800df3:	89 de                	mov    %ebx,%esi
  800df5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	7f 08                	jg     800e03 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	50                   	push   %eax
  800e07:	6a 06                	push   $0x6
  800e09:	68 9f 25 80 00       	push   $0x80259f
  800e0e:	6a 23                	push   $0x23
  800e10:	68 bc 25 80 00       	push   $0x8025bc
  800e15:	e8 7b f4 ff ff       	call   800295 <_panic>

00800e1a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e33:	89 df                	mov    %ebx,%edi
  800e35:	89 de                	mov    %ebx,%esi
  800e37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	7f 08                	jg     800e45 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e40:	5b                   	pop    %ebx
  800e41:	5e                   	pop    %esi
  800e42:	5f                   	pop    %edi
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e45:	83 ec 0c             	sub    $0xc,%esp
  800e48:	50                   	push   %eax
  800e49:	6a 08                	push   $0x8
  800e4b:	68 9f 25 80 00       	push   $0x80259f
  800e50:	6a 23                	push   $0x23
  800e52:	68 bc 25 80 00       	push   $0x8025bc
  800e57:	e8 39 f4 ff ff       	call   800295 <_panic>

00800e5c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	57                   	push   %edi
  800e60:	56                   	push   %esi
  800e61:	53                   	push   %ebx
  800e62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	b8 09 00 00 00       	mov    $0x9,%eax
  800e75:	89 df                	mov    %ebx,%edi
  800e77:	89 de                	mov    %ebx,%esi
  800e79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	7f 08                	jg     800e87 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	50                   	push   %eax
  800e8b:	6a 09                	push   $0x9
  800e8d:	68 9f 25 80 00       	push   $0x80259f
  800e92:	6a 23                	push   $0x23
  800e94:	68 bc 25 80 00       	push   $0x8025bc
  800e99:	e8 f7 f3 ff ff       	call   800295 <_panic>

00800e9e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb7:	89 df                	mov    %ebx,%edi
  800eb9:	89 de                	mov    %ebx,%esi
  800ebb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	7f 08                	jg     800ec9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec9:	83 ec 0c             	sub    $0xc,%esp
  800ecc:	50                   	push   %eax
  800ecd:	6a 0a                	push   $0xa
  800ecf:	68 9f 25 80 00       	push   $0x80259f
  800ed4:	6a 23                	push   $0x23
  800ed6:	68 bc 25 80 00       	push   $0x8025bc
  800edb:	e8 b5 f3 ff ff       	call   800295 <_panic>

00800ee0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef1:	be 00 00 00 00       	mov    $0x0,%esi
  800ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f19:	89 cb                	mov    %ecx,%ebx
  800f1b:	89 cf                	mov    %ecx,%edi
  800f1d:	89 ce                	mov    %ecx,%esi
  800f1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	7f 08                	jg     800f2d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	50                   	push   %eax
  800f31:	6a 0d                	push   $0xd
  800f33:	68 9f 25 80 00       	push   $0x80259f
  800f38:	6a 23                	push   $0x23
  800f3a:	68 bc 25 80 00       	push   $0x8025bc
  800f3f:	e8 51 f3 ff ff       	call   800295 <_panic>

00800f44 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800f4a:	68 ca 25 80 00       	push   $0x8025ca
  800f4f:	6a 25                	push   $0x25
  800f51:	68 e2 25 80 00       	push   $0x8025e2
  800f56:	e8 3a f3 ff ff       	call   800295 <_panic>

00800f5b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
  800f61:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800f64:	68 44 0f 80 00       	push   $0x800f44
  800f69:	e8 ca 0e 00 00       	call   801e38 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f6e:	b8 07 00 00 00       	mov    $0x7,%eax
  800f73:	cd 30                	int    $0x30
  800f75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800f7b:	83 c4 10             	add    $0x10,%esp
  800f7e:	85 c0                	test   %eax,%eax
  800f80:	78 27                	js     800fa9 <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800f82:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800f87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f8b:	75 65                	jne    800ff2 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f8d:	e8 83 fd ff ff       	call   800d15 <sys_getenvid>
  800f92:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f97:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f9a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f9f:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800fa4:	e9 11 01 00 00       	jmp    8010ba <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800fa9:	50                   	push   %eax
  800faa:	68 0e 22 80 00       	push   $0x80220e
  800faf:	6a 6f                	push   $0x6f
  800fb1:	68 e2 25 80 00       	push   $0x8025e2
  800fb6:	e8 da f2 ff ff       	call   800295 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800fbb:	e8 55 fd ff ff       	call   800d15 <sys_getenvid>
  800fc0:	83 ec 0c             	sub    $0xc,%esp
  800fc3:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800fc9:	56                   	push   %esi
  800fca:	57                   	push   %edi
  800fcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fce:	57                   	push   %edi
  800fcf:	50                   	push   %eax
  800fd0:	e8 c1 fd ff ff       	call   800d96 <sys_page_map>
  800fd5:	83 c4 20             	add    $0x20,%esp
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	0f 88 84 00 00 00    	js     801064 <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800fe0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fe6:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fec:	0f 84 84 00 00 00    	je     801076 <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800ff2:	89 d8                	mov    %ebx,%eax
  800ff4:	c1 e8 16             	shr    $0x16,%eax
  800ff7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ffe:	a8 01                	test   $0x1,%al
  801000:	74 de                	je     800fe0 <fork+0x85>
  801002:	89 d8                	mov    %ebx,%eax
  801004:	c1 e8 0c             	shr    $0xc,%eax
  801007:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80100e:	f6 c2 01             	test   $0x1,%dl
  801011:	74 cd                	je     800fe0 <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  801013:	89 c7                	mov    %eax,%edi
  801015:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  801018:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  80101f:	f7 c6 00 04 00 00    	test   $0x400,%esi
  801025:	75 94                	jne    800fbb <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  801027:	f7 c6 02 08 00 00    	test   $0x802,%esi
  80102d:	0f 85 d1 00 00 00    	jne    801104 <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  801033:	a1 04 40 80 00       	mov    0x804004,%eax
  801038:	8b 40 48             	mov    0x48(%eax),%eax
  80103b:	83 ec 0c             	sub    $0xc,%esp
  80103e:	6a 05                	push   $0x5
  801040:	57                   	push   %edi
  801041:	ff 75 e4             	pushl  -0x1c(%ebp)
  801044:	57                   	push   %edi
  801045:	50                   	push   %eax
  801046:	e8 4b fd ff ff       	call   800d96 <sys_page_map>
  80104b:	83 c4 20             	add    $0x20,%esp
  80104e:	85 c0                	test   %eax,%eax
  801050:	79 8e                	jns    800fe0 <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  801052:	50                   	push   %eax
  801053:	68 3c 26 80 00       	push   $0x80263c
  801058:	6a 4a                	push   $0x4a
  80105a:	68 e2 25 80 00       	push   $0x8025e2
  80105f:	e8 31 f2 ff ff       	call   800295 <_panic>
                        panic("duppage: page mapping failed %e", r);
  801064:	50                   	push   %eax
  801065:	68 1c 26 80 00       	push   $0x80261c
  80106a:	6a 41                	push   $0x41
  80106c:	68 e2 25 80 00       	push   $0x8025e2
  801071:	e8 1f f2 ff ff       	call   800295 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801076:	83 ec 04             	sub    $0x4,%esp
  801079:	6a 07                	push   $0x7
  80107b:	68 00 f0 bf ee       	push   $0xeebff000
  801080:	ff 75 e0             	pushl  -0x20(%ebp)
  801083:	e8 cb fc ff ff       	call   800d53 <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	85 c0                	test   %eax,%eax
  80108d:	78 36                	js     8010c5 <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  80108f:	83 ec 08             	sub    $0x8,%esp
  801092:	68 ac 1e 80 00       	push   $0x801eac
  801097:	ff 75 e0             	pushl  -0x20(%ebp)
  80109a:	e8 ff fd ff ff       	call   800e9e <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80109f:	83 c4 10             	add    $0x10,%esp
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	78 34                	js     8010da <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  8010a6:	83 ec 08             	sub    $0x8,%esp
  8010a9:	6a 02                	push   $0x2
  8010ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8010ae:	e8 67 fd ff ff       	call   800e1a <sys_env_set_status>
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	78 35                	js     8010ef <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  8010ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c0:	5b                   	pop    %ebx
  8010c1:	5e                   	pop    %esi
  8010c2:	5f                   	pop    %edi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  8010c5:	50                   	push   %eax
  8010c6:	68 0e 22 80 00       	push   $0x80220e
  8010cb:	68 82 00 00 00       	push   $0x82
  8010d0:	68 e2 25 80 00       	push   $0x8025e2
  8010d5:	e8 bb f1 ff ff       	call   800295 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8010da:	50                   	push   %eax
  8010db:	68 60 26 80 00       	push   $0x802660
  8010e0:	68 87 00 00 00       	push   $0x87
  8010e5:	68 e2 25 80 00       	push   $0x8025e2
  8010ea:	e8 a6 f1 ff ff       	call   800295 <_panic>
        	panic("sys_env_set_status: %e", r);
  8010ef:	50                   	push   %eax
  8010f0:	68 ed 25 80 00       	push   $0x8025ed
  8010f5:	68 8b 00 00 00       	push   $0x8b
  8010fa:	68 e2 25 80 00       	push   $0x8025e2
  8010ff:	e8 91 f1 ff ff       	call   800295 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  801104:	a1 04 40 80 00       	mov    0x804004,%eax
  801109:	8b 40 48             	mov    0x48(%eax),%eax
  80110c:	83 ec 0c             	sub    $0xc,%esp
  80110f:	68 05 08 00 00       	push   $0x805
  801114:	57                   	push   %edi
  801115:	ff 75 e4             	pushl  -0x1c(%ebp)
  801118:	57                   	push   %edi
  801119:	50                   	push   %eax
  80111a:	e8 77 fc ff ff       	call   800d96 <sys_page_map>
  80111f:	83 c4 20             	add    $0x20,%esp
  801122:	85 c0                	test   %eax,%eax
  801124:	0f 88 28 ff ff ff    	js     801052 <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  80112a:	a1 04 40 80 00       	mov    0x804004,%eax
  80112f:	8b 50 48             	mov    0x48(%eax),%edx
  801132:	8b 40 48             	mov    0x48(%eax),%eax
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	68 05 08 00 00       	push   $0x805
  80113d:	57                   	push   %edi
  80113e:	52                   	push   %edx
  80113f:	57                   	push   %edi
  801140:	50                   	push   %eax
  801141:	e8 50 fc ff ff       	call   800d96 <sys_page_map>
  801146:	83 c4 20             	add    $0x20,%esp
  801149:	85 c0                	test   %eax,%eax
  80114b:	0f 89 8f fe ff ff    	jns    800fe0 <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  801151:	50                   	push   %eax
  801152:	68 3c 26 80 00       	push   $0x80263c
  801157:	6a 4f                	push   $0x4f
  801159:	68 e2 25 80 00       	push   $0x8025e2
  80115e:	e8 32 f1 ff ff       	call   800295 <_panic>

00801163 <sfork>:

// Challenge!
int
sfork(void)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801169:	68 04 26 80 00       	push   $0x802604
  80116e:	68 94 00 00 00       	push   $0x94
  801173:	68 e2 25 80 00       	push   $0x8025e2
  801178:	e8 18 f1 ff ff       	call   800295 <_panic>

0080117d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	05 00 00 00 30       	add    $0x30000000,%eax
  801188:	c1 e8 0c             	shr    $0xc,%eax
}
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801198:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80119d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011a2:	5d                   	pop    %ebp
  8011a3:	c3                   	ret    

008011a4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011aa:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	c1 ea 16             	shr    $0x16,%edx
  8011b4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011bb:	f6 c2 01             	test   $0x1,%dl
  8011be:	74 2a                	je     8011ea <fd_alloc+0x46>
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	c1 ea 0c             	shr    $0xc,%edx
  8011c5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011cc:	f6 c2 01             	test   $0x1,%dl
  8011cf:	74 19                	je     8011ea <fd_alloc+0x46>
  8011d1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011d6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011db:	75 d2                	jne    8011af <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011dd:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011e3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011e8:	eb 07                	jmp    8011f1 <fd_alloc+0x4d>
			*fd_store = fd;
  8011ea:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    

008011f3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011f9:	83 f8 1f             	cmp    $0x1f,%eax
  8011fc:	77 36                	ja     801234 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011fe:	c1 e0 0c             	shl    $0xc,%eax
  801201:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801206:	89 c2                	mov    %eax,%edx
  801208:	c1 ea 16             	shr    $0x16,%edx
  80120b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801212:	f6 c2 01             	test   $0x1,%dl
  801215:	74 24                	je     80123b <fd_lookup+0x48>
  801217:	89 c2                	mov    %eax,%edx
  801219:	c1 ea 0c             	shr    $0xc,%edx
  80121c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801223:	f6 c2 01             	test   $0x1,%dl
  801226:	74 1a                	je     801242 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122b:	89 02                	mov    %eax,(%edx)
	return 0;
  80122d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801232:	5d                   	pop    %ebp
  801233:	c3                   	ret    
		return -E_INVAL;
  801234:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801239:	eb f7                	jmp    801232 <fd_lookup+0x3f>
		return -E_INVAL;
  80123b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801240:	eb f0                	jmp    801232 <fd_lookup+0x3f>
  801242:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801247:	eb e9                	jmp    801232 <fd_lookup+0x3f>

00801249 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 08             	sub    $0x8,%esp
  80124f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801252:	ba 04 27 80 00       	mov    $0x802704,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801257:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80125c:	39 08                	cmp    %ecx,(%eax)
  80125e:	74 33                	je     801293 <dev_lookup+0x4a>
  801260:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801263:	8b 02                	mov    (%edx),%eax
  801265:	85 c0                	test   %eax,%eax
  801267:	75 f3                	jne    80125c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801269:	a1 04 40 80 00       	mov    0x804004,%eax
  80126e:	8b 40 48             	mov    0x48(%eax),%eax
  801271:	83 ec 04             	sub    $0x4,%esp
  801274:	51                   	push   %ecx
  801275:	50                   	push   %eax
  801276:	68 84 26 80 00       	push   $0x802684
  80127b:	e8 f0 f0 ff ff       	call   800370 <cprintf>
	*dev = 0;
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    
			*dev = devtab[i];
  801293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801296:	89 01                	mov    %eax,(%ecx)
			return 0;
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
  80129d:	eb f2                	jmp    801291 <dev_lookup+0x48>

0080129f <fd_close>:
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	57                   	push   %edi
  8012a3:	56                   	push   %esi
  8012a4:	53                   	push   %ebx
  8012a5:	83 ec 1c             	sub    $0x1c,%esp
  8012a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8012ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012b8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012bb:	50                   	push   %eax
  8012bc:	e8 32 ff ff ff       	call   8011f3 <fd_lookup>
  8012c1:	89 c3                	mov    %eax,%ebx
  8012c3:	83 c4 08             	add    $0x8,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	78 05                	js     8012cf <fd_close+0x30>
	    || fd != fd2)
  8012ca:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012cd:	74 16                	je     8012e5 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012cf:	89 f8                	mov    %edi,%eax
  8012d1:	84 c0                	test   %al,%al
  8012d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d8:	0f 44 d8             	cmove  %eax,%ebx
}
  8012db:	89 d8                	mov    %ebx,%eax
  8012dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e0:	5b                   	pop    %ebx
  8012e1:	5e                   	pop    %esi
  8012e2:	5f                   	pop    %edi
  8012e3:	5d                   	pop    %ebp
  8012e4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012e5:	83 ec 08             	sub    $0x8,%esp
  8012e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012eb:	50                   	push   %eax
  8012ec:	ff 36                	pushl  (%esi)
  8012ee:	e8 56 ff ff ff       	call   801249 <dev_lookup>
  8012f3:	89 c3                	mov    %eax,%ebx
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	78 15                	js     801311 <fd_close+0x72>
		if (dev->dev_close)
  8012fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ff:	8b 40 10             	mov    0x10(%eax),%eax
  801302:	85 c0                	test   %eax,%eax
  801304:	74 1b                	je     801321 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	56                   	push   %esi
  80130a:	ff d0                	call   *%eax
  80130c:	89 c3                	mov    %eax,%ebx
  80130e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	56                   	push   %esi
  801315:	6a 00                	push   $0x0
  801317:	e8 bc fa ff ff       	call   800dd8 <sys_page_unmap>
	return r;
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	eb ba                	jmp    8012db <fd_close+0x3c>
			r = 0;
  801321:	bb 00 00 00 00       	mov    $0x0,%ebx
  801326:	eb e9                	jmp    801311 <fd_close+0x72>

00801328 <close>:

int
close(int fdnum)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80132e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	ff 75 08             	pushl  0x8(%ebp)
  801335:	e8 b9 fe ff ff       	call   8011f3 <fd_lookup>
  80133a:	83 c4 08             	add    $0x8,%esp
  80133d:	85 c0                	test   %eax,%eax
  80133f:	78 10                	js     801351 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801341:	83 ec 08             	sub    $0x8,%esp
  801344:	6a 01                	push   $0x1
  801346:	ff 75 f4             	pushl  -0xc(%ebp)
  801349:	e8 51 ff ff ff       	call   80129f <fd_close>
  80134e:	83 c4 10             	add    $0x10,%esp
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <close_all>:

void
close_all(void)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	53                   	push   %ebx
  801357:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80135a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80135f:	83 ec 0c             	sub    $0xc,%esp
  801362:	53                   	push   %ebx
  801363:	e8 c0 ff ff ff       	call   801328 <close>
	for (i = 0; i < MAXFD; i++)
  801368:	83 c3 01             	add    $0x1,%ebx
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	83 fb 20             	cmp    $0x20,%ebx
  801371:	75 ec                	jne    80135f <close_all+0xc>
}
  801373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	57                   	push   %edi
  80137c:	56                   	push   %esi
  80137d:	53                   	push   %ebx
  80137e:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801381:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801384:	50                   	push   %eax
  801385:	ff 75 08             	pushl  0x8(%ebp)
  801388:	e8 66 fe ff ff       	call   8011f3 <fd_lookup>
  80138d:	89 c3                	mov    %eax,%ebx
  80138f:	83 c4 08             	add    $0x8,%esp
  801392:	85 c0                	test   %eax,%eax
  801394:	0f 88 81 00 00 00    	js     80141b <dup+0xa3>
		return r;
	close(newfdnum);
  80139a:	83 ec 0c             	sub    $0xc,%esp
  80139d:	ff 75 0c             	pushl  0xc(%ebp)
  8013a0:	e8 83 ff ff ff       	call   801328 <close>

	newfd = INDEX2FD(newfdnum);
  8013a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013a8:	c1 e6 0c             	shl    $0xc,%esi
  8013ab:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013b1:	83 c4 04             	add    $0x4,%esp
  8013b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013b7:	e8 d1 fd ff ff       	call   80118d <fd2data>
  8013bc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013be:	89 34 24             	mov    %esi,(%esp)
  8013c1:	e8 c7 fd ff ff       	call   80118d <fd2data>
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013cb:	89 d8                	mov    %ebx,%eax
  8013cd:	c1 e8 16             	shr    $0x16,%eax
  8013d0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013d7:	a8 01                	test   $0x1,%al
  8013d9:	74 11                	je     8013ec <dup+0x74>
  8013db:	89 d8                	mov    %ebx,%eax
  8013dd:	c1 e8 0c             	shr    $0xc,%eax
  8013e0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013e7:	f6 c2 01             	test   $0x1,%dl
  8013ea:	75 39                	jne    801425 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ef:	89 d0                	mov    %edx,%eax
  8013f1:	c1 e8 0c             	shr    $0xc,%eax
  8013f4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013fb:	83 ec 0c             	sub    $0xc,%esp
  8013fe:	25 07 0e 00 00       	and    $0xe07,%eax
  801403:	50                   	push   %eax
  801404:	56                   	push   %esi
  801405:	6a 00                	push   $0x0
  801407:	52                   	push   %edx
  801408:	6a 00                	push   $0x0
  80140a:	e8 87 f9 ff ff       	call   800d96 <sys_page_map>
  80140f:	89 c3                	mov    %eax,%ebx
  801411:	83 c4 20             	add    $0x20,%esp
  801414:	85 c0                	test   %eax,%eax
  801416:	78 31                	js     801449 <dup+0xd1>
		goto err;

	return newfdnum;
  801418:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80141b:	89 d8                	mov    %ebx,%eax
  80141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801420:	5b                   	pop    %ebx
  801421:	5e                   	pop    %esi
  801422:	5f                   	pop    %edi
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801425:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80142c:	83 ec 0c             	sub    $0xc,%esp
  80142f:	25 07 0e 00 00       	and    $0xe07,%eax
  801434:	50                   	push   %eax
  801435:	57                   	push   %edi
  801436:	6a 00                	push   $0x0
  801438:	53                   	push   %ebx
  801439:	6a 00                	push   $0x0
  80143b:	e8 56 f9 ff ff       	call   800d96 <sys_page_map>
  801440:	89 c3                	mov    %eax,%ebx
  801442:	83 c4 20             	add    $0x20,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	79 a3                	jns    8013ec <dup+0x74>
	sys_page_unmap(0, newfd);
  801449:	83 ec 08             	sub    $0x8,%esp
  80144c:	56                   	push   %esi
  80144d:	6a 00                	push   $0x0
  80144f:	e8 84 f9 ff ff       	call   800dd8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801454:	83 c4 08             	add    $0x8,%esp
  801457:	57                   	push   %edi
  801458:	6a 00                	push   $0x0
  80145a:	e8 79 f9 ff ff       	call   800dd8 <sys_page_unmap>
	return r;
  80145f:	83 c4 10             	add    $0x10,%esp
  801462:	eb b7                	jmp    80141b <dup+0xa3>

00801464 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
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
  801473:	e8 7b fd ff ff       	call   8011f3 <fd_lookup>
  801478:	83 c4 08             	add    $0x8,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 3f                	js     8014be <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147f:	83 ec 08             	sub    $0x8,%esp
  801482:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801489:	ff 30                	pushl  (%eax)
  80148b:	e8 b9 fd ff ff       	call   801249 <dev_lookup>
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	85 c0                	test   %eax,%eax
  801495:	78 27                	js     8014be <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801497:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80149a:	8b 42 08             	mov    0x8(%edx),%eax
  80149d:	83 e0 03             	and    $0x3,%eax
  8014a0:	83 f8 01             	cmp    $0x1,%eax
  8014a3:	74 1e                	je     8014c3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a8:	8b 40 08             	mov    0x8(%eax),%eax
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	74 35                	je     8014e4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014af:	83 ec 04             	sub    $0x4,%esp
  8014b2:	ff 75 10             	pushl  0x10(%ebp)
  8014b5:	ff 75 0c             	pushl  0xc(%ebp)
  8014b8:	52                   	push   %edx
  8014b9:	ff d0                	call   *%eax
  8014bb:	83 c4 10             	add    $0x10,%esp
}
  8014be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8014c8:	8b 40 48             	mov    0x48(%eax),%eax
  8014cb:	83 ec 04             	sub    $0x4,%esp
  8014ce:	53                   	push   %ebx
  8014cf:	50                   	push   %eax
  8014d0:	68 c8 26 80 00       	push   $0x8026c8
  8014d5:	e8 96 ee ff ff       	call   800370 <cprintf>
		return -E_INVAL;
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e2:	eb da                	jmp    8014be <read+0x5a>
		return -E_NOT_SUPP;
  8014e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e9:	eb d3                	jmp    8014be <read+0x5a>

008014eb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	57                   	push   %edi
  8014ef:	56                   	push   %esi
  8014f0:	53                   	push   %ebx
  8014f1:	83 ec 0c             	sub    $0xc,%esp
  8014f4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014f7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ff:	39 f3                	cmp    %esi,%ebx
  801501:	73 25                	jae    801528 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	89 f0                	mov    %esi,%eax
  801508:	29 d8                	sub    %ebx,%eax
  80150a:	50                   	push   %eax
  80150b:	89 d8                	mov    %ebx,%eax
  80150d:	03 45 0c             	add    0xc(%ebp),%eax
  801510:	50                   	push   %eax
  801511:	57                   	push   %edi
  801512:	e8 4d ff ff ff       	call   801464 <read>
		if (m < 0)
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	85 c0                	test   %eax,%eax
  80151c:	78 08                	js     801526 <readn+0x3b>
			return m;
		if (m == 0)
  80151e:	85 c0                	test   %eax,%eax
  801520:	74 06                	je     801528 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801522:	01 c3                	add    %eax,%ebx
  801524:	eb d9                	jmp    8014ff <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801526:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801528:	89 d8                	mov    %ebx,%eax
  80152a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152d:	5b                   	pop    %ebx
  80152e:	5e                   	pop    %esi
  80152f:	5f                   	pop    %edi
  801530:	5d                   	pop    %ebp
  801531:	c3                   	ret    

00801532 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	53                   	push   %ebx
  801536:	83 ec 14             	sub    $0x14,%esp
  801539:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153f:	50                   	push   %eax
  801540:	53                   	push   %ebx
  801541:	e8 ad fc ff ff       	call   8011f3 <fd_lookup>
  801546:	83 c4 08             	add    $0x8,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 3a                	js     801587 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801553:	50                   	push   %eax
  801554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801557:	ff 30                	pushl  (%eax)
  801559:	e8 eb fc ff ff       	call   801249 <dev_lookup>
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	85 c0                	test   %eax,%eax
  801563:	78 22                	js     801587 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801568:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80156c:	74 1e                	je     80158c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80156e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801571:	8b 52 0c             	mov    0xc(%edx),%edx
  801574:	85 d2                	test   %edx,%edx
  801576:	74 35                	je     8015ad <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801578:	83 ec 04             	sub    $0x4,%esp
  80157b:	ff 75 10             	pushl  0x10(%ebp)
  80157e:	ff 75 0c             	pushl  0xc(%ebp)
  801581:	50                   	push   %eax
  801582:	ff d2                	call   *%edx
  801584:	83 c4 10             	add    $0x10,%esp
}
  801587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80158c:	a1 04 40 80 00       	mov    0x804004,%eax
  801591:	8b 40 48             	mov    0x48(%eax),%eax
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	53                   	push   %ebx
  801598:	50                   	push   %eax
  801599:	68 e4 26 80 00       	push   $0x8026e4
  80159e:	e8 cd ed ff ff       	call   800370 <cprintf>
		return -E_INVAL;
  8015a3:	83 c4 10             	add    $0x10,%esp
  8015a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ab:	eb da                	jmp    801587 <write+0x55>
		return -E_NOT_SUPP;
  8015ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b2:	eb d3                	jmp    801587 <write+0x55>

008015b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015bd:	50                   	push   %eax
  8015be:	ff 75 08             	pushl  0x8(%ebp)
  8015c1:	e8 2d fc ff ff       	call   8011f3 <fd_lookup>
  8015c6:	83 c4 08             	add    $0x8,%esp
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	78 0e                	js     8015db <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	53                   	push   %ebx
  8015e1:	83 ec 14             	sub    $0x14,%esp
  8015e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	53                   	push   %ebx
  8015ec:	e8 02 fc ff ff       	call   8011f3 <fd_lookup>
  8015f1:	83 c4 08             	add    $0x8,%esp
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	78 37                	js     80162f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fe:	50                   	push   %eax
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801602:	ff 30                	pushl  (%eax)
  801604:	e8 40 fc ff ff       	call   801249 <dev_lookup>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 1f                	js     80162f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801613:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801617:	74 1b                	je     801634 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161c:	8b 52 18             	mov    0x18(%edx),%edx
  80161f:	85 d2                	test   %edx,%edx
  801621:	74 32                	je     801655 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	ff 75 0c             	pushl  0xc(%ebp)
  801629:	50                   	push   %eax
  80162a:	ff d2                	call   *%edx
  80162c:	83 c4 10             	add    $0x10,%esp
}
  80162f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801632:	c9                   	leave  
  801633:	c3                   	ret    
			thisenv->env_id, fdnum);
  801634:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801639:	8b 40 48             	mov    0x48(%eax),%eax
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	53                   	push   %ebx
  801640:	50                   	push   %eax
  801641:	68 a4 26 80 00       	push   $0x8026a4
  801646:	e8 25 ed ff ff       	call   800370 <cprintf>
		return -E_INVAL;
  80164b:	83 c4 10             	add    $0x10,%esp
  80164e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801653:	eb da                	jmp    80162f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801655:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165a:	eb d3                	jmp    80162f <ftruncate+0x52>

0080165c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	53                   	push   %ebx
  801660:	83 ec 14             	sub    $0x14,%esp
  801663:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801666:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801669:	50                   	push   %eax
  80166a:	ff 75 08             	pushl  0x8(%ebp)
  80166d:	e8 81 fb ff ff       	call   8011f3 <fd_lookup>
  801672:	83 c4 08             	add    $0x8,%esp
  801675:	85 c0                	test   %eax,%eax
  801677:	78 4b                	js     8016c4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801679:	83 ec 08             	sub    $0x8,%esp
  80167c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167f:	50                   	push   %eax
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801683:	ff 30                	pushl  (%eax)
  801685:	e8 bf fb ff ff       	call   801249 <dev_lookup>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	85 c0                	test   %eax,%eax
  80168f:	78 33                	js     8016c4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801694:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801698:	74 2f                	je     8016c9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80169a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80169d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a4:	00 00 00 
	stat->st_isdir = 0;
  8016a7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016ae:	00 00 00 
	stat->st_dev = dev;
  8016b1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	53                   	push   %ebx
  8016bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8016be:	ff 50 14             	call   *0x14(%eax)
  8016c1:	83 c4 10             	add    $0x10,%esp
}
  8016c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    
		return -E_NOT_SUPP;
  8016c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ce:	eb f4                	jmp    8016c4 <fstat+0x68>

008016d0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	6a 00                	push   $0x0
  8016da:	ff 75 08             	pushl  0x8(%ebp)
  8016dd:	e8 e7 01 00 00       	call   8018c9 <open>
  8016e2:	89 c3                	mov    %eax,%ebx
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 1b                	js     801706 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016eb:	83 ec 08             	sub    $0x8,%esp
  8016ee:	ff 75 0c             	pushl  0xc(%ebp)
  8016f1:	50                   	push   %eax
  8016f2:	e8 65 ff ff ff       	call   80165c <fstat>
  8016f7:	89 c6                	mov    %eax,%esi
	close(fd);
  8016f9:	89 1c 24             	mov    %ebx,(%esp)
  8016fc:	e8 27 fc ff ff       	call   801328 <close>
	return r;
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	89 f3                	mov    %esi,%ebx
}
  801706:	89 d8                	mov    %ebx,%eax
  801708:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170b:	5b                   	pop    %ebx
  80170c:	5e                   	pop    %esi
  80170d:	5d                   	pop    %ebp
  80170e:	c3                   	ret    

0080170f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	56                   	push   %esi
  801713:	53                   	push   %ebx
  801714:	89 c6                	mov    %eax,%esi
  801716:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801718:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80171f:	74 27                	je     801748 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801721:	6a 07                	push   $0x7
  801723:	68 00 50 80 00       	push   $0x805000
  801728:	56                   	push   %esi
  801729:	ff 35 00 40 80 00    	pushl  0x804000
  80172f:	e8 b6 07 00 00       	call   801eea <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801734:	83 c4 0c             	add    $0xc,%esp
  801737:	6a 00                	push   $0x0
  801739:	53                   	push   %ebx
  80173a:	6a 00                	push   $0x0
  80173c:	e8 92 07 00 00       	call   801ed3 <ipc_recv>
}
  801741:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801744:	5b                   	pop    %ebx
  801745:	5e                   	pop    %esi
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	6a 01                	push   $0x1
  80174d:	e8 af 07 00 00       	call   801f01 <ipc_find_env>
  801752:	a3 00 40 80 00       	mov    %eax,0x804000
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	eb c5                	jmp    801721 <fsipc+0x12>

0080175c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	8b 40 0c             	mov    0xc(%eax),%eax
  801768:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80176d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801770:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801775:	ba 00 00 00 00       	mov    $0x0,%edx
  80177a:	b8 02 00 00 00       	mov    $0x2,%eax
  80177f:	e8 8b ff ff ff       	call   80170f <fsipc>
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <devfile_flush>:
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8b 40 0c             	mov    0xc(%eax),%eax
  801792:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	b8 06 00 00 00       	mov    $0x6,%eax
  8017a1:	e8 69 ff ff ff       	call   80170f <fsipc>
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <devfile_stat>:
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	53                   	push   %ebx
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c2:	b8 05 00 00 00       	mov    $0x5,%eax
  8017c7:	e8 43 ff ff ff       	call   80170f <fsipc>
  8017cc:	85 c0                	test   %eax,%eax
  8017ce:	78 2c                	js     8017fc <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	68 00 50 80 00       	push   $0x805000
  8017d8:	53                   	push   %ebx
  8017d9:	e8 7c f1 ff ff       	call   80095a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017de:	a1 80 50 80 00       	mov    0x805080,%eax
  8017e3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017e9:	a1 84 50 80 00       	mov    0x805084,%eax
  8017ee:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <devfile_write>:
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 0c             	sub    $0xc,%esp
  801807:	8b 45 10             	mov    0x10(%ebp),%eax
  80180a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80180f:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801814:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801817:	8b 55 08             	mov    0x8(%ebp),%edx
  80181a:	8b 52 0c             	mov    0xc(%edx),%edx
  80181d:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801823:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  801828:	50                   	push   %eax
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	68 08 50 80 00       	push   $0x805008
  801831:	e8 b2 f2 ff ff       	call   800ae8 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801836:	ba 00 00 00 00       	mov    $0x0,%edx
  80183b:	b8 04 00 00 00       	mov    $0x4,%eax
  801840:	e8 ca fe ff ff       	call   80170f <fsipc>
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <devfile_read>:
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	56                   	push   %esi
  80184b:	53                   	push   %ebx
  80184c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8b 40 0c             	mov    0xc(%eax),%eax
  801855:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80185a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801860:	ba 00 00 00 00       	mov    $0x0,%edx
  801865:	b8 03 00 00 00       	mov    $0x3,%eax
  80186a:	e8 a0 fe ff ff       	call   80170f <fsipc>
  80186f:	89 c3                	mov    %eax,%ebx
  801871:	85 c0                	test   %eax,%eax
  801873:	78 1f                	js     801894 <devfile_read+0x4d>
	assert(r <= n);
  801875:	39 f0                	cmp    %esi,%eax
  801877:	77 24                	ja     80189d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801879:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80187e:	7f 33                	jg     8018b3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801880:	83 ec 04             	sub    $0x4,%esp
  801883:	50                   	push   %eax
  801884:	68 00 50 80 00       	push   $0x805000
  801889:	ff 75 0c             	pushl  0xc(%ebp)
  80188c:	e8 57 f2 ff ff       	call   800ae8 <memmove>
	return r;
  801891:	83 c4 10             	add    $0x10,%esp
}
  801894:	89 d8                	mov    %ebx,%eax
  801896:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801899:	5b                   	pop    %ebx
  80189a:	5e                   	pop    %esi
  80189b:	5d                   	pop    %ebp
  80189c:	c3                   	ret    
	assert(r <= n);
  80189d:	68 14 27 80 00       	push   $0x802714
  8018a2:	68 1b 27 80 00       	push   $0x80271b
  8018a7:	6a 7c                	push   $0x7c
  8018a9:	68 30 27 80 00       	push   $0x802730
  8018ae:	e8 e2 e9 ff ff       	call   800295 <_panic>
	assert(r <= PGSIZE);
  8018b3:	68 3b 27 80 00       	push   $0x80273b
  8018b8:	68 1b 27 80 00       	push   $0x80271b
  8018bd:	6a 7d                	push   $0x7d
  8018bf:	68 30 27 80 00       	push   $0x802730
  8018c4:	e8 cc e9 ff ff       	call   800295 <_panic>

008018c9 <open>:
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	56                   	push   %esi
  8018cd:	53                   	push   %ebx
  8018ce:	83 ec 1c             	sub    $0x1c,%esp
  8018d1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018d4:	56                   	push   %esi
  8018d5:	e8 49 f0 ff ff       	call   800923 <strlen>
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018e2:	7f 6c                	jg     801950 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018e4:	83 ec 0c             	sub    $0xc,%esp
  8018e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ea:	50                   	push   %eax
  8018eb:	e8 b4 f8 ff ff       	call   8011a4 <fd_alloc>
  8018f0:	89 c3                	mov    %eax,%ebx
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	78 3c                	js     801935 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	56                   	push   %esi
  8018fd:	68 00 50 80 00       	push   $0x805000
  801902:	e8 53 f0 ff ff       	call   80095a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80190f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801912:	b8 01 00 00 00       	mov    $0x1,%eax
  801917:	e8 f3 fd ff ff       	call   80170f <fsipc>
  80191c:	89 c3                	mov    %eax,%ebx
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	85 c0                	test   %eax,%eax
  801923:	78 19                	js     80193e <open+0x75>
	return fd2num(fd);
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	ff 75 f4             	pushl  -0xc(%ebp)
  80192b:	e8 4d f8 ff ff       	call   80117d <fd2num>
  801930:	89 c3                	mov    %eax,%ebx
  801932:	83 c4 10             	add    $0x10,%esp
}
  801935:	89 d8                	mov    %ebx,%eax
  801937:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193a:	5b                   	pop    %ebx
  80193b:	5e                   	pop    %esi
  80193c:	5d                   	pop    %ebp
  80193d:	c3                   	ret    
		fd_close(fd, 0);
  80193e:	83 ec 08             	sub    $0x8,%esp
  801941:	6a 00                	push   $0x0
  801943:	ff 75 f4             	pushl  -0xc(%ebp)
  801946:	e8 54 f9 ff ff       	call   80129f <fd_close>
		return r;
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	eb e5                	jmp    801935 <open+0x6c>
		return -E_BAD_PATH;
  801950:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801955:	eb de                	jmp    801935 <open+0x6c>

00801957 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80195d:	ba 00 00 00 00       	mov    $0x0,%edx
  801962:	b8 08 00 00 00       	mov    $0x8,%eax
  801967:	e8 a3 fd ff ff       	call   80170f <fsipc>
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	56                   	push   %esi
  801972:	53                   	push   %ebx
  801973:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801976:	83 ec 0c             	sub    $0xc,%esp
  801979:	ff 75 08             	pushl  0x8(%ebp)
  80197c:	e8 0c f8 ff ff       	call   80118d <fd2data>
  801981:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801983:	83 c4 08             	add    $0x8,%esp
  801986:	68 47 27 80 00       	push   $0x802747
  80198b:	53                   	push   %ebx
  80198c:	e8 c9 ef ff ff       	call   80095a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801991:	8b 46 04             	mov    0x4(%esi),%eax
  801994:	2b 06                	sub    (%esi),%eax
  801996:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80199c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019a3:	00 00 00 
	stat->st_dev = &devpipe;
  8019a6:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8019ad:	30 80 00 
	return 0;
}
  8019b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b8:	5b                   	pop    %ebx
  8019b9:	5e                   	pop    %esi
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    

008019bc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	53                   	push   %ebx
  8019c0:	83 ec 0c             	sub    $0xc,%esp
  8019c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019c6:	53                   	push   %ebx
  8019c7:	6a 00                	push   $0x0
  8019c9:	e8 0a f4 ff ff       	call   800dd8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019ce:	89 1c 24             	mov    %ebx,(%esp)
  8019d1:	e8 b7 f7 ff ff       	call   80118d <fd2data>
  8019d6:	83 c4 08             	add    $0x8,%esp
  8019d9:	50                   	push   %eax
  8019da:	6a 00                	push   $0x0
  8019dc:	e8 f7 f3 ff ff       	call   800dd8 <sys_page_unmap>
}
  8019e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <_pipeisclosed>:
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	57                   	push   %edi
  8019ea:	56                   	push   %esi
  8019eb:	53                   	push   %ebx
  8019ec:	83 ec 1c             	sub    $0x1c,%esp
  8019ef:	89 c7                	mov    %eax,%edi
  8019f1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019f3:	a1 04 40 80 00       	mov    0x804004,%eax
  8019f8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019fb:	83 ec 0c             	sub    $0xc,%esp
  8019fe:	57                   	push   %edi
  8019ff:	e8 36 05 00 00       	call   801f3a <pageref>
  801a04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a07:	89 34 24             	mov    %esi,(%esp)
  801a0a:	e8 2b 05 00 00       	call   801f3a <pageref>
		nn = thisenv->env_runs;
  801a0f:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a15:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a18:	83 c4 10             	add    $0x10,%esp
  801a1b:	39 cb                	cmp    %ecx,%ebx
  801a1d:	74 1b                	je     801a3a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a1f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a22:	75 cf                	jne    8019f3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a24:	8b 42 58             	mov    0x58(%edx),%eax
  801a27:	6a 01                	push   $0x1
  801a29:	50                   	push   %eax
  801a2a:	53                   	push   %ebx
  801a2b:	68 4e 27 80 00       	push   $0x80274e
  801a30:	e8 3b e9 ff ff       	call   800370 <cprintf>
  801a35:	83 c4 10             	add    $0x10,%esp
  801a38:	eb b9                	jmp    8019f3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a3a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a3d:	0f 94 c0             	sete   %al
  801a40:	0f b6 c0             	movzbl %al,%eax
}
  801a43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a46:	5b                   	pop    %ebx
  801a47:	5e                   	pop    %esi
  801a48:	5f                   	pop    %edi
  801a49:	5d                   	pop    %ebp
  801a4a:	c3                   	ret    

00801a4b <devpipe_write>:
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	57                   	push   %edi
  801a4f:	56                   	push   %esi
  801a50:	53                   	push   %ebx
  801a51:	83 ec 28             	sub    $0x28,%esp
  801a54:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a57:	56                   	push   %esi
  801a58:	e8 30 f7 ff ff       	call   80118d <fd2data>
  801a5d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	bf 00 00 00 00       	mov    $0x0,%edi
  801a67:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a6a:	74 4f                	je     801abb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a6c:	8b 43 04             	mov    0x4(%ebx),%eax
  801a6f:	8b 0b                	mov    (%ebx),%ecx
  801a71:	8d 51 20             	lea    0x20(%ecx),%edx
  801a74:	39 d0                	cmp    %edx,%eax
  801a76:	72 14                	jb     801a8c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a78:	89 da                	mov    %ebx,%edx
  801a7a:	89 f0                	mov    %esi,%eax
  801a7c:	e8 65 ff ff ff       	call   8019e6 <_pipeisclosed>
  801a81:	85 c0                	test   %eax,%eax
  801a83:	75 3a                	jne    801abf <devpipe_write+0x74>
			sys_yield();
  801a85:	e8 aa f2 ff ff       	call   800d34 <sys_yield>
  801a8a:	eb e0                	jmp    801a6c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a8f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a93:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a96:	89 c2                	mov    %eax,%edx
  801a98:	c1 fa 1f             	sar    $0x1f,%edx
  801a9b:	89 d1                	mov    %edx,%ecx
  801a9d:	c1 e9 1b             	shr    $0x1b,%ecx
  801aa0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801aa3:	83 e2 1f             	and    $0x1f,%edx
  801aa6:	29 ca                	sub    %ecx,%edx
  801aa8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801aac:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ab0:	83 c0 01             	add    $0x1,%eax
  801ab3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ab6:	83 c7 01             	add    $0x1,%edi
  801ab9:	eb ac                	jmp    801a67 <devpipe_write+0x1c>
	return i;
  801abb:	89 f8                	mov    %edi,%eax
  801abd:	eb 05                	jmp    801ac4 <devpipe_write+0x79>
				return 0;
  801abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5f                   	pop    %edi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    

00801acc <devpipe_read>:
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	57                   	push   %edi
  801ad0:	56                   	push   %esi
  801ad1:	53                   	push   %ebx
  801ad2:	83 ec 18             	sub    $0x18,%esp
  801ad5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ad8:	57                   	push   %edi
  801ad9:	e8 af f6 ff ff       	call   80118d <fd2data>
  801ade:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ae0:	83 c4 10             	add    $0x10,%esp
  801ae3:	be 00 00 00 00       	mov    $0x0,%esi
  801ae8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801aeb:	74 47                	je     801b34 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801aed:	8b 03                	mov    (%ebx),%eax
  801aef:	3b 43 04             	cmp    0x4(%ebx),%eax
  801af2:	75 22                	jne    801b16 <devpipe_read+0x4a>
			if (i > 0)
  801af4:	85 f6                	test   %esi,%esi
  801af6:	75 14                	jne    801b0c <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801af8:	89 da                	mov    %ebx,%edx
  801afa:	89 f8                	mov    %edi,%eax
  801afc:	e8 e5 fe ff ff       	call   8019e6 <_pipeisclosed>
  801b01:	85 c0                	test   %eax,%eax
  801b03:	75 33                	jne    801b38 <devpipe_read+0x6c>
			sys_yield();
  801b05:	e8 2a f2 ff ff       	call   800d34 <sys_yield>
  801b0a:	eb e1                	jmp    801aed <devpipe_read+0x21>
				return i;
  801b0c:	89 f0                	mov    %esi,%eax
}
  801b0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5f                   	pop    %edi
  801b14:	5d                   	pop    %ebp
  801b15:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b16:	99                   	cltd   
  801b17:	c1 ea 1b             	shr    $0x1b,%edx
  801b1a:	01 d0                	add    %edx,%eax
  801b1c:	83 e0 1f             	and    $0x1f,%eax
  801b1f:	29 d0                	sub    %edx,%eax
  801b21:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b29:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b2c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b2f:	83 c6 01             	add    $0x1,%esi
  801b32:	eb b4                	jmp    801ae8 <devpipe_read+0x1c>
	return i;
  801b34:	89 f0                	mov    %esi,%eax
  801b36:	eb d6                	jmp    801b0e <devpipe_read+0x42>
				return 0;
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3d:	eb cf                	jmp    801b0e <devpipe_read+0x42>

00801b3f <pipe>:
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	56                   	push   %esi
  801b43:	53                   	push   %ebx
  801b44:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4a:	50                   	push   %eax
  801b4b:	e8 54 f6 ff ff       	call   8011a4 <fd_alloc>
  801b50:	89 c3                	mov    %eax,%ebx
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	85 c0                	test   %eax,%eax
  801b57:	78 5b                	js     801bb4 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b59:	83 ec 04             	sub    $0x4,%esp
  801b5c:	68 07 04 00 00       	push   $0x407
  801b61:	ff 75 f4             	pushl  -0xc(%ebp)
  801b64:	6a 00                	push   $0x0
  801b66:	e8 e8 f1 ff ff       	call   800d53 <sys_page_alloc>
  801b6b:	89 c3                	mov    %eax,%ebx
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	85 c0                	test   %eax,%eax
  801b72:	78 40                	js     801bb4 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801b74:	83 ec 0c             	sub    $0xc,%esp
  801b77:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b7a:	50                   	push   %eax
  801b7b:	e8 24 f6 ff ff       	call   8011a4 <fd_alloc>
  801b80:	89 c3                	mov    %eax,%ebx
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	85 c0                	test   %eax,%eax
  801b87:	78 1b                	js     801ba4 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b89:	83 ec 04             	sub    $0x4,%esp
  801b8c:	68 07 04 00 00       	push   $0x407
  801b91:	ff 75 f0             	pushl  -0x10(%ebp)
  801b94:	6a 00                	push   $0x0
  801b96:	e8 b8 f1 ff ff       	call   800d53 <sys_page_alloc>
  801b9b:	89 c3                	mov    %eax,%ebx
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	79 19                	jns    801bbd <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801ba4:	83 ec 08             	sub    $0x8,%esp
  801ba7:	ff 75 f4             	pushl  -0xc(%ebp)
  801baa:	6a 00                	push   $0x0
  801bac:	e8 27 f2 ff ff       	call   800dd8 <sys_page_unmap>
  801bb1:	83 c4 10             	add    $0x10,%esp
}
  801bb4:	89 d8                	mov    %ebx,%eax
  801bb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb9:	5b                   	pop    %ebx
  801bba:	5e                   	pop    %esi
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    
	va = fd2data(fd0);
  801bbd:	83 ec 0c             	sub    $0xc,%esp
  801bc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc3:	e8 c5 f5 ff ff       	call   80118d <fd2data>
  801bc8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bca:	83 c4 0c             	add    $0xc,%esp
  801bcd:	68 07 04 00 00       	push   $0x407
  801bd2:	50                   	push   %eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	e8 79 f1 ff ff       	call   800d53 <sys_page_alloc>
  801bda:	89 c3                	mov    %eax,%ebx
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	0f 88 8c 00 00 00    	js     801c73 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	ff 75 f0             	pushl  -0x10(%ebp)
  801bed:	e8 9b f5 ff ff       	call   80118d <fd2data>
  801bf2:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bf9:	50                   	push   %eax
  801bfa:	6a 00                	push   $0x0
  801bfc:	56                   	push   %esi
  801bfd:	6a 00                	push   $0x0
  801bff:	e8 92 f1 ff ff       	call   800d96 <sys_page_map>
  801c04:	89 c3                	mov    %eax,%ebx
  801c06:	83 c4 20             	add    $0x20,%esp
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	78 58                	js     801c65 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c10:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c16:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c25:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c2b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c30:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c37:	83 ec 0c             	sub    $0xc,%esp
  801c3a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c3d:	e8 3b f5 ff ff       	call   80117d <fd2num>
  801c42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c45:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c47:	83 c4 04             	add    $0x4,%esp
  801c4a:	ff 75 f0             	pushl  -0x10(%ebp)
  801c4d:	e8 2b f5 ff ff       	call   80117d <fd2num>
  801c52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c55:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c60:	e9 4f ff ff ff       	jmp    801bb4 <pipe+0x75>
	sys_page_unmap(0, va);
  801c65:	83 ec 08             	sub    $0x8,%esp
  801c68:	56                   	push   %esi
  801c69:	6a 00                	push   $0x0
  801c6b:	e8 68 f1 ff ff       	call   800dd8 <sys_page_unmap>
  801c70:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c73:	83 ec 08             	sub    $0x8,%esp
  801c76:	ff 75 f0             	pushl  -0x10(%ebp)
  801c79:	6a 00                	push   $0x0
  801c7b:	e8 58 f1 ff ff       	call   800dd8 <sys_page_unmap>
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	e9 1c ff ff ff       	jmp    801ba4 <pipe+0x65>

00801c88 <pipeisclosed>:
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c91:	50                   	push   %eax
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	e8 59 f5 ff ff       	call   8011f3 <fd_lookup>
  801c9a:	83 c4 10             	add    $0x10,%esp
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	78 18                	js     801cb9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ca1:	83 ec 0c             	sub    $0xc,%esp
  801ca4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca7:	e8 e1 f4 ff ff       	call   80118d <fd2data>
	return _pipeisclosed(fd, p);
  801cac:	89 c2                	mov    %eax,%edx
  801cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb1:	e8 30 fd ff ff       	call   8019e6 <_pipeisclosed>
  801cb6:	83 c4 10             	add    $0x10,%esp
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc3:	5d                   	pop    %ebp
  801cc4:	c3                   	ret    

00801cc5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ccb:	68 61 27 80 00       	push   $0x802761
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	e8 82 ec ff ff       	call   80095a <strcpy>
	return 0;
}
  801cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <devcons_write>:
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	57                   	push   %edi
  801ce3:	56                   	push   %esi
  801ce4:	53                   	push   %ebx
  801ce5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ceb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801cf0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801cf6:	eb 2f                	jmp    801d27 <devcons_write+0x48>
		m = n - tot;
  801cf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cfb:	29 f3                	sub    %esi,%ebx
  801cfd:	83 fb 7f             	cmp    $0x7f,%ebx
  801d00:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d05:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d08:	83 ec 04             	sub    $0x4,%esp
  801d0b:	53                   	push   %ebx
  801d0c:	89 f0                	mov    %esi,%eax
  801d0e:	03 45 0c             	add    0xc(%ebp),%eax
  801d11:	50                   	push   %eax
  801d12:	57                   	push   %edi
  801d13:	e8 d0 ed ff ff       	call   800ae8 <memmove>
		sys_cputs(buf, m);
  801d18:	83 c4 08             	add    $0x8,%esp
  801d1b:	53                   	push   %ebx
  801d1c:	57                   	push   %edi
  801d1d:	e8 75 ef ff ff       	call   800c97 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d22:	01 de                	add    %ebx,%esi
  801d24:	83 c4 10             	add    $0x10,%esp
  801d27:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d2a:	72 cc                	jb     801cf8 <devcons_write+0x19>
}
  801d2c:	89 f0                	mov    %esi,%eax
  801d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d31:	5b                   	pop    %ebx
  801d32:	5e                   	pop    %esi
  801d33:	5f                   	pop    %edi
  801d34:	5d                   	pop    %ebp
  801d35:	c3                   	ret    

00801d36 <devcons_read>:
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 08             	sub    $0x8,%esp
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d45:	75 07                	jne    801d4e <devcons_read+0x18>
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    
		sys_yield();
  801d49:	e8 e6 ef ff ff       	call   800d34 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801d4e:	e8 62 ef ff ff       	call   800cb5 <sys_cgetc>
  801d53:	85 c0                	test   %eax,%eax
  801d55:	74 f2                	je     801d49 <devcons_read+0x13>
	if (c < 0)
  801d57:	85 c0                	test   %eax,%eax
  801d59:	78 ec                	js     801d47 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801d5b:	83 f8 04             	cmp    $0x4,%eax
  801d5e:	74 0c                	je     801d6c <devcons_read+0x36>
	*(char*)vbuf = c;
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	88 02                	mov    %al,(%edx)
	return 1;
  801d65:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6a:	eb db                	jmp    801d47 <devcons_read+0x11>
		return 0;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d71:	eb d4                	jmp    801d47 <devcons_read+0x11>

00801d73 <cputchar>:
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d7f:	6a 01                	push   $0x1
  801d81:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d84:	50                   	push   %eax
  801d85:	e8 0d ef ff ff       	call   800c97 <sys_cputs>
}
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <getchar>:
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d95:	6a 01                	push   $0x1
  801d97:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d9a:	50                   	push   %eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	e8 c2 f6 ff ff       	call   801464 <read>
	if (r < 0)
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	85 c0                	test   %eax,%eax
  801da7:	78 08                	js     801db1 <getchar+0x22>
	if (r < 1)
  801da9:	85 c0                	test   %eax,%eax
  801dab:	7e 06                	jle    801db3 <getchar+0x24>
	return c;
  801dad:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    
		return -E_EOF;
  801db3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801db8:	eb f7                	jmp    801db1 <getchar+0x22>

00801dba <iscons>:
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dc0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc3:	50                   	push   %eax
  801dc4:	ff 75 08             	pushl  0x8(%ebp)
  801dc7:	e8 27 f4 ff ff       	call   8011f3 <fd_lookup>
  801dcc:	83 c4 10             	add    $0x10,%esp
  801dcf:	85 c0                	test   %eax,%eax
  801dd1:	78 11                	js     801de4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ddc:	39 10                	cmp    %edx,(%eax)
  801dde:	0f 94 c0             	sete   %al
  801de1:	0f b6 c0             	movzbl %al,%eax
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <opencons>:
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801dec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801def:	50                   	push   %eax
  801df0:	e8 af f3 ff ff       	call   8011a4 <fd_alloc>
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	78 3a                	js     801e36 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801dfc:	83 ec 04             	sub    $0x4,%esp
  801dff:	68 07 04 00 00       	push   $0x407
  801e04:	ff 75 f4             	pushl  -0xc(%ebp)
  801e07:	6a 00                	push   $0x0
  801e09:	e8 45 ef ff ff       	call   800d53 <sys_page_alloc>
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	85 c0                	test   %eax,%eax
  801e13:	78 21                	js     801e36 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e18:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e1e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e23:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e2a:	83 ec 0c             	sub    $0xc,%esp
  801e2d:	50                   	push   %eax
  801e2e:	e8 4a f3 ff ff       	call   80117d <fd2num>
  801e33:	83 c4 10             	add    $0x10,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	53                   	push   %ebx
  801e3c:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801e3f:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801e46:	74 0d                	je     801e55 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801e50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801e55:	e8 bb ee ff ff       	call   800d15 <sys_getenvid>
  801e5a:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	6a 07                	push   $0x7
  801e61:	68 00 f0 bf ee       	push   $0xeebff000
  801e66:	50                   	push   %eax
  801e67:	e8 e7 ee ff ff       	call   800d53 <sys_page_alloc>
        	if (r < 0) {
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	78 27                	js     801e9a <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801e73:	83 ec 08             	sub    $0x8,%esp
  801e76:	68 ac 1e 80 00       	push   $0x801eac
  801e7b:	53                   	push   %ebx
  801e7c:	e8 1d f0 ff ff       	call   800e9e <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801e81:	83 c4 10             	add    $0x10,%esp
  801e84:	85 c0                	test   %eax,%eax
  801e86:	79 c0                	jns    801e48 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801e88:	50                   	push   %eax
  801e89:	68 6d 27 80 00       	push   $0x80276d
  801e8e:	6a 28                	push   $0x28
  801e90:	68 81 27 80 00       	push   $0x802781
  801e95:	e8 fb e3 ff ff       	call   800295 <_panic>
            		panic("pgfault_handler: %e", r);
  801e9a:	50                   	push   %eax
  801e9b:	68 6d 27 80 00       	push   $0x80276d
  801ea0:	6a 24                	push   $0x24
  801ea2:	68 81 27 80 00       	push   $0x802781
  801ea7:	e8 e9 e3 ff ff       	call   800295 <_panic>

00801eac <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801eac:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801ead:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801eb2:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801eb4:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801eb7:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801ebb:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801ebe:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801ec2:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801ec6:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801ec9:	83 c4 08             	add    $0x8,%esp
	popal
  801ecc:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801ecd:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801ed0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801ed1:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801ed2:	c3                   	ret    

00801ed3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801ed9:	68 8f 27 80 00       	push   $0x80278f
  801ede:	6a 1a                	push   $0x1a
  801ee0:	68 a8 27 80 00       	push   $0x8027a8
  801ee5:	e8 ab e3 ff ff       	call   800295 <_panic>

00801eea <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801ef0:	68 b2 27 80 00       	push   $0x8027b2
  801ef5:	6a 2a                	push   $0x2a
  801ef7:	68 a8 27 80 00       	push   $0x8027a8
  801efc:	e8 94 e3 ff ff       	call   800295 <_panic>

00801f01 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f0c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f0f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f15:	8b 52 50             	mov    0x50(%edx),%edx
  801f18:	39 ca                	cmp    %ecx,%edx
  801f1a:	74 11                	je     801f2d <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801f1c:	83 c0 01             	add    $0x1,%eax
  801f1f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f24:	75 e6                	jne    801f0c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801f26:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2b:	eb 0b                	jmp    801f38 <ipc_find_env+0x37>
			return envs[i].env_id;
  801f2d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f30:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f35:	8b 40 48             	mov    0x48(%eax),%eax
}
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    

00801f3a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f40:	89 d0                	mov    %edx,%eax
  801f42:	c1 e8 16             	shr    $0x16,%eax
  801f45:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f4c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801f51:	f6 c1 01             	test   $0x1,%cl
  801f54:	74 1d                	je     801f73 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801f56:	c1 ea 0c             	shr    $0xc,%edx
  801f59:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f60:	f6 c2 01             	test   $0x1,%dl
  801f63:	74 0e                	je     801f73 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f65:	c1 ea 0c             	shr    $0xc,%edx
  801f68:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f6f:	ef 
  801f70:	0f b7 c0             	movzwl %ax,%eax
}
  801f73:	5d                   	pop    %ebp
  801f74:	c3                   	ret    
  801f75:	66 90                	xchg   %ax,%ax
  801f77:	66 90                	xchg   %ax,%ax
  801f79:	66 90                	xchg   %ax,%ax
  801f7b:	66 90                	xchg   %ax,%ax
  801f7d:	66 90                	xchg   %ax,%ax
  801f7f:	90                   	nop

00801f80 <__udivdi3>:
  801f80:	55                   	push   %ebp
  801f81:	57                   	push   %edi
  801f82:	56                   	push   %esi
  801f83:	53                   	push   %ebx
  801f84:	83 ec 1c             	sub    $0x1c,%esp
  801f87:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f8b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f93:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f97:	85 d2                	test   %edx,%edx
  801f99:	75 35                	jne    801fd0 <__udivdi3+0x50>
  801f9b:	39 f3                	cmp    %esi,%ebx
  801f9d:	0f 87 bd 00 00 00    	ja     802060 <__udivdi3+0xe0>
  801fa3:	85 db                	test   %ebx,%ebx
  801fa5:	89 d9                	mov    %ebx,%ecx
  801fa7:	75 0b                	jne    801fb4 <__udivdi3+0x34>
  801fa9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fae:	31 d2                	xor    %edx,%edx
  801fb0:	f7 f3                	div    %ebx
  801fb2:	89 c1                	mov    %eax,%ecx
  801fb4:	31 d2                	xor    %edx,%edx
  801fb6:	89 f0                	mov    %esi,%eax
  801fb8:	f7 f1                	div    %ecx
  801fba:	89 c6                	mov    %eax,%esi
  801fbc:	89 e8                	mov    %ebp,%eax
  801fbe:	89 f7                	mov    %esi,%edi
  801fc0:	f7 f1                	div    %ecx
  801fc2:	89 fa                	mov    %edi,%edx
  801fc4:	83 c4 1c             	add    $0x1c,%esp
  801fc7:	5b                   	pop    %ebx
  801fc8:	5e                   	pop    %esi
  801fc9:	5f                   	pop    %edi
  801fca:	5d                   	pop    %ebp
  801fcb:	c3                   	ret    
  801fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fd0:	39 f2                	cmp    %esi,%edx
  801fd2:	77 7c                	ja     802050 <__udivdi3+0xd0>
  801fd4:	0f bd fa             	bsr    %edx,%edi
  801fd7:	83 f7 1f             	xor    $0x1f,%edi
  801fda:	0f 84 98 00 00 00    	je     802078 <__udivdi3+0xf8>
  801fe0:	89 f9                	mov    %edi,%ecx
  801fe2:	b8 20 00 00 00       	mov    $0x20,%eax
  801fe7:	29 f8                	sub    %edi,%eax
  801fe9:	d3 e2                	shl    %cl,%edx
  801feb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fef:	89 c1                	mov    %eax,%ecx
  801ff1:	89 da                	mov    %ebx,%edx
  801ff3:	d3 ea                	shr    %cl,%edx
  801ff5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ff9:	09 d1                	or     %edx,%ecx
  801ffb:	89 f2                	mov    %esi,%edx
  801ffd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802001:	89 f9                	mov    %edi,%ecx
  802003:	d3 e3                	shl    %cl,%ebx
  802005:	89 c1                	mov    %eax,%ecx
  802007:	d3 ea                	shr    %cl,%edx
  802009:	89 f9                	mov    %edi,%ecx
  80200b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80200f:	d3 e6                	shl    %cl,%esi
  802011:	89 eb                	mov    %ebp,%ebx
  802013:	89 c1                	mov    %eax,%ecx
  802015:	d3 eb                	shr    %cl,%ebx
  802017:	09 de                	or     %ebx,%esi
  802019:	89 f0                	mov    %esi,%eax
  80201b:	f7 74 24 08          	divl   0x8(%esp)
  80201f:	89 d6                	mov    %edx,%esi
  802021:	89 c3                	mov    %eax,%ebx
  802023:	f7 64 24 0c          	mull   0xc(%esp)
  802027:	39 d6                	cmp    %edx,%esi
  802029:	72 0c                	jb     802037 <__udivdi3+0xb7>
  80202b:	89 f9                	mov    %edi,%ecx
  80202d:	d3 e5                	shl    %cl,%ebp
  80202f:	39 c5                	cmp    %eax,%ebp
  802031:	73 5d                	jae    802090 <__udivdi3+0x110>
  802033:	39 d6                	cmp    %edx,%esi
  802035:	75 59                	jne    802090 <__udivdi3+0x110>
  802037:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80203a:	31 ff                	xor    %edi,%edi
  80203c:	89 fa                	mov    %edi,%edx
  80203e:	83 c4 1c             	add    $0x1c,%esp
  802041:	5b                   	pop    %ebx
  802042:	5e                   	pop    %esi
  802043:	5f                   	pop    %edi
  802044:	5d                   	pop    %ebp
  802045:	c3                   	ret    
  802046:	8d 76 00             	lea    0x0(%esi),%esi
  802049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802050:	31 ff                	xor    %edi,%edi
  802052:	31 c0                	xor    %eax,%eax
  802054:	89 fa                	mov    %edi,%edx
  802056:	83 c4 1c             	add    $0x1c,%esp
  802059:	5b                   	pop    %ebx
  80205a:	5e                   	pop    %esi
  80205b:	5f                   	pop    %edi
  80205c:	5d                   	pop    %ebp
  80205d:	c3                   	ret    
  80205e:	66 90                	xchg   %ax,%ax
  802060:	31 ff                	xor    %edi,%edi
  802062:	89 e8                	mov    %ebp,%eax
  802064:	89 f2                	mov    %esi,%edx
  802066:	f7 f3                	div    %ebx
  802068:	89 fa                	mov    %edi,%edx
  80206a:	83 c4 1c             	add    $0x1c,%esp
  80206d:	5b                   	pop    %ebx
  80206e:	5e                   	pop    %esi
  80206f:	5f                   	pop    %edi
  802070:	5d                   	pop    %ebp
  802071:	c3                   	ret    
  802072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802078:	39 f2                	cmp    %esi,%edx
  80207a:	72 06                	jb     802082 <__udivdi3+0x102>
  80207c:	31 c0                	xor    %eax,%eax
  80207e:	39 eb                	cmp    %ebp,%ebx
  802080:	77 d2                	ja     802054 <__udivdi3+0xd4>
  802082:	b8 01 00 00 00       	mov    $0x1,%eax
  802087:	eb cb                	jmp    802054 <__udivdi3+0xd4>
  802089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802090:	89 d8                	mov    %ebx,%eax
  802092:	31 ff                	xor    %edi,%edi
  802094:	eb be                	jmp    802054 <__udivdi3+0xd4>
  802096:	66 90                	xchg   %ax,%ax
  802098:	66 90                	xchg   %ax,%ax
  80209a:	66 90                	xchg   %ax,%ax
  80209c:	66 90                	xchg   %ax,%ax
  80209e:	66 90                	xchg   %ax,%ax

008020a0 <__umoddi3>:
  8020a0:	55                   	push   %ebp
  8020a1:	57                   	push   %edi
  8020a2:	56                   	push   %esi
  8020a3:	53                   	push   %ebx
  8020a4:	83 ec 1c             	sub    $0x1c,%esp
  8020a7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8020ab:	8b 74 24 30          	mov    0x30(%esp),%esi
  8020af:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8020b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020b7:	85 ed                	test   %ebp,%ebp
  8020b9:	89 f0                	mov    %esi,%eax
  8020bb:	89 da                	mov    %ebx,%edx
  8020bd:	75 19                	jne    8020d8 <__umoddi3+0x38>
  8020bf:	39 df                	cmp    %ebx,%edi
  8020c1:	0f 86 b1 00 00 00    	jbe    802178 <__umoddi3+0xd8>
  8020c7:	f7 f7                	div    %edi
  8020c9:	89 d0                	mov    %edx,%eax
  8020cb:	31 d2                	xor    %edx,%edx
  8020cd:	83 c4 1c             	add    $0x1c,%esp
  8020d0:	5b                   	pop    %ebx
  8020d1:	5e                   	pop    %esi
  8020d2:	5f                   	pop    %edi
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    
  8020d5:	8d 76 00             	lea    0x0(%esi),%esi
  8020d8:	39 dd                	cmp    %ebx,%ebp
  8020da:	77 f1                	ja     8020cd <__umoddi3+0x2d>
  8020dc:	0f bd cd             	bsr    %ebp,%ecx
  8020df:	83 f1 1f             	xor    $0x1f,%ecx
  8020e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020e6:	0f 84 b4 00 00 00    	je     8021a0 <__umoddi3+0x100>
  8020ec:	b8 20 00 00 00       	mov    $0x20,%eax
  8020f1:	89 c2                	mov    %eax,%edx
  8020f3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020f7:	29 c2                	sub    %eax,%edx
  8020f9:	89 c1                	mov    %eax,%ecx
  8020fb:	89 f8                	mov    %edi,%eax
  8020fd:	d3 e5                	shl    %cl,%ebp
  8020ff:	89 d1                	mov    %edx,%ecx
  802101:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802105:	d3 e8                	shr    %cl,%eax
  802107:	09 c5                	or     %eax,%ebp
  802109:	8b 44 24 04          	mov    0x4(%esp),%eax
  80210d:	89 c1                	mov    %eax,%ecx
  80210f:	d3 e7                	shl    %cl,%edi
  802111:	89 d1                	mov    %edx,%ecx
  802113:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802117:	89 df                	mov    %ebx,%edi
  802119:	d3 ef                	shr    %cl,%edi
  80211b:	89 c1                	mov    %eax,%ecx
  80211d:	89 f0                	mov    %esi,%eax
  80211f:	d3 e3                	shl    %cl,%ebx
  802121:	89 d1                	mov    %edx,%ecx
  802123:	89 fa                	mov    %edi,%edx
  802125:	d3 e8                	shr    %cl,%eax
  802127:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80212c:	09 d8                	or     %ebx,%eax
  80212e:	f7 f5                	div    %ebp
  802130:	d3 e6                	shl    %cl,%esi
  802132:	89 d1                	mov    %edx,%ecx
  802134:	f7 64 24 08          	mull   0x8(%esp)
  802138:	39 d1                	cmp    %edx,%ecx
  80213a:	89 c3                	mov    %eax,%ebx
  80213c:	89 d7                	mov    %edx,%edi
  80213e:	72 06                	jb     802146 <__umoddi3+0xa6>
  802140:	75 0e                	jne    802150 <__umoddi3+0xb0>
  802142:	39 c6                	cmp    %eax,%esi
  802144:	73 0a                	jae    802150 <__umoddi3+0xb0>
  802146:	2b 44 24 08          	sub    0x8(%esp),%eax
  80214a:	19 ea                	sbb    %ebp,%edx
  80214c:	89 d7                	mov    %edx,%edi
  80214e:	89 c3                	mov    %eax,%ebx
  802150:	89 ca                	mov    %ecx,%edx
  802152:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802157:	29 de                	sub    %ebx,%esi
  802159:	19 fa                	sbb    %edi,%edx
  80215b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80215f:	89 d0                	mov    %edx,%eax
  802161:	d3 e0                	shl    %cl,%eax
  802163:	89 d9                	mov    %ebx,%ecx
  802165:	d3 ee                	shr    %cl,%esi
  802167:	d3 ea                	shr    %cl,%edx
  802169:	09 f0                	or     %esi,%eax
  80216b:	83 c4 1c             	add    $0x1c,%esp
  80216e:	5b                   	pop    %ebx
  80216f:	5e                   	pop    %esi
  802170:	5f                   	pop    %edi
  802171:	5d                   	pop    %ebp
  802172:	c3                   	ret    
  802173:	90                   	nop
  802174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802178:	85 ff                	test   %edi,%edi
  80217a:	89 f9                	mov    %edi,%ecx
  80217c:	75 0b                	jne    802189 <__umoddi3+0xe9>
  80217e:	b8 01 00 00 00       	mov    $0x1,%eax
  802183:	31 d2                	xor    %edx,%edx
  802185:	f7 f7                	div    %edi
  802187:	89 c1                	mov    %eax,%ecx
  802189:	89 d8                	mov    %ebx,%eax
  80218b:	31 d2                	xor    %edx,%edx
  80218d:	f7 f1                	div    %ecx
  80218f:	89 f0                	mov    %esi,%eax
  802191:	f7 f1                	div    %ecx
  802193:	e9 31 ff ff ff       	jmp    8020c9 <__umoddi3+0x29>
  802198:	90                   	nop
  802199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021a0:	39 dd                	cmp    %ebx,%ebp
  8021a2:	72 08                	jb     8021ac <__umoddi3+0x10c>
  8021a4:	39 f7                	cmp    %esi,%edi
  8021a6:	0f 87 21 ff ff ff    	ja     8020cd <__umoddi3+0x2d>
  8021ac:	89 da                	mov    %ebx,%edx
  8021ae:	89 f0                	mov    %esi,%eax
  8021b0:	29 f8                	sub    %edi,%eax
  8021b2:	19 ea                	sbb    %ebp,%edx
  8021b4:	e9 14 ff ff ff       	jmp    8020cd <__umoddi3+0x2d>
