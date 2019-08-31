
obj/user/testfdsharing.debug：     文件格式 elf32-i386


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
  80002c:	e8 9b 01 00 00       	call   8001cc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	6a 00                	push   $0x0
  80003e:	68 a0 21 80 00       	push   $0x8021a0
  800043:	e8 18 18 00 00       	call   801860 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 01 01 00 00    	js     800156 <umain+0x123>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 eb 14 00 00       	call   80154b <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 42 80 00       	push   $0x804220
  80006d:	53                   	push   %ebx
  80006e:	e8 0f 14 00 00       	call   801482 <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e8 00 00 00    	jle    800168 <umain+0x135>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 6d 0e 00 00       	call   800ef2 <fork>
  800085:	89 c7                	mov    %eax,%edi
  800087:	85 c0                	test   %eax,%eax
  800089:	0f 88 eb 00 00 00    	js     80017a <umain+0x147>
		panic("fork: %e", r);
	if (r == 0) {
  80008f:	85 c0                	test   %eax,%eax
  800091:	75 7b                	jne    80010e <umain+0xdb>
		seek(fd, 0);
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	6a 00                	push   $0x0
  800098:	53                   	push   %ebx
  800099:	e8 ad 14 00 00       	call   80154b <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009e:	c7 04 24 10 22 80 00 	movl   $0x802210,(%esp)
  8000a5:	e8 5d 02 00 00       	call   800307 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 02 00 00       	push   $0x200
  8000b2:	68 20 40 80 00       	push   $0x804020
  8000b7:	53                   	push   %ebx
  8000b8:	e8 c5 13 00 00       	call   801482 <readn>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	39 c6                	cmp    %eax,%esi
  8000c2:	0f 85 c4 00 00 00    	jne    80018c <umain+0x159>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c8:	83 ec 04             	sub    $0x4,%esp
  8000cb:	56                   	push   %esi
  8000cc:	68 20 40 80 00       	push   $0x804020
  8000d1:	68 20 42 80 00       	push   $0x804220
  8000d6:	e8 1f 0a 00 00       	call   800afa <memcmp>
  8000db:	83 c4 10             	add    $0x10,%esp
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 85 bc 00 00 00    	jne    8001a2 <umain+0x16f>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 db 21 80 00       	push   $0x8021db
  8000ee:	e8 14 02 00 00       	call   800307 <cprintf>
		seek(fd, 0);
  8000f3:	83 c4 08             	add    $0x8,%esp
  8000f6:	6a 00                	push   $0x0
  8000f8:	53                   	push   %ebx
  8000f9:	e8 4d 14 00 00       	call   80154b <seek>
		close(fd);
  8000fe:	89 1c 24             	mov    %ebx,(%esp)
  800101:	e8 b9 11 00 00       	call   8012bf <close>
		exit();
  800106:	e8 07 01 00 00       	call   800212 <exit>
  80010b:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	57                   	push   %edi
  800112:	e8 3b 1b 00 00       	call   801c52 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800117:	83 c4 0c             	add    $0xc,%esp
  80011a:	68 00 02 00 00       	push   $0x200
  80011f:	68 20 40 80 00       	push   $0x804020
  800124:	53                   	push   %ebx
  800125:	e8 58 13 00 00       	call   801482 <readn>
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	39 c6                	cmp    %eax,%esi
  80012f:	0f 85 81 00 00 00    	jne    8001b6 <umain+0x183>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	68 f4 21 80 00       	push   $0x8021f4
  80013d:	e8 c5 01 00 00       	call   800307 <cprintf>
	close(fd);
  800142:	89 1c 24             	mov    %ebx,(%esp)
  800145:	e8 75 11 00 00       	call   8012bf <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80014a:	cc                   	int3   

	breakpoint();
}
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5f                   	pop    %edi
  800154:	5d                   	pop    %ebp
  800155:	c3                   	ret    
		panic("open motd: %e", fd);
  800156:	50                   	push   %eax
  800157:	68 a5 21 80 00       	push   $0x8021a5
  80015c:	6a 0c                	push   $0xc
  80015e:	68 b3 21 80 00       	push   $0x8021b3
  800163:	e8 c4 00 00 00       	call   80022c <_panic>
		panic("readn: %e", n);
  800168:	50                   	push   %eax
  800169:	68 c8 21 80 00       	push   $0x8021c8
  80016e:	6a 0f                	push   $0xf
  800170:	68 b3 21 80 00       	push   $0x8021b3
  800175:	e8 b2 00 00 00       	call   80022c <_panic>
		panic("fork: %e", r);
  80017a:	50                   	push   %eax
  80017b:	68 d2 21 80 00       	push   $0x8021d2
  800180:	6a 12                	push   $0x12
  800182:	68 b3 21 80 00       	push   $0x8021b3
  800187:	e8 a0 00 00 00       	call   80022c <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	56                   	push   %esi
  800191:	68 54 22 80 00       	push   $0x802254
  800196:	6a 17                	push   $0x17
  800198:	68 b3 21 80 00       	push   $0x8021b3
  80019d:	e8 8a 00 00 00       	call   80022c <_panic>
			panic("read in parent got different bytes from read in child");
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 80 22 80 00       	push   $0x802280
  8001aa:	6a 19                	push   $0x19
  8001ac:	68 b3 21 80 00       	push   $0x8021b3
  8001b1:	e8 76 00 00 00       	call   80022c <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	50                   	push   %eax
  8001ba:	56                   	push   %esi
  8001bb:	68 b8 22 80 00       	push   $0x8022b8
  8001c0:	6a 21                	push   $0x21
  8001c2:	68 b3 21 80 00       	push   $0x8021b3
  8001c7:	e8 60 00 00 00       	call   80022c <_panic>

008001cc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001d7:	e8 d0 0a 00 00       	call   800cac <sys_getenvid>
  8001dc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e9:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ee:	85 db                	test   %ebx,%ebx
  8001f0:	7e 07                	jle    8001f9 <libmain+0x2d>
		binaryname = argv[0];
  8001f2:	8b 06                	mov    (%esi),%eax
  8001f4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	56                   	push   %esi
  8001fd:	53                   	push   %ebx
  8001fe:	e8 30 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800203:	e8 0a 00 00 00       	call   800212 <exit>
}
  800208:	83 c4 10             	add    $0x10,%esp
  80020b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5d                   	pop    %ebp
  800211:	c3                   	ret    

00800212 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800218:	e8 cd 10 00 00       	call   8012ea <close_all>
	sys_env_destroy(0);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	6a 00                	push   $0x0
  800222:	e8 44 0a 00 00       	call   800c6b <sys_env_destroy>
}
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	56                   	push   %esi
  800230:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800231:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800234:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80023a:	e8 6d 0a 00 00       	call   800cac <sys_getenvid>
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	56                   	push   %esi
  800249:	50                   	push   %eax
  80024a:	68 e8 22 80 00       	push   $0x8022e8
  80024f:	e8 b3 00 00 00       	call   800307 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800254:	83 c4 18             	add    $0x18,%esp
  800257:	53                   	push   %ebx
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	e8 56 00 00 00       	call   8002b6 <vcprintf>
	cprintf("\n");
  800260:	c7 04 24 f2 21 80 00 	movl   $0x8021f2,(%esp)
  800267:	e8 9b 00 00 00       	call   800307 <cprintf>
  80026c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026f:	cc                   	int3   
  800270:	eb fd                	jmp    80026f <_panic+0x43>

00800272 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	53                   	push   %ebx
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027c:	8b 13                	mov    (%ebx),%edx
  80027e:	8d 42 01             	lea    0x1(%edx),%eax
  800281:	89 03                	mov    %eax,(%ebx)
  800283:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800286:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80028a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028f:	74 09                	je     80029a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800291:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800298:	c9                   	leave  
  800299:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	68 ff 00 00 00       	push   $0xff
  8002a2:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a5:	50                   	push   %eax
  8002a6:	e8 83 09 00 00       	call   800c2e <sys_cputs>
		b->idx = 0;
  8002ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b1:	83 c4 10             	add    $0x10,%esp
  8002b4:	eb db                	jmp    800291 <putch+0x1f>

008002b6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c6:	00 00 00 
	b.cnt = 0;
  8002c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d3:	ff 75 0c             	pushl  0xc(%ebp)
  8002d6:	ff 75 08             	pushl  0x8(%ebp)
  8002d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002df:	50                   	push   %eax
  8002e0:	68 72 02 80 00       	push   $0x800272
  8002e5:	e8 1a 01 00 00       	call   800404 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ea:	83 c4 08             	add    $0x8,%esp
  8002ed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f9:	50                   	push   %eax
  8002fa:	e8 2f 09 00 00       	call   800c2e <sys_cputs>

	return b.cnt;
}
  8002ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800310:	50                   	push   %eax
  800311:	ff 75 08             	pushl  0x8(%ebp)
  800314:	e8 9d ff ff ff       	call   8002b6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	57                   	push   %edi
  80031f:	56                   	push   %esi
  800320:	53                   	push   %ebx
  800321:	83 ec 1c             	sub    $0x1c,%esp
  800324:	89 c7                	mov    %eax,%edi
  800326:	89 d6                	mov    %edx,%esi
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800331:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800334:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800337:	bb 00 00 00 00       	mov    $0x0,%ebx
  80033c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80033f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800342:	39 d3                	cmp    %edx,%ebx
  800344:	72 05                	jb     80034b <printnum+0x30>
  800346:	39 45 10             	cmp    %eax,0x10(%ebp)
  800349:	77 7a                	ja     8003c5 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	ff 75 18             	pushl  0x18(%ebp)
  800351:	8b 45 14             	mov    0x14(%ebp),%eax
  800354:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800357:	53                   	push   %ebx
  800358:	ff 75 10             	pushl  0x10(%ebp)
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800361:	ff 75 e0             	pushl  -0x20(%ebp)
  800364:	ff 75 dc             	pushl  -0x24(%ebp)
  800367:	ff 75 d8             	pushl  -0x28(%ebp)
  80036a:	e8 f1 1b 00 00       	call   801f60 <__udivdi3>
  80036f:	83 c4 18             	add    $0x18,%esp
  800372:	52                   	push   %edx
  800373:	50                   	push   %eax
  800374:	89 f2                	mov    %esi,%edx
  800376:	89 f8                	mov    %edi,%eax
  800378:	e8 9e ff ff ff       	call   80031b <printnum>
  80037d:	83 c4 20             	add    $0x20,%esp
  800380:	eb 13                	jmp    800395 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800382:	83 ec 08             	sub    $0x8,%esp
  800385:	56                   	push   %esi
  800386:	ff 75 18             	pushl  0x18(%ebp)
  800389:	ff d7                	call   *%edi
  80038b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80038e:	83 eb 01             	sub    $0x1,%ebx
  800391:	85 db                	test   %ebx,%ebx
  800393:	7f ed                	jg     800382 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	56                   	push   %esi
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039f:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a8:	e8 d3 1c 00 00       	call   802080 <__umoddi3>
  8003ad:	83 c4 14             	add    $0x14,%esp
  8003b0:	0f be 80 0b 23 80 00 	movsbl 0x80230b(%eax),%eax
  8003b7:	50                   	push   %eax
  8003b8:	ff d7                	call   *%edi
}
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c0:	5b                   	pop    %ebx
  8003c1:	5e                   	pop    %esi
  8003c2:	5f                   	pop    %edi
  8003c3:	5d                   	pop    %ebp
  8003c4:	c3                   	ret    
  8003c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003c8:	eb c4                	jmp    80038e <printnum+0x73>

008003ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d4:	8b 10                	mov    (%eax),%edx
  8003d6:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d9:	73 0a                	jae    8003e5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003db:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003de:	89 08                	mov    %ecx,(%eax)
  8003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e3:	88 02                	mov    %al,(%edx)
}
  8003e5:	5d                   	pop    %ebp
  8003e6:	c3                   	ret    

008003e7 <printfmt>:
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003ed:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f0:	50                   	push   %eax
  8003f1:	ff 75 10             	pushl  0x10(%ebp)
  8003f4:	ff 75 0c             	pushl  0xc(%ebp)
  8003f7:	ff 75 08             	pushl  0x8(%ebp)
  8003fa:	e8 05 00 00 00       	call   800404 <vprintfmt>
}
  8003ff:	83 c4 10             	add    $0x10,%esp
  800402:	c9                   	leave  
  800403:	c3                   	ret    

00800404 <vprintfmt>:
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	57                   	push   %edi
  800408:	56                   	push   %esi
  800409:	53                   	push   %ebx
  80040a:	83 ec 2c             	sub    $0x2c,%esp
  80040d:	8b 75 08             	mov    0x8(%ebp),%esi
  800410:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800413:	8b 7d 10             	mov    0x10(%ebp),%edi
  800416:	e9 8c 03 00 00       	jmp    8007a7 <vprintfmt+0x3a3>
		padc = ' ';
  80041b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80041f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800426:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80042d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800434:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800439:	8d 47 01             	lea    0x1(%edi),%eax
  80043c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80043f:	0f b6 17             	movzbl (%edi),%edx
  800442:	8d 42 dd             	lea    -0x23(%edx),%eax
  800445:	3c 55                	cmp    $0x55,%al
  800447:	0f 87 dd 03 00 00    	ja     80082a <vprintfmt+0x426>
  80044d:	0f b6 c0             	movzbl %al,%eax
  800450:	ff 24 85 40 24 80 00 	jmp    *0x802440(,%eax,4)
  800457:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80045a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80045e:	eb d9                	jmp    800439 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800460:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800463:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800467:	eb d0                	jmp    800439 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800469:	0f b6 d2             	movzbl %dl,%edx
  80046c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80046f:	b8 00 00 00 00       	mov    $0x0,%eax
  800474:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800477:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80047a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80047e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800481:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800484:	83 f9 09             	cmp    $0x9,%ecx
  800487:	77 55                	ja     8004de <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800489:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80048c:	eb e9                	jmp    800477 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80048e:	8b 45 14             	mov    0x14(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800496:	8b 45 14             	mov    0x14(%ebp),%eax
  800499:	8d 40 04             	lea    0x4(%eax),%eax
  80049c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a6:	79 91                	jns    800439 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ae:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004b5:	eb 82                	jmp    800439 <vprintfmt+0x35>
  8004b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ba:	85 c0                	test   %eax,%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c1:	0f 49 d0             	cmovns %eax,%edx
  8004c4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ca:	e9 6a ff ff ff       	jmp    800439 <vprintfmt+0x35>
  8004cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004d2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004d9:	e9 5b ff ff ff       	jmp    800439 <vprintfmt+0x35>
  8004de:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004e4:	eb bc                	jmp    8004a2 <vprintfmt+0x9e>
			lflag++;
  8004e6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004ec:	e9 48 ff ff ff       	jmp    800439 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8d 78 04             	lea    0x4(%eax),%edi
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	53                   	push   %ebx
  8004fb:	ff 30                	pushl  (%eax)
  8004fd:	ff d6                	call   *%esi
			break;
  8004ff:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800502:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800505:	e9 9a 02 00 00       	jmp    8007a4 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	8d 78 04             	lea    0x4(%eax),%edi
  800510:	8b 00                	mov    (%eax),%eax
  800512:	99                   	cltd   
  800513:	31 d0                	xor    %edx,%eax
  800515:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800517:	83 f8 0f             	cmp    $0xf,%eax
  80051a:	7f 23                	jg     80053f <vprintfmt+0x13b>
  80051c:	8b 14 85 a0 25 80 00 	mov    0x8025a0(,%eax,4),%edx
  800523:	85 d2                	test   %edx,%edx
  800525:	74 18                	je     80053f <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800527:	52                   	push   %edx
  800528:	68 8d 27 80 00       	push   $0x80278d
  80052d:	53                   	push   %ebx
  80052e:	56                   	push   %esi
  80052f:	e8 b3 fe ff ff       	call   8003e7 <printfmt>
  800534:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800537:	89 7d 14             	mov    %edi,0x14(%ebp)
  80053a:	e9 65 02 00 00       	jmp    8007a4 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80053f:	50                   	push   %eax
  800540:	68 23 23 80 00       	push   $0x802323
  800545:	53                   	push   %ebx
  800546:	56                   	push   %esi
  800547:	e8 9b fe ff ff       	call   8003e7 <printfmt>
  80054c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800552:	e9 4d 02 00 00       	jmp    8007a4 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	83 c0 04             	add    $0x4,%eax
  80055d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800565:	85 ff                	test   %edi,%edi
  800567:	b8 1c 23 80 00       	mov    $0x80231c,%eax
  80056c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80056f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800573:	0f 8e bd 00 00 00    	jle    800636 <vprintfmt+0x232>
  800579:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80057d:	75 0e                	jne    80058d <vprintfmt+0x189>
  80057f:	89 75 08             	mov    %esi,0x8(%ebp)
  800582:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800585:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800588:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80058b:	eb 6d                	jmp    8005fa <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 d0             	pushl  -0x30(%ebp)
  800593:	57                   	push   %edi
  800594:	e8 39 03 00 00       	call   8008d2 <strnlen>
  800599:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059c:	29 c1                	sub    %eax,%ecx
  80059e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005a1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005a4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ab:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005ae:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b0:	eb 0f                	jmp    8005c1 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bb:	83 ef 01             	sub    $0x1,%edi
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	85 ff                	test   %edi,%edi
  8005c3:	7f ed                	jg     8005b2 <vprintfmt+0x1ae>
  8005c5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005c8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005cb:	85 c9                	test   %ecx,%ecx
  8005cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d2:	0f 49 c1             	cmovns %ecx,%eax
  8005d5:	29 c1                	sub    %eax,%ecx
  8005d7:	89 75 08             	mov    %esi,0x8(%ebp)
  8005da:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005dd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e0:	89 cb                	mov    %ecx,%ebx
  8005e2:	eb 16                	jmp    8005fa <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e8:	75 31                	jne    80061b <vprintfmt+0x217>
					putch(ch, putdat);
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	ff 75 0c             	pushl  0xc(%ebp)
  8005f0:	50                   	push   %eax
  8005f1:	ff 55 08             	call   *0x8(%ebp)
  8005f4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f7:	83 eb 01             	sub    $0x1,%ebx
  8005fa:	83 c7 01             	add    $0x1,%edi
  8005fd:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800601:	0f be c2             	movsbl %dl,%eax
  800604:	85 c0                	test   %eax,%eax
  800606:	74 59                	je     800661 <vprintfmt+0x25d>
  800608:	85 f6                	test   %esi,%esi
  80060a:	78 d8                	js     8005e4 <vprintfmt+0x1e0>
  80060c:	83 ee 01             	sub    $0x1,%esi
  80060f:	79 d3                	jns    8005e4 <vprintfmt+0x1e0>
  800611:	89 df                	mov    %ebx,%edi
  800613:	8b 75 08             	mov    0x8(%ebp),%esi
  800616:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800619:	eb 37                	jmp    800652 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80061b:	0f be d2             	movsbl %dl,%edx
  80061e:	83 ea 20             	sub    $0x20,%edx
  800621:	83 fa 5e             	cmp    $0x5e,%edx
  800624:	76 c4                	jbe    8005ea <vprintfmt+0x1e6>
					putch('?', putdat);
  800626:	83 ec 08             	sub    $0x8,%esp
  800629:	ff 75 0c             	pushl  0xc(%ebp)
  80062c:	6a 3f                	push   $0x3f
  80062e:	ff 55 08             	call   *0x8(%ebp)
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	eb c1                	jmp    8005f7 <vprintfmt+0x1f3>
  800636:	89 75 08             	mov    %esi,0x8(%ebp)
  800639:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80063c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80063f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800642:	eb b6                	jmp    8005fa <vprintfmt+0x1f6>
				putch(' ', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 20                	push   $0x20
  80064a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064c:	83 ef 01             	sub    $0x1,%edi
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	85 ff                	test   %edi,%edi
  800654:	7f ee                	jg     800644 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800656:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
  80065c:	e9 43 01 00 00       	jmp    8007a4 <vprintfmt+0x3a0>
  800661:	89 df                	mov    %ebx,%edi
  800663:	8b 75 08             	mov    0x8(%ebp),%esi
  800666:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800669:	eb e7                	jmp    800652 <vprintfmt+0x24e>
	if (lflag >= 2)
  80066b:	83 f9 01             	cmp    $0x1,%ecx
  80066e:	7e 3f                	jle    8006af <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 50 04             	mov    0x4(%eax),%edx
  800676:	8b 00                	mov    (%eax),%eax
  800678:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 40 08             	lea    0x8(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800687:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80068b:	79 5c                	jns    8006e9 <vprintfmt+0x2e5>
				putch('-', putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	6a 2d                	push   $0x2d
  800693:	ff d6                	call   *%esi
				num = -(long long) num;
  800695:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800698:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80069b:	f7 da                	neg    %edx
  80069d:	83 d1 00             	adc    $0x0,%ecx
  8006a0:	f7 d9                	neg    %ecx
  8006a2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006aa:	e9 db 00 00 00       	jmp    80078a <vprintfmt+0x386>
	else if (lflag)
  8006af:	85 c9                	test   %ecx,%ecx
  8006b1:	75 1b                	jne    8006ce <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bb:	89 c1                	mov    %eax,%ecx
  8006bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8d 40 04             	lea    0x4(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cc:	eb b9                	jmp    800687 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d6:	89 c1                	mov    %eax,%ecx
  8006d8:	c1 f9 1f             	sar    $0x1f,%ecx
  8006db:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 40 04             	lea    0x4(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e7:	eb 9e                	jmp    800687 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006e9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ec:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f4:	e9 91 00 00 00       	jmp    80078a <vprintfmt+0x386>
	if (lflag >= 2)
  8006f9:	83 f9 01             	cmp    $0x1,%ecx
  8006fc:	7e 15                	jle    800713 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 10                	mov    (%eax),%edx
  800703:	8b 48 04             	mov    0x4(%eax),%ecx
  800706:	8d 40 08             	lea    0x8(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800711:	eb 77                	jmp    80078a <vprintfmt+0x386>
	else if (lflag)
  800713:	85 c9                	test   %ecx,%ecx
  800715:	75 17                	jne    80072e <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8b 10                	mov    (%eax),%edx
  80071c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800721:	8d 40 04             	lea    0x4(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800727:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072c:	eb 5c                	jmp    80078a <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 10                	mov    (%eax),%edx
  800733:	b9 00 00 00 00       	mov    $0x0,%ecx
  800738:	8d 40 04             	lea    0x4(%eax),%eax
  80073b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800743:	eb 45                	jmp    80078a <vprintfmt+0x386>
			putch('X', putdat);
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	53                   	push   %ebx
  800749:	6a 58                	push   $0x58
  80074b:	ff d6                	call   *%esi
			putch('X', putdat);
  80074d:	83 c4 08             	add    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	6a 58                	push   $0x58
  800753:	ff d6                	call   *%esi
			putch('X', putdat);
  800755:	83 c4 08             	add    $0x8,%esp
  800758:	53                   	push   %ebx
  800759:	6a 58                	push   $0x58
  80075b:	ff d6                	call   *%esi
			break;
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	eb 42                	jmp    8007a4 <vprintfmt+0x3a0>
			putch('0', putdat);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	53                   	push   %ebx
  800766:	6a 30                	push   $0x30
  800768:	ff d6                	call   *%esi
			putch('x', putdat);
  80076a:	83 c4 08             	add    $0x8,%esp
  80076d:	53                   	push   %ebx
  80076e:	6a 78                	push   $0x78
  800770:	ff d6                	call   *%esi
			num = (unsigned long long)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 10                	mov    (%eax),%edx
  800777:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80077c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80077f:	8d 40 04             	lea    0x4(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800785:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80078a:	83 ec 0c             	sub    $0xc,%esp
  80078d:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800791:	57                   	push   %edi
  800792:	ff 75 e0             	pushl  -0x20(%ebp)
  800795:	50                   	push   %eax
  800796:	51                   	push   %ecx
  800797:	52                   	push   %edx
  800798:	89 da                	mov    %ebx,%edx
  80079a:	89 f0                	mov    %esi,%eax
  80079c:	e8 7a fb ff ff       	call   80031b <printnum>
			break;
  8007a1:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a7:	83 c7 01             	add    $0x1,%edi
  8007aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ae:	83 f8 25             	cmp    $0x25,%eax
  8007b1:	0f 84 64 fc ff ff    	je     80041b <vprintfmt+0x17>
			if (ch == '\0')
  8007b7:	85 c0                	test   %eax,%eax
  8007b9:	0f 84 8b 00 00 00    	je     80084a <vprintfmt+0x446>
			putch(ch, putdat);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	50                   	push   %eax
  8007c4:	ff d6                	call   *%esi
  8007c6:	83 c4 10             	add    $0x10,%esp
  8007c9:	eb dc                	jmp    8007a7 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8007cb:	83 f9 01             	cmp    $0x1,%ecx
  8007ce:	7e 15                	jle    8007e5 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8b 10                	mov    (%eax),%edx
  8007d5:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d8:	8d 40 08             	lea    0x8(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007de:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e3:	eb a5                	jmp    80078a <vprintfmt+0x386>
	else if (lflag)
  8007e5:	85 c9                	test   %ecx,%ecx
  8007e7:	75 17                	jne    800800 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 10                	mov    (%eax),%edx
  8007ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f3:	8d 40 04             	lea    0x4(%eax),%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fe:	eb 8a                	jmp    80078a <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8b 10                	mov    (%eax),%edx
  800805:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080a:	8d 40 04             	lea    0x4(%eax),%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800810:	b8 10 00 00 00       	mov    $0x10,%eax
  800815:	e9 70 ff ff ff       	jmp    80078a <vprintfmt+0x386>
			putch(ch, putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	6a 25                	push   $0x25
  800820:	ff d6                	call   *%esi
			break;
  800822:	83 c4 10             	add    $0x10,%esp
  800825:	e9 7a ff ff ff       	jmp    8007a4 <vprintfmt+0x3a0>
			putch('%', putdat);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	53                   	push   %ebx
  80082e:	6a 25                	push   $0x25
  800830:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	89 f8                	mov    %edi,%eax
  800837:	eb 03                	jmp    80083c <vprintfmt+0x438>
  800839:	83 e8 01             	sub    $0x1,%eax
  80083c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800840:	75 f7                	jne    800839 <vprintfmt+0x435>
  800842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800845:	e9 5a ff ff ff       	jmp    8007a4 <vprintfmt+0x3a0>
}
  80084a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80084d:	5b                   	pop    %ebx
  80084e:	5e                   	pop    %esi
  80084f:	5f                   	pop    %edi
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	83 ec 18             	sub    $0x18,%esp
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80085e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800861:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800865:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800868:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80086f:	85 c0                	test   %eax,%eax
  800871:	74 26                	je     800899 <vsnprintf+0x47>
  800873:	85 d2                	test   %edx,%edx
  800875:	7e 22                	jle    800899 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800877:	ff 75 14             	pushl  0x14(%ebp)
  80087a:	ff 75 10             	pushl  0x10(%ebp)
  80087d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800880:	50                   	push   %eax
  800881:	68 ca 03 80 00       	push   $0x8003ca
  800886:	e8 79 fb ff ff       	call   800404 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80088b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800894:	83 c4 10             	add    $0x10,%esp
}
  800897:	c9                   	leave  
  800898:	c3                   	ret    
		return -E_INVAL;
  800899:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80089e:	eb f7                	jmp    800897 <vsnprintf+0x45>

008008a0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008a6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a9:	50                   	push   %eax
  8008aa:	ff 75 10             	pushl  0x10(%ebp)
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	ff 75 08             	pushl  0x8(%ebp)
  8008b3:	e8 9a ff ff ff       	call   800852 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c5:	eb 03                	jmp    8008ca <strlen+0x10>
		n++;
  8008c7:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008ca:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008ce:	75 f7                	jne    8008c7 <strlen+0xd>
	return n;
}
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e0:	eb 03                	jmp    8008e5 <strnlen+0x13>
		n++;
  8008e2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e5:	39 d0                	cmp    %edx,%eax
  8008e7:	74 06                	je     8008ef <strnlen+0x1d>
  8008e9:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008ed:	75 f3                	jne    8008e2 <strnlen+0x10>
	return n;
}
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	53                   	push   %ebx
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008fb:	89 c2                	mov    %eax,%edx
  8008fd:	83 c1 01             	add    $0x1,%ecx
  800900:	83 c2 01             	add    $0x1,%edx
  800903:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800907:	88 5a ff             	mov    %bl,-0x1(%edx)
  80090a:	84 db                	test   %bl,%bl
  80090c:	75 ef                	jne    8008fd <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80090e:	5b                   	pop    %ebx
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	53                   	push   %ebx
  800915:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800918:	53                   	push   %ebx
  800919:	e8 9c ff ff ff       	call   8008ba <strlen>
  80091e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800921:	ff 75 0c             	pushl  0xc(%ebp)
  800924:	01 d8                	add    %ebx,%eax
  800926:	50                   	push   %eax
  800927:	e8 c5 ff ff ff       	call   8008f1 <strcpy>
	return dst;
}
  80092c:	89 d8                	mov    %ebx,%eax
  80092e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	56                   	push   %esi
  800937:	53                   	push   %ebx
  800938:	8b 75 08             	mov    0x8(%ebp),%esi
  80093b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093e:	89 f3                	mov    %esi,%ebx
  800940:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800943:	89 f2                	mov    %esi,%edx
  800945:	eb 0f                	jmp    800956 <strncpy+0x23>
		*dst++ = *src;
  800947:	83 c2 01             	add    $0x1,%edx
  80094a:	0f b6 01             	movzbl (%ecx),%eax
  80094d:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800950:	80 39 01             	cmpb   $0x1,(%ecx)
  800953:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800956:	39 da                	cmp    %ebx,%edx
  800958:	75 ed                	jne    800947 <strncpy+0x14>
	}
	return ret;
}
  80095a:	89 f0                	mov    %esi,%eax
  80095c:	5b                   	pop    %ebx
  80095d:	5e                   	pop    %esi
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	56                   	push   %esi
  800964:	53                   	push   %ebx
  800965:	8b 75 08             	mov    0x8(%ebp),%esi
  800968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80096e:	89 f0                	mov    %esi,%eax
  800970:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800974:	85 c9                	test   %ecx,%ecx
  800976:	75 0b                	jne    800983 <strlcpy+0x23>
  800978:	eb 17                	jmp    800991 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80097a:	83 c2 01             	add    $0x1,%edx
  80097d:	83 c0 01             	add    $0x1,%eax
  800980:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800983:	39 d8                	cmp    %ebx,%eax
  800985:	74 07                	je     80098e <strlcpy+0x2e>
  800987:	0f b6 0a             	movzbl (%edx),%ecx
  80098a:	84 c9                	test   %cl,%cl
  80098c:	75 ec                	jne    80097a <strlcpy+0x1a>
		*dst = '\0';
  80098e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800991:	29 f0                	sub    %esi,%eax
}
  800993:	5b                   	pop    %ebx
  800994:	5e                   	pop    %esi
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a0:	eb 06                	jmp    8009a8 <strcmp+0x11>
		p++, q++;
  8009a2:	83 c1 01             	add    $0x1,%ecx
  8009a5:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009a8:	0f b6 01             	movzbl (%ecx),%eax
  8009ab:	84 c0                	test   %al,%al
  8009ad:	74 04                	je     8009b3 <strcmp+0x1c>
  8009af:	3a 02                	cmp    (%edx),%al
  8009b1:	74 ef                	je     8009a2 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b3:	0f b6 c0             	movzbl %al,%eax
  8009b6:	0f b6 12             	movzbl (%edx),%edx
  8009b9:	29 d0                	sub    %edx,%eax
}
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    

008009bd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	53                   	push   %ebx
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c7:	89 c3                	mov    %eax,%ebx
  8009c9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009cc:	eb 06                	jmp    8009d4 <strncmp+0x17>
		n--, p++, q++;
  8009ce:	83 c0 01             	add    $0x1,%eax
  8009d1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009d4:	39 d8                	cmp    %ebx,%eax
  8009d6:	74 16                	je     8009ee <strncmp+0x31>
  8009d8:	0f b6 08             	movzbl (%eax),%ecx
  8009db:	84 c9                	test   %cl,%cl
  8009dd:	74 04                	je     8009e3 <strncmp+0x26>
  8009df:	3a 0a                	cmp    (%edx),%cl
  8009e1:	74 eb                	je     8009ce <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e3:	0f b6 00             	movzbl (%eax),%eax
  8009e6:	0f b6 12             	movzbl (%edx),%edx
  8009e9:	29 d0                	sub    %edx,%eax
}
  8009eb:	5b                   	pop    %ebx
  8009ec:	5d                   	pop    %ebp
  8009ed:	c3                   	ret    
		return 0;
  8009ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f3:	eb f6                	jmp    8009eb <strncmp+0x2e>

008009f5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ff:	0f b6 10             	movzbl (%eax),%edx
  800a02:	84 d2                	test   %dl,%dl
  800a04:	74 09                	je     800a0f <strchr+0x1a>
		if (*s == c)
  800a06:	38 ca                	cmp    %cl,%dl
  800a08:	74 0a                	je     800a14 <strchr+0x1f>
	for (; *s; s++)
  800a0a:	83 c0 01             	add    $0x1,%eax
  800a0d:	eb f0                	jmp    8009ff <strchr+0xa>
			return (char *) s;
	return 0;
  800a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a20:	eb 03                	jmp    800a25 <strfind+0xf>
  800a22:	83 c0 01             	add    $0x1,%eax
  800a25:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a28:	38 ca                	cmp    %cl,%dl
  800a2a:	74 04                	je     800a30 <strfind+0x1a>
  800a2c:	84 d2                	test   %dl,%dl
  800a2e:	75 f2                	jne    800a22 <strfind+0xc>
			break;
	return (char *) s;
}
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	57                   	push   %edi
  800a36:	56                   	push   %esi
  800a37:	53                   	push   %ebx
  800a38:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a3e:	85 c9                	test   %ecx,%ecx
  800a40:	74 13                	je     800a55 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a42:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a48:	75 05                	jne    800a4f <memset+0x1d>
  800a4a:	f6 c1 03             	test   $0x3,%cl
  800a4d:	74 0d                	je     800a5c <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a52:	fc                   	cld    
  800a53:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a55:	89 f8                	mov    %edi,%eax
  800a57:	5b                   	pop    %ebx
  800a58:	5e                   	pop    %esi
  800a59:	5f                   	pop    %edi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    
		c &= 0xFF;
  800a5c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a60:	89 d3                	mov    %edx,%ebx
  800a62:	c1 e3 08             	shl    $0x8,%ebx
  800a65:	89 d0                	mov    %edx,%eax
  800a67:	c1 e0 18             	shl    $0x18,%eax
  800a6a:	89 d6                	mov    %edx,%esi
  800a6c:	c1 e6 10             	shl    $0x10,%esi
  800a6f:	09 f0                	or     %esi,%eax
  800a71:	09 c2                	or     %eax,%edx
  800a73:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a75:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a78:	89 d0                	mov    %edx,%eax
  800a7a:	fc                   	cld    
  800a7b:	f3 ab                	rep stos %eax,%es:(%edi)
  800a7d:	eb d6                	jmp    800a55 <memset+0x23>

00800a7f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	57                   	push   %edi
  800a83:	56                   	push   %esi
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a8d:	39 c6                	cmp    %eax,%esi
  800a8f:	73 35                	jae    800ac6 <memmove+0x47>
  800a91:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a94:	39 c2                	cmp    %eax,%edx
  800a96:	76 2e                	jbe    800ac6 <memmove+0x47>
		s += n;
		d += n;
  800a98:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9b:	89 d6                	mov    %edx,%esi
  800a9d:	09 fe                	or     %edi,%esi
  800a9f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aa5:	74 0c                	je     800ab3 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa7:	83 ef 01             	sub    $0x1,%edi
  800aaa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aad:	fd                   	std    
  800aae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab0:	fc                   	cld    
  800ab1:	eb 21                	jmp    800ad4 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab3:	f6 c1 03             	test   $0x3,%cl
  800ab6:	75 ef                	jne    800aa7 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab8:	83 ef 04             	sub    $0x4,%edi
  800abb:	8d 72 fc             	lea    -0x4(%edx),%esi
  800abe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ac1:	fd                   	std    
  800ac2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac4:	eb ea                	jmp    800ab0 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac6:	89 f2                	mov    %esi,%edx
  800ac8:	09 c2                	or     %eax,%edx
  800aca:	f6 c2 03             	test   $0x3,%dl
  800acd:	74 09                	je     800ad8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800acf:	89 c7                	mov    %eax,%edi
  800ad1:	fc                   	cld    
  800ad2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad4:	5e                   	pop    %esi
  800ad5:	5f                   	pop    %edi
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad8:	f6 c1 03             	test   $0x3,%cl
  800adb:	75 f2                	jne    800acf <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800add:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ae0:	89 c7                	mov    %eax,%edi
  800ae2:	fc                   	cld    
  800ae3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae5:	eb ed                	jmp    800ad4 <memmove+0x55>

00800ae7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800aea:	ff 75 10             	pushl  0x10(%ebp)
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	ff 75 08             	pushl  0x8(%ebp)
  800af3:	e8 87 ff ff ff       	call   800a7f <memmove>
}
  800af8:	c9                   	leave  
  800af9:	c3                   	ret    

00800afa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	89 c6                	mov    %eax,%esi
  800b07:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0a:	39 f0                	cmp    %esi,%eax
  800b0c:	74 1c                	je     800b2a <memcmp+0x30>
		if (*s1 != *s2)
  800b0e:	0f b6 08             	movzbl (%eax),%ecx
  800b11:	0f b6 1a             	movzbl (%edx),%ebx
  800b14:	38 d9                	cmp    %bl,%cl
  800b16:	75 08                	jne    800b20 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b18:	83 c0 01             	add    $0x1,%eax
  800b1b:	83 c2 01             	add    $0x1,%edx
  800b1e:	eb ea                	jmp    800b0a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b20:	0f b6 c1             	movzbl %cl,%eax
  800b23:	0f b6 db             	movzbl %bl,%ebx
  800b26:	29 d8                	sub    %ebx,%eax
  800b28:	eb 05                	jmp    800b2f <memcmp+0x35>
	}

	return 0;
  800b2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b3c:	89 c2                	mov    %eax,%edx
  800b3e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b41:	39 d0                	cmp    %edx,%eax
  800b43:	73 09                	jae    800b4e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b45:	38 08                	cmp    %cl,(%eax)
  800b47:	74 05                	je     800b4e <memfind+0x1b>
	for (; s < ends; s++)
  800b49:	83 c0 01             	add    $0x1,%eax
  800b4c:	eb f3                	jmp    800b41 <memfind+0xe>
			break;
	return (void *) s;
}
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	57                   	push   %edi
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5c:	eb 03                	jmp    800b61 <strtol+0x11>
		s++;
  800b5e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b61:	0f b6 01             	movzbl (%ecx),%eax
  800b64:	3c 20                	cmp    $0x20,%al
  800b66:	74 f6                	je     800b5e <strtol+0xe>
  800b68:	3c 09                	cmp    $0x9,%al
  800b6a:	74 f2                	je     800b5e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b6c:	3c 2b                	cmp    $0x2b,%al
  800b6e:	74 2e                	je     800b9e <strtol+0x4e>
	int neg = 0;
  800b70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b75:	3c 2d                	cmp    $0x2d,%al
  800b77:	74 2f                	je     800ba8 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b79:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b7f:	75 05                	jne    800b86 <strtol+0x36>
  800b81:	80 39 30             	cmpb   $0x30,(%ecx)
  800b84:	74 2c                	je     800bb2 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b86:	85 db                	test   %ebx,%ebx
  800b88:	75 0a                	jne    800b94 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b8a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b8f:	80 39 30             	cmpb   $0x30,(%ecx)
  800b92:	74 28                	je     800bbc <strtol+0x6c>
		base = 10;
  800b94:	b8 00 00 00 00       	mov    $0x0,%eax
  800b99:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b9c:	eb 50                	jmp    800bee <strtol+0x9e>
		s++;
  800b9e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba6:	eb d1                	jmp    800b79 <strtol+0x29>
		s++, neg = 1;
  800ba8:	83 c1 01             	add    $0x1,%ecx
  800bab:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb0:	eb c7                	jmp    800b79 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb6:	74 0e                	je     800bc6 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bb8:	85 db                	test   %ebx,%ebx
  800bba:	75 d8                	jne    800b94 <strtol+0x44>
		s++, base = 8;
  800bbc:	83 c1 01             	add    $0x1,%ecx
  800bbf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc4:	eb ce                	jmp    800b94 <strtol+0x44>
		s += 2, base = 16;
  800bc6:	83 c1 02             	add    $0x2,%ecx
  800bc9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bce:	eb c4                	jmp    800b94 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bd0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bd3:	89 f3                	mov    %esi,%ebx
  800bd5:	80 fb 19             	cmp    $0x19,%bl
  800bd8:	77 29                	ja     800c03 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bda:	0f be d2             	movsbl %dl,%edx
  800bdd:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800be3:	7d 30                	jge    800c15 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800be5:	83 c1 01             	add    $0x1,%ecx
  800be8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bec:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bee:	0f b6 11             	movzbl (%ecx),%edx
  800bf1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bf4:	89 f3                	mov    %esi,%ebx
  800bf6:	80 fb 09             	cmp    $0x9,%bl
  800bf9:	77 d5                	ja     800bd0 <strtol+0x80>
			dig = *s - '0';
  800bfb:	0f be d2             	movsbl %dl,%edx
  800bfe:	83 ea 30             	sub    $0x30,%edx
  800c01:	eb dd                	jmp    800be0 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c03:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c06:	89 f3                	mov    %esi,%ebx
  800c08:	80 fb 19             	cmp    $0x19,%bl
  800c0b:	77 08                	ja     800c15 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c0d:	0f be d2             	movsbl %dl,%edx
  800c10:	83 ea 37             	sub    $0x37,%edx
  800c13:	eb cb                	jmp    800be0 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c19:	74 05                	je     800c20 <strtol+0xd0>
		*endptr = (char *) s;
  800c1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c1e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c20:	89 c2                	mov    %eax,%edx
  800c22:	f7 da                	neg    %edx
  800c24:	85 ff                	test   %edi,%edi
  800c26:	0f 45 c2             	cmovne %edx,%eax
}
  800c29:	5b                   	pop    %ebx
  800c2a:	5e                   	pop    %esi
  800c2b:	5f                   	pop    %edi
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	57                   	push   %edi
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c34:	b8 00 00 00 00       	mov    $0x0,%eax
  800c39:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3f:	89 c3                	mov    %eax,%ebx
  800c41:	89 c7                	mov    %eax,%edi
  800c43:	89 c6                	mov    %eax,%esi
  800c45:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5f                   	pop    %edi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	57                   	push   %edi
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c52:	ba 00 00 00 00       	mov    $0x0,%edx
  800c57:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5c:	89 d1                	mov    %edx,%ecx
  800c5e:	89 d3                	mov    %edx,%ebx
  800c60:	89 d7                	mov    %edx,%edi
  800c62:	89 d6                	mov    %edx,%esi
  800c64:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c66:	5b                   	pop    %ebx
  800c67:	5e                   	pop    %esi
  800c68:	5f                   	pop    %edi
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	57                   	push   %edi
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
  800c71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c74:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c79:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c81:	89 cb                	mov    %ecx,%ebx
  800c83:	89 cf                	mov    %ecx,%edi
  800c85:	89 ce                	mov    %ecx,%esi
  800c87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	7f 08                	jg     800c95 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	50                   	push   %eax
  800c99:	6a 03                	push   $0x3
  800c9b:	68 ff 25 80 00       	push   $0x8025ff
  800ca0:	6a 23                	push   $0x23
  800ca2:	68 1c 26 80 00       	push   $0x80261c
  800ca7:	e8 80 f5 ff ff       	call   80022c <_panic>

00800cac <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	57                   	push   %edi
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb7:	b8 02 00 00 00       	mov    $0x2,%eax
  800cbc:	89 d1                	mov    %edx,%ecx
  800cbe:	89 d3                	mov    %edx,%ebx
  800cc0:	89 d7                	mov    %edx,%edi
  800cc2:	89 d6                	mov    %edx,%esi
  800cc4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc6:	5b                   	pop    %ebx
  800cc7:	5e                   	pop    %esi
  800cc8:	5f                   	pop    %edi
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <sys_yield>:

void
sys_yield(void)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	57                   	push   %edi
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cdb:	89 d1                	mov    %edx,%ecx
  800cdd:	89 d3                	mov    %edx,%ebx
  800cdf:	89 d7                	mov    %edx,%edi
  800ce1:	89 d6                	mov    %edx,%esi
  800ce3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
  800cf0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf3:	be 00 00 00 00       	mov    $0x0,%esi
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfe:	b8 04 00 00 00       	mov    $0x4,%eax
  800d03:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d06:	89 f7                	mov    %esi,%edi
  800d08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0a:	85 c0                	test   %eax,%eax
  800d0c:	7f 08                	jg     800d16 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d16:	83 ec 0c             	sub    $0xc,%esp
  800d19:	50                   	push   %eax
  800d1a:	6a 04                	push   $0x4
  800d1c:	68 ff 25 80 00       	push   $0x8025ff
  800d21:	6a 23                	push   $0x23
  800d23:	68 1c 26 80 00       	push   $0x80261c
  800d28:	e8 ff f4 ff ff       	call   80022c <_panic>

00800d2d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
  800d33:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3c:	b8 05 00 00 00       	mov    $0x5,%eax
  800d41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d44:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d47:	8b 75 18             	mov    0x18(%ebp),%esi
  800d4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	7f 08                	jg     800d58 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d53:	5b                   	pop    %ebx
  800d54:	5e                   	pop    %esi
  800d55:	5f                   	pop    %edi
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d58:	83 ec 0c             	sub    $0xc,%esp
  800d5b:	50                   	push   %eax
  800d5c:	6a 05                	push   $0x5
  800d5e:	68 ff 25 80 00       	push   $0x8025ff
  800d63:	6a 23                	push   $0x23
  800d65:	68 1c 26 80 00       	push   $0x80261c
  800d6a:	e8 bd f4 ff ff       	call   80022c <_panic>

00800d6f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	57                   	push   %edi
  800d73:	56                   	push   %esi
  800d74:	53                   	push   %ebx
  800d75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d83:	b8 06 00 00 00       	mov    $0x6,%eax
  800d88:	89 df                	mov    %ebx,%edi
  800d8a:	89 de                	mov    %ebx,%esi
  800d8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	7f 08                	jg     800d9a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9a:	83 ec 0c             	sub    $0xc,%esp
  800d9d:	50                   	push   %eax
  800d9e:	6a 06                	push   $0x6
  800da0:	68 ff 25 80 00       	push   $0x8025ff
  800da5:	6a 23                	push   $0x23
  800da7:	68 1c 26 80 00       	push   $0x80261c
  800dac:	e8 7b f4 ff ff       	call   80022c <_panic>

00800db1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc5:	b8 08 00 00 00       	mov    $0x8,%eax
  800dca:	89 df                	mov    %ebx,%edi
  800dcc:	89 de                	mov    %ebx,%esi
  800dce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	7f 08                	jg     800ddc <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	50                   	push   %eax
  800de0:	6a 08                	push   $0x8
  800de2:	68 ff 25 80 00       	push   $0x8025ff
  800de7:	6a 23                	push   $0x23
  800de9:	68 1c 26 80 00       	push   $0x80261c
  800dee:	e8 39 f4 ff ff       	call   80022c <_panic>

00800df3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e07:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0c:	89 df                	mov    %ebx,%edi
  800e0e:	89 de                	mov    %ebx,%esi
  800e10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e12:	85 c0                	test   %eax,%eax
  800e14:	7f 08                	jg     800e1e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e19:	5b                   	pop    %ebx
  800e1a:	5e                   	pop    %esi
  800e1b:	5f                   	pop    %edi
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1e:	83 ec 0c             	sub    $0xc,%esp
  800e21:	50                   	push   %eax
  800e22:	6a 09                	push   $0x9
  800e24:	68 ff 25 80 00       	push   $0x8025ff
  800e29:	6a 23                	push   $0x23
  800e2b:	68 1c 26 80 00       	push   $0x80261c
  800e30:	e8 f7 f3 ff ff       	call   80022c <_panic>

00800e35 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	57                   	push   %edi
  800e39:	56                   	push   %esi
  800e3a:	53                   	push   %ebx
  800e3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e43:	8b 55 08             	mov    0x8(%ebp),%edx
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4e:	89 df                	mov    %ebx,%edi
  800e50:	89 de                	mov    %ebx,%esi
  800e52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e54:	85 c0                	test   %eax,%eax
  800e56:	7f 08                	jg     800e60 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5b:	5b                   	pop    %ebx
  800e5c:	5e                   	pop    %esi
  800e5d:	5f                   	pop    %edi
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e60:	83 ec 0c             	sub    $0xc,%esp
  800e63:	50                   	push   %eax
  800e64:	6a 0a                	push   $0xa
  800e66:	68 ff 25 80 00       	push   $0x8025ff
  800e6b:	6a 23                	push   $0x23
  800e6d:	68 1c 26 80 00       	push   $0x80261c
  800e72:	e8 b5 f3 ff ff       	call   80022c <_panic>

00800e77 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	57                   	push   %edi
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e83:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e88:	be 00 00 00 00       	mov    $0x0,%esi
  800e8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e90:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e93:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    

00800e9a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
  800ea0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eab:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb0:	89 cb                	mov    %ecx,%ebx
  800eb2:	89 cf                	mov    %ecx,%edi
  800eb4:	89 ce                	mov    %ecx,%esi
  800eb6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	7f 08                	jg     800ec4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebf:	5b                   	pop    %ebx
  800ec0:	5e                   	pop    %esi
  800ec1:	5f                   	pop    %edi
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec4:	83 ec 0c             	sub    $0xc,%esp
  800ec7:	50                   	push   %eax
  800ec8:	6a 0d                	push   $0xd
  800eca:	68 ff 25 80 00       	push   $0x8025ff
  800ecf:	6a 23                	push   $0x23
  800ed1:	68 1c 26 80 00       	push   $0x80261c
  800ed6:	e8 51 f3 ff ff       	call   80022c <_panic>

00800edb <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800ee1:	68 2a 26 80 00       	push   $0x80262a
  800ee6:	6a 25                	push   $0x25
  800ee8:	68 42 26 80 00       	push   $0x802642
  800eed:	e8 3a f3 ff ff       	call   80022c <_panic>

00800ef2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	57                   	push   %edi
  800ef6:	56                   	push   %esi
  800ef7:	53                   	push   %ebx
  800ef8:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800efb:	68 db 0e 80 00       	push   $0x800edb
  800f00:	e8 19 0f 00 00       	call   801e1e <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f05:	b8 07 00 00 00       	mov    $0x7,%eax
  800f0a:	cd 30                	int    $0x30
  800f0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800f12:	83 c4 10             	add    $0x10,%esp
  800f15:	85 c0                	test   %eax,%eax
  800f17:	78 27                	js     800f40 <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800f19:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800f1e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f22:	75 65                	jne    800f89 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f24:	e8 83 fd ff ff       	call   800cac <sys_getenvid>
  800f29:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f2e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f31:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f36:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  800f3b:	e9 11 01 00 00       	jmp    801051 <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800f40:	50                   	push   %eax
  800f41:	68 d2 21 80 00       	push   $0x8021d2
  800f46:	6a 6f                	push   $0x6f
  800f48:	68 42 26 80 00       	push   $0x802642
  800f4d:	e8 da f2 ff ff       	call   80022c <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800f52:	e8 55 fd ff ff       	call   800cac <sys_getenvid>
  800f57:	83 ec 0c             	sub    $0xc,%esp
  800f5a:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800f60:	56                   	push   %esi
  800f61:	57                   	push   %edi
  800f62:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f65:	57                   	push   %edi
  800f66:	50                   	push   %eax
  800f67:	e8 c1 fd ff ff       	call   800d2d <sys_page_map>
  800f6c:	83 c4 20             	add    $0x20,%esp
  800f6f:	85 c0                	test   %eax,%eax
  800f71:	0f 88 84 00 00 00    	js     800ffb <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800f77:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f7d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800f83:	0f 84 84 00 00 00    	je     80100d <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800f89:	89 d8                	mov    %ebx,%eax
  800f8b:	c1 e8 16             	shr    $0x16,%eax
  800f8e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f95:	a8 01                	test   $0x1,%al
  800f97:	74 de                	je     800f77 <fork+0x85>
  800f99:	89 d8                	mov    %ebx,%eax
  800f9b:	c1 e8 0c             	shr    $0xc,%eax
  800f9e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fa5:	f6 c2 01             	test   $0x1,%dl
  800fa8:	74 cd                	je     800f77 <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  800faa:	89 c7                	mov    %eax,%edi
  800fac:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  800faf:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  800fb6:	f7 c6 00 04 00 00    	test   $0x400,%esi
  800fbc:	75 94                	jne    800f52 <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  800fbe:	f7 c6 02 08 00 00    	test   $0x802,%esi
  800fc4:	0f 85 d1 00 00 00    	jne    80109b <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800fca:	a1 20 44 80 00       	mov    0x804420,%eax
  800fcf:	8b 40 48             	mov    0x48(%eax),%eax
  800fd2:	83 ec 0c             	sub    $0xc,%esp
  800fd5:	6a 05                	push   $0x5
  800fd7:	57                   	push   %edi
  800fd8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fdb:	57                   	push   %edi
  800fdc:	50                   	push   %eax
  800fdd:	e8 4b fd ff ff       	call   800d2d <sys_page_map>
  800fe2:	83 c4 20             	add    $0x20,%esp
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	79 8e                	jns    800f77 <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  800fe9:	50                   	push   %eax
  800fea:	68 9c 26 80 00       	push   $0x80269c
  800fef:	6a 4a                	push   $0x4a
  800ff1:	68 42 26 80 00       	push   $0x802642
  800ff6:	e8 31 f2 ff ff       	call   80022c <_panic>
                        panic("duppage: page mapping failed %e", r);
  800ffb:	50                   	push   %eax
  800ffc:	68 7c 26 80 00       	push   $0x80267c
  801001:	6a 41                	push   $0x41
  801003:	68 42 26 80 00       	push   $0x802642
  801008:	e8 1f f2 ff ff       	call   80022c <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  80100d:	83 ec 04             	sub    $0x4,%esp
  801010:	6a 07                	push   $0x7
  801012:	68 00 f0 bf ee       	push   $0xeebff000
  801017:	ff 75 e0             	pushl  -0x20(%ebp)
  80101a:	e8 cb fc ff ff       	call   800cea <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  80101f:	83 c4 10             	add    $0x10,%esp
  801022:	85 c0                	test   %eax,%eax
  801024:	78 36                	js     80105c <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	68 92 1e 80 00       	push   $0x801e92
  80102e:	ff 75 e0             	pushl  -0x20(%ebp)
  801031:	e8 ff fd ff ff       	call   800e35 <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	85 c0                	test   %eax,%eax
  80103b:	78 34                	js     801071 <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  80103d:	83 ec 08             	sub    $0x8,%esp
  801040:	6a 02                	push   $0x2
  801042:	ff 75 e0             	pushl  -0x20(%ebp)
  801045:	e8 67 fd ff ff       	call   800db1 <sys_env_set_status>
  80104a:	83 c4 10             	add    $0x10,%esp
  80104d:	85 c0                	test   %eax,%eax
  80104f:	78 35                	js     801086 <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  801051:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801054:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801057:	5b                   	pop    %ebx
  801058:	5e                   	pop    %esi
  801059:	5f                   	pop    %edi
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  80105c:	50                   	push   %eax
  80105d:	68 d2 21 80 00       	push   $0x8021d2
  801062:	68 82 00 00 00       	push   $0x82
  801067:	68 42 26 80 00       	push   $0x802642
  80106c:	e8 bb f1 ff ff       	call   80022c <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801071:	50                   	push   %eax
  801072:	68 c0 26 80 00       	push   $0x8026c0
  801077:	68 87 00 00 00       	push   $0x87
  80107c:	68 42 26 80 00       	push   $0x802642
  801081:	e8 a6 f1 ff ff       	call   80022c <_panic>
        	panic("sys_env_set_status: %e", r);
  801086:	50                   	push   %eax
  801087:	68 4d 26 80 00       	push   $0x80264d
  80108c:	68 8b 00 00 00       	push   $0x8b
  801091:	68 42 26 80 00       	push   $0x802642
  801096:	e8 91 f1 ff ff       	call   80022c <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  80109b:	a1 20 44 80 00       	mov    0x804420,%eax
  8010a0:	8b 40 48             	mov    0x48(%eax),%eax
  8010a3:	83 ec 0c             	sub    $0xc,%esp
  8010a6:	68 05 08 00 00       	push   $0x805
  8010ab:	57                   	push   %edi
  8010ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010af:	57                   	push   %edi
  8010b0:	50                   	push   %eax
  8010b1:	e8 77 fc ff ff       	call   800d2d <sys_page_map>
  8010b6:	83 c4 20             	add    $0x20,%esp
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	0f 88 28 ff ff ff    	js     800fe9 <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  8010c1:	a1 20 44 80 00       	mov    0x804420,%eax
  8010c6:	8b 50 48             	mov    0x48(%eax),%edx
  8010c9:	8b 40 48             	mov    0x48(%eax),%eax
  8010cc:	83 ec 0c             	sub    $0xc,%esp
  8010cf:	68 05 08 00 00       	push   $0x805
  8010d4:	57                   	push   %edi
  8010d5:	52                   	push   %edx
  8010d6:	57                   	push   %edi
  8010d7:	50                   	push   %eax
  8010d8:	e8 50 fc ff ff       	call   800d2d <sys_page_map>
  8010dd:	83 c4 20             	add    $0x20,%esp
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	0f 89 8f fe ff ff    	jns    800f77 <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  8010e8:	50                   	push   %eax
  8010e9:	68 9c 26 80 00       	push   $0x80269c
  8010ee:	6a 4f                	push   $0x4f
  8010f0:	68 42 26 80 00       	push   $0x802642
  8010f5:	e8 32 f1 ff ff       	call   80022c <_panic>

008010fa <sfork>:

// Challenge!
int
sfork(void)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801100:	68 64 26 80 00       	push   $0x802664
  801105:	68 94 00 00 00       	push   $0x94
  80110a:	68 42 26 80 00       	push   $0x802642
  80110f:	e8 18 f1 ff ff       	call   80022c <_panic>

00801114 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	05 00 00 00 30       	add    $0x30000000,%eax
  80111f:	c1 e8 0c             	shr    $0xc,%eax
}
  801122:	5d                   	pop    %ebp
  801123:	c3                   	ret    

00801124 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80112f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801134:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    

0080113b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801141:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801146:	89 c2                	mov    %eax,%edx
  801148:	c1 ea 16             	shr    $0x16,%edx
  80114b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801152:	f6 c2 01             	test   $0x1,%dl
  801155:	74 2a                	je     801181 <fd_alloc+0x46>
  801157:	89 c2                	mov    %eax,%edx
  801159:	c1 ea 0c             	shr    $0xc,%edx
  80115c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801163:	f6 c2 01             	test   $0x1,%dl
  801166:	74 19                	je     801181 <fd_alloc+0x46>
  801168:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80116d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801172:	75 d2                	jne    801146 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801174:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80117a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80117f:	eb 07                	jmp    801188 <fd_alloc+0x4d>
			*fd_store = fd;
  801181:	89 01                	mov    %eax,(%ecx)
			return 0;
  801183:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    

0080118a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801190:	83 f8 1f             	cmp    $0x1f,%eax
  801193:	77 36                	ja     8011cb <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801195:	c1 e0 0c             	shl    $0xc,%eax
  801198:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80119d:	89 c2                	mov    %eax,%edx
  80119f:	c1 ea 16             	shr    $0x16,%edx
  8011a2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011a9:	f6 c2 01             	test   $0x1,%dl
  8011ac:	74 24                	je     8011d2 <fd_lookup+0x48>
  8011ae:	89 c2                	mov    %eax,%edx
  8011b0:	c1 ea 0c             	shr    $0xc,%edx
  8011b3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011ba:	f6 c2 01             	test   $0x1,%dl
  8011bd:	74 1a                	je     8011d9 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c2:	89 02                	mov    %eax,(%edx)
	return 0;
  8011c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c9:	5d                   	pop    %ebp
  8011ca:	c3                   	ret    
		return -E_INVAL;
  8011cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d0:	eb f7                	jmp    8011c9 <fd_lookup+0x3f>
		return -E_INVAL;
  8011d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d7:	eb f0                	jmp    8011c9 <fd_lookup+0x3f>
  8011d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011de:	eb e9                	jmp    8011c9 <fd_lookup+0x3f>

008011e0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 08             	sub    $0x8,%esp
  8011e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e9:	ba 64 27 80 00       	mov    $0x802764,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011ee:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011f3:	39 08                	cmp    %ecx,(%eax)
  8011f5:	74 33                	je     80122a <dev_lookup+0x4a>
  8011f7:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8011fa:	8b 02                	mov    (%edx),%eax
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	75 f3                	jne    8011f3 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801200:	a1 20 44 80 00       	mov    0x804420,%eax
  801205:	8b 40 48             	mov    0x48(%eax),%eax
  801208:	83 ec 04             	sub    $0x4,%esp
  80120b:	51                   	push   %ecx
  80120c:	50                   	push   %eax
  80120d:	68 e4 26 80 00       	push   $0x8026e4
  801212:	e8 f0 f0 ff ff       	call   800307 <cprintf>
	*dev = 0;
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    
			*dev = devtab[i];
  80122a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80122f:	b8 00 00 00 00       	mov    $0x0,%eax
  801234:	eb f2                	jmp    801228 <dev_lookup+0x48>

00801236 <fd_close>:
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	57                   	push   %edi
  80123a:	56                   	push   %esi
  80123b:	53                   	push   %ebx
  80123c:	83 ec 1c             	sub    $0x1c,%esp
  80123f:	8b 75 08             	mov    0x8(%ebp),%esi
  801242:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801245:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801248:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801249:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80124f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801252:	50                   	push   %eax
  801253:	e8 32 ff ff ff       	call   80118a <fd_lookup>
  801258:	89 c3                	mov    %eax,%ebx
  80125a:	83 c4 08             	add    $0x8,%esp
  80125d:	85 c0                	test   %eax,%eax
  80125f:	78 05                	js     801266 <fd_close+0x30>
	    || fd != fd2)
  801261:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801264:	74 16                	je     80127c <fd_close+0x46>
		return (must_exist ? r : 0);
  801266:	89 f8                	mov    %edi,%eax
  801268:	84 c0                	test   %al,%al
  80126a:	b8 00 00 00 00       	mov    $0x0,%eax
  80126f:	0f 44 d8             	cmove  %eax,%ebx
}
  801272:	89 d8                	mov    %ebx,%eax
  801274:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801277:	5b                   	pop    %ebx
  801278:	5e                   	pop    %esi
  801279:	5f                   	pop    %edi
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80127c:	83 ec 08             	sub    $0x8,%esp
  80127f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801282:	50                   	push   %eax
  801283:	ff 36                	pushl  (%esi)
  801285:	e8 56 ff ff ff       	call   8011e0 <dev_lookup>
  80128a:	89 c3                	mov    %eax,%ebx
  80128c:	83 c4 10             	add    $0x10,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	78 15                	js     8012a8 <fd_close+0x72>
		if (dev->dev_close)
  801293:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801296:	8b 40 10             	mov    0x10(%eax),%eax
  801299:	85 c0                	test   %eax,%eax
  80129b:	74 1b                	je     8012b8 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80129d:	83 ec 0c             	sub    $0xc,%esp
  8012a0:	56                   	push   %esi
  8012a1:	ff d0                	call   *%eax
  8012a3:	89 c3                	mov    %eax,%ebx
  8012a5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012a8:	83 ec 08             	sub    $0x8,%esp
  8012ab:	56                   	push   %esi
  8012ac:	6a 00                	push   $0x0
  8012ae:	e8 bc fa ff ff       	call   800d6f <sys_page_unmap>
	return r;
  8012b3:	83 c4 10             	add    $0x10,%esp
  8012b6:	eb ba                	jmp    801272 <fd_close+0x3c>
			r = 0;
  8012b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012bd:	eb e9                	jmp    8012a8 <fd_close+0x72>

008012bf <close>:

int
close(int fdnum)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c8:	50                   	push   %eax
  8012c9:	ff 75 08             	pushl  0x8(%ebp)
  8012cc:	e8 b9 fe ff ff       	call   80118a <fd_lookup>
  8012d1:	83 c4 08             	add    $0x8,%esp
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	78 10                	js     8012e8 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8012d8:	83 ec 08             	sub    $0x8,%esp
  8012db:	6a 01                	push   $0x1
  8012dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e0:	e8 51 ff ff ff       	call   801236 <fd_close>
  8012e5:	83 c4 10             	add    $0x10,%esp
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <close_all>:

void
close_all(void)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012f6:	83 ec 0c             	sub    $0xc,%esp
  8012f9:	53                   	push   %ebx
  8012fa:	e8 c0 ff ff ff       	call   8012bf <close>
	for (i = 0; i < MAXFD; i++)
  8012ff:	83 c3 01             	add    $0x1,%ebx
  801302:	83 c4 10             	add    $0x10,%esp
  801305:	83 fb 20             	cmp    $0x20,%ebx
  801308:	75 ec                	jne    8012f6 <close_all+0xc>
}
  80130a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	57                   	push   %edi
  801313:	56                   	push   %esi
  801314:	53                   	push   %ebx
  801315:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801318:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80131b:	50                   	push   %eax
  80131c:	ff 75 08             	pushl  0x8(%ebp)
  80131f:	e8 66 fe ff ff       	call   80118a <fd_lookup>
  801324:	89 c3                	mov    %eax,%ebx
  801326:	83 c4 08             	add    $0x8,%esp
  801329:	85 c0                	test   %eax,%eax
  80132b:	0f 88 81 00 00 00    	js     8013b2 <dup+0xa3>
		return r;
	close(newfdnum);
  801331:	83 ec 0c             	sub    $0xc,%esp
  801334:	ff 75 0c             	pushl  0xc(%ebp)
  801337:	e8 83 ff ff ff       	call   8012bf <close>

	newfd = INDEX2FD(newfdnum);
  80133c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80133f:	c1 e6 0c             	shl    $0xc,%esi
  801342:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801348:	83 c4 04             	add    $0x4,%esp
  80134b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80134e:	e8 d1 fd ff ff       	call   801124 <fd2data>
  801353:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801355:	89 34 24             	mov    %esi,(%esp)
  801358:	e8 c7 fd ff ff       	call   801124 <fd2data>
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801362:	89 d8                	mov    %ebx,%eax
  801364:	c1 e8 16             	shr    $0x16,%eax
  801367:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80136e:	a8 01                	test   $0x1,%al
  801370:	74 11                	je     801383 <dup+0x74>
  801372:	89 d8                	mov    %ebx,%eax
  801374:	c1 e8 0c             	shr    $0xc,%eax
  801377:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80137e:	f6 c2 01             	test   $0x1,%dl
  801381:	75 39                	jne    8013bc <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801383:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801386:	89 d0                	mov    %edx,%eax
  801388:	c1 e8 0c             	shr    $0xc,%eax
  80138b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801392:	83 ec 0c             	sub    $0xc,%esp
  801395:	25 07 0e 00 00       	and    $0xe07,%eax
  80139a:	50                   	push   %eax
  80139b:	56                   	push   %esi
  80139c:	6a 00                	push   $0x0
  80139e:	52                   	push   %edx
  80139f:	6a 00                	push   $0x0
  8013a1:	e8 87 f9 ff ff       	call   800d2d <sys_page_map>
  8013a6:	89 c3                	mov    %eax,%ebx
  8013a8:	83 c4 20             	add    $0x20,%esp
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	78 31                	js     8013e0 <dup+0xd1>
		goto err;

	return newfdnum;
  8013af:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013b2:	89 d8                	mov    %ebx,%eax
  8013b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b7:	5b                   	pop    %ebx
  8013b8:	5e                   	pop    %esi
  8013b9:	5f                   	pop    %edi
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013bc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	25 07 0e 00 00       	and    $0xe07,%eax
  8013cb:	50                   	push   %eax
  8013cc:	57                   	push   %edi
  8013cd:	6a 00                	push   $0x0
  8013cf:	53                   	push   %ebx
  8013d0:	6a 00                	push   $0x0
  8013d2:	e8 56 f9 ff ff       	call   800d2d <sys_page_map>
  8013d7:	89 c3                	mov    %eax,%ebx
  8013d9:	83 c4 20             	add    $0x20,%esp
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	79 a3                	jns    801383 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	56                   	push   %esi
  8013e4:	6a 00                	push   $0x0
  8013e6:	e8 84 f9 ff ff       	call   800d6f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013eb:	83 c4 08             	add    $0x8,%esp
  8013ee:	57                   	push   %edi
  8013ef:	6a 00                	push   $0x0
  8013f1:	e8 79 f9 ff ff       	call   800d6f <sys_page_unmap>
	return r;
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	eb b7                	jmp    8013b2 <dup+0xa3>

008013fb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	53                   	push   %ebx
  8013ff:	83 ec 14             	sub    $0x14,%esp
  801402:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801405:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801408:	50                   	push   %eax
  801409:	53                   	push   %ebx
  80140a:	e8 7b fd ff ff       	call   80118a <fd_lookup>
  80140f:	83 c4 08             	add    $0x8,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	78 3f                	js     801455 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141c:	50                   	push   %eax
  80141d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801420:	ff 30                	pushl  (%eax)
  801422:	e8 b9 fd ff ff       	call   8011e0 <dev_lookup>
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	85 c0                	test   %eax,%eax
  80142c:	78 27                	js     801455 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80142e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801431:	8b 42 08             	mov    0x8(%edx),%eax
  801434:	83 e0 03             	and    $0x3,%eax
  801437:	83 f8 01             	cmp    $0x1,%eax
  80143a:	74 1e                	je     80145a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80143c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143f:	8b 40 08             	mov    0x8(%eax),%eax
  801442:	85 c0                	test   %eax,%eax
  801444:	74 35                	je     80147b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	ff 75 10             	pushl  0x10(%ebp)
  80144c:	ff 75 0c             	pushl  0xc(%ebp)
  80144f:	52                   	push   %edx
  801450:	ff d0                	call   *%eax
  801452:	83 c4 10             	add    $0x10,%esp
}
  801455:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801458:	c9                   	leave  
  801459:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80145a:	a1 20 44 80 00       	mov    0x804420,%eax
  80145f:	8b 40 48             	mov    0x48(%eax),%eax
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	53                   	push   %ebx
  801466:	50                   	push   %eax
  801467:	68 28 27 80 00       	push   $0x802728
  80146c:	e8 96 ee ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801479:	eb da                	jmp    801455 <read+0x5a>
		return -E_NOT_SUPP;
  80147b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801480:	eb d3                	jmp    801455 <read+0x5a>

00801482 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	57                   	push   %edi
  801486:	56                   	push   %esi
  801487:	53                   	push   %ebx
  801488:	83 ec 0c             	sub    $0xc,%esp
  80148b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80148e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801491:	bb 00 00 00 00       	mov    $0x0,%ebx
  801496:	39 f3                	cmp    %esi,%ebx
  801498:	73 25                	jae    8014bf <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	89 f0                	mov    %esi,%eax
  80149f:	29 d8                	sub    %ebx,%eax
  8014a1:	50                   	push   %eax
  8014a2:	89 d8                	mov    %ebx,%eax
  8014a4:	03 45 0c             	add    0xc(%ebp),%eax
  8014a7:	50                   	push   %eax
  8014a8:	57                   	push   %edi
  8014a9:	e8 4d ff ff ff       	call   8013fb <read>
		if (m < 0)
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	78 08                	js     8014bd <readn+0x3b>
			return m;
		if (m == 0)
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	74 06                	je     8014bf <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8014b9:	01 c3                	add    %eax,%ebx
  8014bb:	eb d9                	jmp    801496 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014bd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014bf:	89 d8                	mov    %ebx,%eax
  8014c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c4:	5b                   	pop    %ebx
  8014c5:	5e                   	pop    %esi
  8014c6:	5f                   	pop    %edi
  8014c7:	5d                   	pop    %ebp
  8014c8:	c3                   	ret    

008014c9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	53                   	push   %ebx
  8014cd:	83 ec 14             	sub    $0x14,%esp
  8014d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d6:	50                   	push   %eax
  8014d7:	53                   	push   %ebx
  8014d8:	e8 ad fc ff ff       	call   80118a <fd_lookup>
  8014dd:	83 c4 08             	add    $0x8,%esp
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	78 3a                	js     80151e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e4:	83 ec 08             	sub    $0x8,%esp
  8014e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ea:	50                   	push   %eax
  8014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ee:	ff 30                	pushl  (%eax)
  8014f0:	e8 eb fc ff ff       	call   8011e0 <dev_lookup>
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	78 22                	js     80151e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ff:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801503:	74 1e                	je     801523 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801505:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801508:	8b 52 0c             	mov    0xc(%edx),%edx
  80150b:	85 d2                	test   %edx,%edx
  80150d:	74 35                	je     801544 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80150f:	83 ec 04             	sub    $0x4,%esp
  801512:	ff 75 10             	pushl  0x10(%ebp)
  801515:	ff 75 0c             	pushl  0xc(%ebp)
  801518:	50                   	push   %eax
  801519:	ff d2                	call   *%edx
  80151b:	83 c4 10             	add    $0x10,%esp
}
  80151e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801521:	c9                   	leave  
  801522:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801523:	a1 20 44 80 00       	mov    0x804420,%eax
  801528:	8b 40 48             	mov    0x48(%eax),%eax
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	53                   	push   %ebx
  80152f:	50                   	push   %eax
  801530:	68 44 27 80 00       	push   $0x802744
  801535:	e8 cd ed ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801542:	eb da                	jmp    80151e <write+0x55>
		return -E_NOT_SUPP;
  801544:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801549:	eb d3                	jmp    80151e <write+0x55>

0080154b <seek>:

int
seek(int fdnum, off_t offset)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801551:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801554:	50                   	push   %eax
  801555:	ff 75 08             	pushl  0x8(%ebp)
  801558:	e8 2d fc ff ff       	call   80118a <fd_lookup>
  80155d:	83 c4 08             	add    $0x8,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	78 0e                	js     801572 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801564:	8b 55 0c             	mov    0xc(%ebp),%edx
  801567:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80156a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80156d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	53                   	push   %ebx
  801578:	83 ec 14             	sub    $0x14,%esp
  80157b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801581:	50                   	push   %eax
  801582:	53                   	push   %ebx
  801583:	e8 02 fc ff ff       	call   80118a <fd_lookup>
  801588:	83 c4 08             	add    $0x8,%esp
  80158b:	85 c0                	test   %eax,%eax
  80158d:	78 37                	js     8015c6 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80158f:	83 ec 08             	sub    $0x8,%esp
  801592:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801595:	50                   	push   %eax
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	ff 30                	pushl  (%eax)
  80159b:	e8 40 fc ff ff       	call   8011e0 <dev_lookup>
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	78 1f                	js     8015c6 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ae:	74 1b                	je     8015cb <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b3:	8b 52 18             	mov    0x18(%edx),%edx
  8015b6:	85 d2                	test   %edx,%edx
  8015b8:	74 32                	je     8015ec <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	ff 75 0c             	pushl  0xc(%ebp)
  8015c0:	50                   	push   %eax
  8015c1:	ff d2                	call   *%edx
  8015c3:	83 c4 10             	add    $0x10,%esp
}
  8015c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015cb:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015d0:	8b 40 48             	mov    0x48(%eax),%eax
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	53                   	push   %ebx
  8015d7:	50                   	push   %eax
  8015d8:	68 04 27 80 00       	push   $0x802704
  8015dd:	e8 25 ed ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ea:	eb da                	jmp    8015c6 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f1:	eb d3                	jmp    8015c6 <ftruncate+0x52>

008015f3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	53                   	push   %ebx
  8015f7:	83 ec 14             	sub    $0x14,%esp
  8015fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	ff 75 08             	pushl  0x8(%ebp)
  801604:	e8 81 fb ff ff       	call   80118a <fd_lookup>
  801609:	83 c4 08             	add    $0x8,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 4b                	js     80165b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801616:	50                   	push   %eax
  801617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161a:	ff 30                	pushl  (%eax)
  80161c:	e8 bf fb ff ff       	call   8011e0 <dev_lookup>
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	85 c0                	test   %eax,%eax
  801626:	78 33                	js     80165b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80162f:	74 2f                	je     801660 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801631:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801634:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80163b:	00 00 00 
	stat->st_isdir = 0;
  80163e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801645:	00 00 00 
	stat->st_dev = dev;
  801648:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80164e:	83 ec 08             	sub    $0x8,%esp
  801651:	53                   	push   %ebx
  801652:	ff 75 f0             	pushl  -0x10(%ebp)
  801655:	ff 50 14             	call   *0x14(%eax)
  801658:	83 c4 10             	add    $0x10,%esp
}
  80165b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    
		return -E_NOT_SUPP;
  801660:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801665:	eb f4                	jmp    80165b <fstat+0x68>

00801667 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	56                   	push   %esi
  80166b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80166c:	83 ec 08             	sub    $0x8,%esp
  80166f:	6a 00                	push   $0x0
  801671:	ff 75 08             	pushl  0x8(%ebp)
  801674:	e8 e7 01 00 00       	call   801860 <open>
  801679:	89 c3                	mov    %eax,%ebx
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	85 c0                	test   %eax,%eax
  801680:	78 1b                	js     80169d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801682:	83 ec 08             	sub    $0x8,%esp
  801685:	ff 75 0c             	pushl  0xc(%ebp)
  801688:	50                   	push   %eax
  801689:	e8 65 ff ff ff       	call   8015f3 <fstat>
  80168e:	89 c6                	mov    %eax,%esi
	close(fd);
  801690:	89 1c 24             	mov    %ebx,(%esp)
  801693:	e8 27 fc ff ff       	call   8012bf <close>
	return r;
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	89 f3                	mov    %esi,%ebx
}
  80169d:	89 d8                	mov    %ebx,%eax
  80169f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a2:	5b                   	pop    %ebx
  8016a3:	5e                   	pop    %esi
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    

008016a6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	56                   	push   %esi
  8016aa:	53                   	push   %ebx
  8016ab:	89 c6                	mov    %eax,%esi
  8016ad:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016af:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016b6:	74 27                	je     8016df <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016b8:	6a 07                	push   $0x7
  8016ba:	68 00 50 80 00       	push   $0x805000
  8016bf:	56                   	push   %esi
  8016c0:	ff 35 00 40 80 00    	pushl  0x804000
  8016c6:	e8 05 08 00 00       	call   801ed0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016cb:	83 c4 0c             	add    $0xc,%esp
  8016ce:	6a 00                	push   $0x0
  8016d0:	53                   	push   %ebx
  8016d1:	6a 00                	push   $0x0
  8016d3:	e8 e1 07 00 00       	call   801eb9 <ipc_recv>
}
  8016d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016db:	5b                   	pop    %ebx
  8016dc:	5e                   	pop    %esi
  8016dd:	5d                   	pop    %ebp
  8016de:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016df:	83 ec 0c             	sub    $0xc,%esp
  8016e2:	6a 01                	push   $0x1
  8016e4:	e8 fe 07 00 00       	call   801ee7 <ipc_find_env>
  8016e9:	a3 00 40 80 00       	mov    %eax,0x804000
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	eb c5                	jmp    8016b8 <fsipc+0x12>

008016f3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ff:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801704:	8b 45 0c             	mov    0xc(%ebp),%eax
  801707:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80170c:	ba 00 00 00 00       	mov    $0x0,%edx
  801711:	b8 02 00 00 00       	mov    $0x2,%eax
  801716:	e8 8b ff ff ff       	call   8016a6 <fsipc>
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <devfile_flush>:
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8b 40 0c             	mov    0xc(%eax),%eax
  801729:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80172e:	ba 00 00 00 00       	mov    $0x0,%edx
  801733:	b8 06 00 00 00       	mov    $0x6,%eax
  801738:	e8 69 ff ff ff       	call   8016a6 <fsipc>
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <devfile_stat>:
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	53                   	push   %ebx
  801743:	83 ec 04             	sub    $0x4,%esp
  801746:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8b 40 0c             	mov    0xc(%eax),%eax
  80174f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801754:	ba 00 00 00 00       	mov    $0x0,%edx
  801759:	b8 05 00 00 00       	mov    $0x5,%eax
  80175e:	e8 43 ff ff ff       	call   8016a6 <fsipc>
  801763:	85 c0                	test   %eax,%eax
  801765:	78 2c                	js     801793 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801767:	83 ec 08             	sub    $0x8,%esp
  80176a:	68 00 50 80 00       	push   $0x805000
  80176f:	53                   	push   %ebx
  801770:	e8 7c f1 ff ff       	call   8008f1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801775:	a1 80 50 80 00       	mov    0x805080,%eax
  80177a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801780:	a1 84 50 80 00       	mov    0x805084,%eax
  801785:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801793:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <devfile_write>:
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 0c             	sub    $0xc,%esp
  80179e:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a1:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8017a6:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8017ab:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b1:	8b 52 0c             	mov    0xc(%edx),%edx
  8017b4:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8017ba:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8017bf:	50                   	push   %eax
  8017c0:	ff 75 0c             	pushl  0xc(%ebp)
  8017c3:	68 08 50 80 00       	push   $0x805008
  8017c8:	e8 b2 f2 ff ff       	call   800a7f <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d2:	b8 04 00 00 00       	mov    $0x4,%eax
  8017d7:	e8 ca fe ff ff       	call   8016a6 <fsipc>
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <devfile_read>:
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	56                   	push   %esi
  8017e2:	53                   	push   %ebx
  8017e3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ec:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017f1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fc:	b8 03 00 00 00       	mov    $0x3,%eax
  801801:	e8 a0 fe ff ff       	call   8016a6 <fsipc>
  801806:	89 c3                	mov    %eax,%ebx
  801808:	85 c0                	test   %eax,%eax
  80180a:	78 1f                	js     80182b <devfile_read+0x4d>
	assert(r <= n);
  80180c:	39 f0                	cmp    %esi,%eax
  80180e:	77 24                	ja     801834 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801810:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801815:	7f 33                	jg     80184a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801817:	83 ec 04             	sub    $0x4,%esp
  80181a:	50                   	push   %eax
  80181b:	68 00 50 80 00       	push   $0x805000
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	e8 57 f2 ff ff       	call   800a7f <memmove>
	return r;
  801828:	83 c4 10             	add    $0x10,%esp
}
  80182b:	89 d8                	mov    %ebx,%eax
  80182d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801830:	5b                   	pop    %ebx
  801831:	5e                   	pop    %esi
  801832:	5d                   	pop    %ebp
  801833:	c3                   	ret    
	assert(r <= n);
  801834:	68 74 27 80 00       	push   $0x802774
  801839:	68 7b 27 80 00       	push   $0x80277b
  80183e:	6a 7c                	push   $0x7c
  801840:	68 90 27 80 00       	push   $0x802790
  801845:	e8 e2 e9 ff ff       	call   80022c <_panic>
	assert(r <= PGSIZE);
  80184a:	68 9b 27 80 00       	push   $0x80279b
  80184f:	68 7b 27 80 00       	push   $0x80277b
  801854:	6a 7d                	push   $0x7d
  801856:	68 90 27 80 00       	push   $0x802790
  80185b:	e8 cc e9 ff ff       	call   80022c <_panic>

00801860 <open>:
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	56                   	push   %esi
  801864:	53                   	push   %ebx
  801865:	83 ec 1c             	sub    $0x1c,%esp
  801868:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80186b:	56                   	push   %esi
  80186c:	e8 49 f0 ff ff       	call   8008ba <strlen>
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801879:	7f 6c                	jg     8018e7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80187b:	83 ec 0c             	sub    $0xc,%esp
  80187e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801881:	50                   	push   %eax
  801882:	e8 b4 f8 ff ff       	call   80113b <fd_alloc>
  801887:	89 c3                	mov    %eax,%ebx
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	85 c0                	test   %eax,%eax
  80188e:	78 3c                	js     8018cc <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	56                   	push   %esi
  801894:	68 00 50 80 00       	push   $0x805000
  801899:	e8 53 f0 ff ff       	call   8008f1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80189e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a1:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ae:	e8 f3 fd ff ff       	call   8016a6 <fsipc>
  8018b3:	89 c3                	mov    %eax,%ebx
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	78 19                	js     8018d5 <open+0x75>
	return fd2num(fd);
  8018bc:	83 ec 0c             	sub    $0xc,%esp
  8018bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c2:	e8 4d f8 ff ff       	call   801114 <fd2num>
  8018c7:	89 c3                	mov    %eax,%ebx
  8018c9:	83 c4 10             	add    $0x10,%esp
}
  8018cc:	89 d8                	mov    %ebx,%eax
  8018ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d1:	5b                   	pop    %ebx
  8018d2:	5e                   	pop    %esi
  8018d3:	5d                   	pop    %ebp
  8018d4:	c3                   	ret    
		fd_close(fd, 0);
  8018d5:	83 ec 08             	sub    $0x8,%esp
  8018d8:	6a 00                	push   $0x0
  8018da:	ff 75 f4             	pushl  -0xc(%ebp)
  8018dd:	e8 54 f9 ff ff       	call   801236 <fd_close>
		return r;
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	eb e5                	jmp    8018cc <open+0x6c>
		return -E_BAD_PATH;
  8018e7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018ec:	eb de                	jmp    8018cc <open+0x6c>

008018ee <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f9:	b8 08 00 00 00       	mov    $0x8,%eax
  8018fe:	e8 a3 fd ff ff       	call   8016a6 <fsipc>
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	56                   	push   %esi
  801909:	53                   	push   %ebx
  80190a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	ff 75 08             	pushl  0x8(%ebp)
  801913:	e8 0c f8 ff ff       	call   801124 <fd2data>
  801918:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80191a:	83 c4 08             	add    $0x8,%esp
  80191d:	68 a7 27 80 00       	push   $0x8027a7
  801922:	53                   	push   %ebx
  801923:	e8 c9 ef ff ff       	call   8008f1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801928:	8b 46 04             	mov    0x4(%esi),%eax
  80192b:	2b 06                	sub    (%esi),%eax
  80192d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801933:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80193a:	00 00 00 
	stat->st_dev = &devpipe;
  80193d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801944:	30 80 00 
	return 0;
}
  801947:	b8 00 00 00 00       	mov    $0x0,%eax
  80194c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194f:	5b                   	pop    %ebx
  801950:	5e                   	pop    %esi
  801951:	5d                   	pop    %ebp
  801952:	c3                   	ret    

00801953 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	53                   	push   %ebx
  801957:	83 ec 0c             	sub    $0xc,%esp
  80195a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80195d:	53                   	push   %ebx
  80195e:	6a 00                	push   $0x0
  801960:	e8 0a f4 ff ff       	call   800d6f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801965:	89 1c 24             	mov    %ebx,(%esp)
  801968:	e8 b7 f7 ff ff       	call   801124 <fd2data>
  80196d:	83 c4 08             	add    $0x8,%esp
  801970:	50                   	push   %eax
  801971:	6a 00                	push   $0x0
  801973:	e8 f7 f3 ff ff       	call   800d6f <sys_page_unmap>
}
  801978:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <_pipeisclosed>:
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	57                   	push   %edi
  801981:	56                   	push   %esi
  801982:	53                   	push   %ebx
  801983:	83 ec 1c             	sub    $0x1c,%esp
  801986:	89 c7                	mov    %eax,%edi
  801988:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80198a:	a1 20 44 80 00       	mov    0x804420,%eax
  80198f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801992:	83 ec 0c             	sub    $0xc,%esp
  801995:	57                   	push   %edi
  801996:	e8 85 05 00 00       	call   801f20 <pageref>
  80199b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80199e:	89 34 24             	mov    %esi,(%esp)
  8019a1:	e8 7a 05 00 00       	call   801f20 <pageref>
		nn = thisenv->env_runs;
  8019a6:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8019ac:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	39 cb                	cmp    %ecx,%ebx
  8019b4:	74 1b                	je     8019d1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8019b6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019b9:	75 cf                	jne    80198a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019bb:	8b 42 58             	mov    0x58(%edx),%eax
  8019be:	6a 01                	push   $0x1
  8019c0:	50                   	push   %eax
  8019c1:	53                   	push   %ebx
  8019c2:	68 ae 27 80 00       	push   $0x8027ae
  8019c7:	e8 3b e9 ff ff       	call   800307 <cprintf>
  8019cc:	83 c4 10             	add    $0x10,%esp
  8019cf:	eb b9                	jmp    80198a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8019d1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019d4:	0f 94 c0             	sete   %al
  8019d7:	0f b6 c0             	movzbl %al,%eax
}
  8019da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019dd:	5b                   	pop    %ebx
  8019de:	5e                   	pop    %esi
  8019df:	5f                   	pop    %edi
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <devpipe_write>:
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	57                   	push   %edi
  8019e6:	56                   	push   %esi
  8019e7:	53                   	push   %ebx
  8019e8:	83 ec 28             	sub    $0x28,%esp
  8019eb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8019ee:	56                   	push   %esi
  8019ef:	e8 30 f7 ff ff       	call   801124 <fd2data>
  8019f4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8019fe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a01:	74 4f                	je     801a52 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a03:	8b 43 04             	mov    0x4(%ebx),%eax
  801a06:	8b 0b                	mov    (%ebx),%ecx
  801a08:	8d 51 20             	lea    0x20(%ecx),%edx
  801a0b:	39 d0                	cmp    %edx,%eax
  801a0d:	72 14                	jb     801a23 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a0f:	89 da                	mov    %ebx,%edx
  801a11:	89 f0                	mov    %esi,%eax
  801a13:	e8 65 ff ff ff       	call   80197d <_pipeisclosed>
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	75 3a                	jne    801a56 <devpipe_write+0x74>
			sys_yield();
  801a1c:	e8 aa f2 ff ff       	call   800ccb <sys_yield>
  801a21:	eb e0                	jmp    801a03 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a26:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a2a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a2d:	89 c2                	mov    %eax,%edx
  801a2f:	c1 fa 1f             	sar    $0x1f,%edx
  801a32:	89 d1                	mov    %edx,%ecx
  801a34:	c1 e9 1b             	shr    $0x1b,%ecx
  801a37:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a3a:	83 e2 1f             	and    $0x1f,%edx
  801a3d:	29 ca                	sub    %ecx,%edx
  801a3f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801a43:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801a47:	83 c0 01             	add    $0x1,%eax
  801a4a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a4d:	83 c7 01             	add    $0x1,%edi
  801a50:	eb ac                	jmp    8019fe <devpipe_write+0x1c>
	return i;
  801a52:	89 f8                	mov    %edi,%eax
  801a54:	eb 05                	jmp    801a5b <devpipe_write+0x79>
				return 0;
  801a56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a5e:	5b                   	pop    %ebx
  801a5f:	5e                   	pop    %esi
  801a60:	5f                   	pop    %edi
  801a61:	5d                   	pop    %ebp
  801a62:	c3                   	ret    

00801a63 <devpipe_read>:
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	57                   	push   %edi
  801a67:	56                   	push   %esi
  801a68:	53                   	push   %ebx
  801a69:	83 ec 18             	sub    $0x18,%esp
  801a6c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a6f:	57                   	push   %edi
  801a70:	e8 af f6 ff ff       	call   801124 <fd2data>
  801a75:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a77:	83 c4 10             	add    $0x10,%esp
  801a7a:	be 00 00 00 00       	mov    $0x0,%esi
  801a7f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a82:	74 47                	je     801acb <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801a84:	8b 03                	mov    (%ebx),%eax
  801a86:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a89:	75 22                	jne    801aad <devpipe_read+0x4a>
			if (i > 0)
  801a8b:	85 f6                	test   %esi,%esi
  801a8d:	75 14                	jne    801aa3 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801a8f:	89 da                	mov    %ebx,%edx
  801a91:	89 f8                	mov    %edi,%eax
  801a93:	e8 e5 fe ff ff       	call   80197d <_pipeisclosed>
  801a98:	85 c0                	test   %eax,%eax
  801a9a:	75 33                	jne    801acf <devpipe_read+0x6c>
			sys_yield();
  801a9c:	e8 2a f2 ff ff       	call   800ccb <sys_yield>
  801aa1:	eb e1                	jmp    801a84 <devpipe_read+0x21>
				return i;
  801aa3:	89 f0                	mov    %esi,%eax
}
  801aa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aa8:	5b                   	pop    %ebx
  801aa9:	5e                   	pop    %esi
  801aaa:	5f                   	pop    %edi
  801aab:	5d                   	pop    %ebp
  801aac:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801aad:	99                   	cltd   
  801aae:	c1 ea 1b             	shr    $0x1b,%edx
  801ab1:	01 d0                	add    %edx,%eax
  801ab3:	83 e0 1f             	and    $0x1f,%eax
  801ab6:	29 d0                	sub    %edx,%eax
  801ab8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ac0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ac3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ac6:	83 c6 01             	add    $0x1,%esi
  801ac9:	eb b4                	jmp    801a7f <devpipe_read+0x1c>
	return i;
  801acb:	89 f0                	mov    %esi,%eax
  801acd:	eb d6                	jmp    801aa5 <devpipe_read+0x42>
				return 0;
  801acf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad4:	eb cf                	jmp    801aa5 <devpipe_read+0x42>

00801ad6 <pipe>:
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	56                   	push   %esi
  801ada:	53                   	push   %ebx
  801adb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ade:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae1:	50                   	push   %eax
  801ae2:	e8 54 f6 ff ff       	call   80113b <fd_alloc>
  801ae7:	89 c3                	mov    %eax,%ebx
  801ae9:	83 c4 10             	add    $0x10,%esp
  801aec:	85 c0                	test   %eax,%eax
  801aee:	78 5b                	js     801b4b <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801af0:	83 ec 04             	sub    $0x4,%esp
  801af3:	68 07 04 00 00       	push   $0x407
  801af8:	ff 75 f4             	pushl  -0xc(%ebp)
  801afb:	6a 00                	push   $0x0
  801afd:	e8 e8 f1 ff ff       	call   800cea <sys_page_alloc>
  801b02:	89 c3                	mov    %eax,%ebx
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 40                	js     801b4b <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801b0b:	83 ec 0c             	sub    $0xc,%esp
  801b0e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b11:	50                   	push   %eax
  801b12:	e8 24 f6 ff ff       	call   80113b <fd_alloc>
  801b17:	89 c3                	mov    %eax,%ebx
  801b19:	83 c4 10             	add    $0x10,%esp
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 1b                	js     801b3b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b20:	83 ec 04             	sub    $0x4,%esp
  801b23:	68 07 04 00 00       	push   $0x407
  801b28:	ff 75 f0             	pushl  -0x10(%ebp)
  801b2b:	6a 00                	push   $0x0
  801b2d:	e8 b8 f1 ff ff       	call   800cea <sys_page_alloc>
  801b32:	89 c3                	mov    %eax,%ebx
  801b34:	83 c4 10             	add    $0x10,%esp
  801b37:	85 c0                	test   %eax,%eax
  801b39:	79 19                	jns    801b54 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801b3b:	83 ec 08             	sub    $0x8,%esp
  801b3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b41:	6a 00                	push   $0x0
  801b43:	e8 27 f2 ff ff       	call   800d6f <sys_page_unmap>
  801b48:	83 c4 10             	add    $0x10,%esp
}
  801b4b:	89 d8                	mov    %ebx,%eax
  801b4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b50:	5b                   	pop    %ebx
  801b51:	5e                   	pop    %esi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    
	va = fd2data(fd0);
  801b54:	83 ec 0c             	sub    $0xc,%esp
  801b57:	ff 75 f4             	pushl  -0xc(%ebp)
  801b5a:	e8 c5 f5 ff ff       	call   801124 <fd2data>
  801b5f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b61:	83 c4 0c             	add    $0xc,%esp
  801b64:	68 07 04 00 00       	push   $0x407
  801b69:	50                   	push   %eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	e8 79 f1 ff ff       	call   800cea <sys_page_alloc>
  801b71:	89 c3                	mov    %eax,%ebx
  801b73:	83 c4 10             	add    $0x10,%esp
  801b76:	85 c0                	test   %eax,%eax
  801b78:	0f 88 8c 00 00 00    	js     801c0a <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b7e:	83 ec 0c             	sub    $0xc,%esp
  801b81:	ff 75 f0             	pushl  -0x10(%ebp)
  801b84:	e8 9b f5 ff ff       	call   801124 <fd2data>
  801b89:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b90:	50                   	push   %eax
  801b91:	6a 00                	push   $0x0
  801b93:	56                   	push   %esi
  801b94:	6a 00                	push   $0x0
  801b96:	e8 92 f1 ff ff       	call   800d2d <sys_page_map>
  801b9b:	89 c3                	mov    %eax,%ebx
  801b9d:	83 c4 20             	add    $0x20,%esp
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	78 58                	js     801bfc <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbc:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bc2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801bce:	83 ec 0c             	sub    $0xc,%esp
  801bd1:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd4:	e8 3b f5 ff ff       	call   801114 <fd2num>
  801bd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bdc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801bde:	83 c4 04             	add    $0x4,%esp
  801be1:	ff 75 f0             	pushl  -0x10(%ebp)
  801be4:	e8 2b f5 ff ff       	call   801114 <fd2num>
  801be9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bf7:	e9 4f ff ff ff       	jmp    801b4b <pipe+0x75>
	sys_page_unmap(0, va);
  801bfc:	83 ec 08             	sub    $0x8,%esp
  801bff:	56                   	push   %esi
  801c00:	6a 00                	push   $0x0
  801c02:	e8 68 f1 ff ff       	call   800d6f <sys_page_unmap>
  801c07:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c0a:	83 ec 08             	sub    $0x8,%esp
  801c0d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c10:	6a 00                	push   $0x0
  801c12:	e8 58 f1 ff ff       	call   800d6f <sys_page_unmap>
  801c17:	83 c4 10             	add    $0x10,%esp
  801c1a:	e9 1c ff ff ff       	jmp    801b3b <pipe+0x65>

00801c1f <pipeisclosed>:
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c28:	50                   	push   %eax
  801c29:	ff 75 08             	pushl  0x8(%ebp)
  801c2c:	e8 59 f5 ff ff       	call   80118a <fd_lookup>
  801c31:	83 c4 10             	add    $0x10,%esp
  801c34:	85 c0                	test   %eax,%eax
  801c36:	78 18                	js     801c50 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c38:	83 ec 0c             	sub    $0xc,%esp
  801c3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c3e:	e8 e1 f4 ff ff       	call   801124 <fd2data>
	return _pipeisclosed(fd, p);
  801c43:	89 c2                	mov    %eax,%edx
  801c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c48:	e8 30 fd ff ff       	call   80197d <_pipeisclosed>
  801c4d:	83 c4 10             	add    $0x10,%esp
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	56                   	push   %esi
  801c56:	53                   	push   %ebx
  801c57:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801c5a:	85 f6                	test   %esi,%esi
  801c5c:	74 13                	je     801c71 <wait+0x1f>
	e = &envs[ENVX(envid)];
  801c5e:	89 f3                	mov    %esi,%ebx
  801c60:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801c66:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  801c69:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801c6f:	eb 1b                	jmp    801c8c <wait+0x3a>
	assert(envid != 0);
  801c71:	68 c6 27 80 00       	push   $0x8027c6
  801c76:	68 7b 27 80 00       	push   $0x80277b
  801c7b:	6a 09                	push   $0x9
  801c7d:	68 d1 27 80 00       	push   $0x8027d1
  801c82:	e8 a5 e5 ff ff       	call   80022c <_panic>
		sys_yield();
  801c87:	e8 3f f0 ff ff       	call   800ccb <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801c8c:	8b 43 48             	mov    0x48(%ebx),%eax
  801c8f:	39 f0                	cmp    %esi,%eax
  801c91:	75 07                	jne    801c9a <wait+0x48>
  801c93:	8b 43 54             	mov    0x54(%ebx),%eax
  801c96:	85 c0                	test   %eax,%eax
  801c98:	75 ed                	jne    801c87 <wait+0x35>
}
  801c9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9d:	5b                   	pop    %ebx
  801c9e:	5e                   	pop    %esi
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    

00801ca1 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ca4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca9:	5d                   	pop    %ebp
  801caa:	c3                   	ret    

00801cab <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801cb1:	68 dc 27 80 00       	push   $0x8027dc
  801cb6:	ff 75 0c             	pushl  0xc(%ebp)
  801cb9:	e8 33 ec ff ff       	call   8008f1 <strcpy>
	return 0;
}
  801cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <devcons_write>:
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	57                   	push   %edi
  801cc9:	56                   	push   %esi
  801cca:	53                   	push   %ebx
  801ccb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801cd1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801cd6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801cdc:	eb 2f                	jmp    801d0d <devcons_write+0x48>
		m = n - tot;
  801cde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ce1:	29 f3                	sub    %esi,%ebx
  801ce3:	83 fb 7f             	cmp    $0x7f,%ebx
  801ce6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ceb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	53                   	push   %ebx
  801cf2:	89 f0                	mov    %esi,%eax
  801cf4:	03 45 0c             	add    0xc(%ebp),%eax
  801cf7:	50                   	push   %eax
  801cf8:	57                   	push   %edi
  801cf9:	e8 81 ed ff ff       	call   800a7f <memmove>
		sys_cputs(buf, m);
  801cfe:	83 c4 08             	add    $0x8,%esp
  801d01:	53                   	push   %ebx
  801d02:	57                   	push   %edi
  801d03:	e8 26 ef ff ff       	call   800c2e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d08:	01 de                	add    %ebx,%esi
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d10:	72 cc                	jb     801cde <devcons_write+0x19>
}
  801d12:	89 f0                	mov    %esi,%eax
  801d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5f                   	pop    %edi
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    

00801d1c <devcons_read>:
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	83 ec 08             	sub    $0x8,%esp
  801d22:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d2b:	75 07                	jne    801d34 <devcons_read+0x18>
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    
		sys_yield();
  801d2f:	e8 97 ef ff ff       	call   800ccb <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801d34:	e8 13 ef ff ff       	call   800c4c <sys_cgetc>
  801d39:	85 c0                	test   %eax,%eax
  801d3b:	74 f2                	je     801d2f <devcons_read+0x13>
	if (c < 0)
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	78 ec                	js     801d2d <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801d41:	83 f8 04             	cmp    $0x4,%eax
  801d44:	74 0c                	je     801d52 <devcons_read+0x36>
	*(char*)vbuf = c;
  801d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d49:	88 02                	mov    %al,(%edx)
	return 1;
  801d4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d50:	eb db                	jmp    801d2d <devcons_read+0x11>
		return 0;
  801d52:	b8 00 00 00 00       	mov    $0x0,%eax
  801d57:	eb d4                	jmp    801d2d <devcons_read+0x11>

00801d59 <cputchar>:
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d65:	6a 01                	push   $0x1
  801d67:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d6a:	50                   	push   %eax
  801d6b:	e8 be ee ff ff       	call   800c2e <sys_cputs>
}
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <getchar>:
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d7b:	6a 01                	push   $0x1
  801d7d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d80:	50                   	push   %eax
  801d81:	6a 00                	push   $0x0
  801d83:	e8 73 f6 ff ff       	call   8013fb <read>
	if (r < 0)
  801d88:	83 c4 10             	add    $0x10,%esp
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	78 08                	js     801d97 <getchar+0x22>
	if (r < 1)
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	7e 06                	jle    801d99 <getchar+0x24>
	return c;
  801d93:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    
		return -E_EOF;
  801d99:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d9e:	eb f7                	jmp    801d97 <getchar+0x22>

00801da0 <iscons>:
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801da6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da9:	50                   	push   %eax
  801daa:	ff 75 08             	pushl  0x8(%ebp)
  801dad:	e8 d8 f3 ff ff       	call   80118a <fd_lookup>
  801db2:	83 c4 10             	add    $0x10,%esp
  801db5:	85 c0                	test   %eax,%eax
  801db7:	78 11                	js     801dca <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbc:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dc2:	39 10                	cmp    %edx,(%eax)
  801dc4:	0f 94 c0             	sete   %al
  801dc7:	0f b6 c0             	movzbl %al,%eax
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <opencons>:
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801dd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd5:	50                   	push   %eax
  801dd6:	e8 60 f3 ff ff       	call   80113b <fd_alloc>
  801ddb:	83 c4 10             	add    $0x10,%esp
  801dde:	85 c0                	test   %eax,%eax
  801de0:	78 3a                	js     801e1c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801de2:	83 ec 04             	sub    $0x4,%esp
  801de5:	68 07 04 00 00       	push   $0x407
  801dea:	ff 75 f4             	pushl  -0xc(%ebp)
  801ded:	6a 00                	push   $0x0
  801def:	e8 f6 ee ff ff       	call   800cea <sys_page_alloc>
  801df4:	83 c4 10             	add    $0x10,%esp
  801df7:	85 c0                	test   %eax,%eax
  801df9:	78 21                	js     801e1c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfe:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e04:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e09:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e10:	83 ec 0c             	sub    $0xc,%esp
  801e13:	50                   	push   %eax
  801e14:	e8 fb f2 ff ff       	call   801114 <fd2num>
  801e19:	83 c4 10             	add    $0x10,%esp
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	53                   	push   %ebx
  801e22:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801e25:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801e2c:	74 0d                	je     801e3b <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801e36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801e3b:	e8 6c ee ff ff       	call   800cac <sys_getenvid>
  801e40:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801e42:	83 ec 04             	sub    $0x4,%esp
  801e45:	6a 07                	push   $0x7
  801e47:	68 00 f0 bf ee       	push   $0xeebff000
  801e4c:	50                   	push   %eax
  801e4d:	e8 98 ee ff ff       	call   800cea <sys_page_alloc>
        	if (r < 0) {
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	85 c0                	test   %eax,%eax
  801e57:	78 27                	js     801e80 <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801e59:	83 ec 08             	sub    $0x8,%esp
  801e5c:	68 92 1e 80 00       	push   $0x801e92
  801e61:	53                   	push   %ebx
  801e62:	e8 ce ef ff ff       	call   800e35 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	79 c0                	jns    801e2e <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801e6e:	50                   	push   %eax
  801e6f:	68 e8 27 80 00       	push   $0x8027e8
  801e74:	6a 28                	push   $0x28
  801e76:	68 fc 27 80 00       	push   $0x8027fc
  801e7b:	e8 ac e3 ff ff       	call   80022c <_panic>
            		panic("pgfault_handler: %e", r);
  801e80:	50                   	push   %eax
  801e81:	68 e8 27 80 00       	push   $0x8027e8
  801e86:	6a 24                	push   $0x24
  801e88:	68 fc 27 80 00       	push   $0x8027fc
  801e8d:	e8 9a e3 ff ff       	call   80022c <_panic>

00801e92 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801e92:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801e93:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801e98:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801e9a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801e9d:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801ea1:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801ea4:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801ea8:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801eac:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801eaf:	83 c4 08             	add    $0x8,%esp
	popal
  801eb2:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801eb3:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801eb6:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801eb7:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801eb8:	c3                   	ret    

00801eb9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801ebf:	68 0a 28 80 00       	push   $0x80280a
  801ec4:	6a 1a                	push   $0x1a
  801ec6:	68 23 28 80 00       	push   $0x802823
  801ecb:	e8 5c e3 ff ff       	call   80022c <_panic>

00801ed0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801ed6:	68 2d 28 80 00       	push   $0x80282d
  801edb:	6a 2a                	push   $0x2a
  801edd:	68 23 28 80 00       	push   $0x802823
  801ee2:	e8 45 e3 ff ff       	call   80022c <_panic>

00801ee7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801eed:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801ef2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801ef5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801efb:	8b 52 50             	mov    0x50(%edx),%edx
  801efe:	39 ca                	cmp    %ecx,%edx
  801f00:	74 11                	je     801f13 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801f02:	83 c0 01             	add    $0x1,%eax
  801f05:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f0a:	75 e6                	jne    801ef2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f11:	eb 0b                	jmp    801f1e <ipc_find_env+0x37>
			return envs[i].env_id;
  801f13:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f16:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f1b:	8b 40 48             	mov    0x48(%eax),%eax
}
  801f1e:	5d                   	pop    %ebp
  801f1f:	c3                   	ret    

00801f20 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f26:	89 d0                	mov    %edx,%eax
  801f28:	c1 e8 16             	shr    $0x16,%eax
  801f2b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f32:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801f37:	f6 c1 01             	test   $0x1,%cl
  801f3a:	74 1d                	je     801f59 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801f3c:	c1 ea 0c             	shr    $0xc,%edx
  801f3f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f46:	f6 c2 01             	test   $0x1,%dl
  801f49:	74 0e                	je     801f59 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f4b:	c1 ea 0c             	shr    $0xc,%edx
  801f4e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f55:	ef 
  801f56:	0f b7 c0             	movzwl %ax,%eax
}
  801f59:	5d                   	pop    %ebp
  801f5a:	c3                   	ret    
  801f5b:	66 90                	xchg   %ax,%ax
  801f5d:	66 90                	xchg   %ax,%ax
  801f5f:	90                   	nop

00801f60 <__udivdi3>:
  801f60:	55                   	push   %ebp
  801f61:	57                   	push   %edi
  801f62:	56                   	push   %esi
  801f63:	53                   	push   %ebx
  801f64:	83 ec 1c             	sub    $0x1c,%esp
  801f67:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f6b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f73:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f77:	85 d2                	test   %edx,%edx
  801f79:	75 35                	jne    801fb0 <__udivdi3+0x50>
  801f7b:	39 f3                	cmp    %esi,%ebx
  801f7d:	0f 87 bd 00 00 00    	ja     802040 <__udivdi3+0xe0>
  801f83:	85 db                	test   %ebx,%ebx
  801f85:	89 d9                	mov    %ebx,%ecx
  801f87:	75 0b                	jne    801f94 <__udivdi3+0x34>
  801f89:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8e:	31 d2                	xor    %edx,%edx
  801f90:	f7 f3                	div    %ebx
  801f92:	89 c1                	mov    %eax,%ecx
  801f94:	31 d2                	xor    %edx,%edx
  801f96:	89 f0                	mov    %esi,%eax
  801f98:	f7 f1                	div    %ecx
  801f9a:	89 c6                	mov    %eax,%esi
  801f9c:	89 e8                	mov    %ebp,%eax
  801f9e:	89 f7                	mov    %esi,%edi
  801fa0:	f7 f1                	div    %ecx
  801fa2:	89 fa                	mov    %edi,%edx
  801fa4:	83 c4 1c             	add    $0x1c,%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5f                   	pop    %edi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    
  801fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fb0:	39 f2                	cmp    %esi,%edx
  801fb2:	77 7c                	ja     802030 <__udivdi3+0xd0>
  801fb4:	0f bd fa             	bsr    %edx,%edi
  801fb7:	83 f7 1f             	xor    $0x1f,%edi
  801fba:	0f 84 98 00 00 00    	je     802058 <__udivdi3+0xf8>
  801fc0:	89 f9                	mov    %edi,%ecx
  801fc2:	b8 20 00 00 00       	mov    $0x20,%eax
  801fc7:	29 f8                	sub    %edi,%eax
  801fc9:	d3 e2                	shl    %cl,%edx
  801fcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fcf:	89 c1                	mov    %eax,%ecx
  801fd1:	89 da                	mov    %ebx,%edx
  801fd3:	d3 ea                	shr    %cl,%edx
  801fd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801fd9:	09 d1                	or     %edx,%ecx
  801fdb:	89 f2                	mov    %esi,%edx
  801fdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fe1:	89 f9                	mov    %edi,%ecx
  801fe3:	d3 e3                	shl    %cl,%ebx
  801fe5:	89 c1                	mov    %eax,%ecx
  801fe7:	d3 ea                	shr    %cl,%edx
  801fe9:	89 f9                	mov    %edi,%ecx
  801feb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801fef:	d3 e6                	shl    %cl,%esi
  801ff1:	89 eb                	mov    %ebp,%ebx
  801ff3:	89 c1                	mov    %eax,%ecx
  801ff5:	d3 eb                	shr    %cl,%ebx
  801ff7:	09 de                	or     %ebx,%esi
  801ff9:	89 f0                	mov    %esi,%eax
  801ffb:	f7 74 24 08          	divl   0x8(%esp)
  801fff:	89 d6                	mov    %edx,%esi
  802001:	89 c3                	mov    %eax,%ebx
  802003:	f7 64 24 0c          	mull   0xc(%esp)
  802007:	39 d6                	cmp    %edx,%esi
  802009:	72 0c                	jb     802017 <__udivdi3+0xb7>
  80200b:	89 f9                	mov    %edi,%ecx
  80200d:	d3 e5                	shl    %cl,%ebp
  80200f:	39 c5                	cmp    %eax,%ebp
  802011:	73 5d                	jae    802070 <__udivdi3+0x110>
  802013:	39 d6                	cmp    %edx,%esi
  802015:	75 59                	jne    802070 <__udivdi3+0x110>
  802017:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80201a:	31 ff                	xor    %edi,%edi
  80201c:	89 fa                	mov    %edi,%edx
  80201e:	83 c4 1c             	add    $0x1c,%esp
  802021:	5b                   	pop    %ebx
  802022:	5e                   	pop    %esi
  802023:	5f                   	pop    %edi
  802024:	5d                   	pop    %ebp
  802025:	c3                   	ret    
  802026:	8d 76 00             	lea    0x0(%esi),%esi
  802029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802030:	31 ff                	xor    %edi,%edi
  802032:	31 c0                	xor    %eax,%eax
  802034:	89 fa                	mov    %edi,%edx
  802036:	83 c4 1c             	add    $0x1c,%esp
  802039:	5b                   	pop    %ebx
  80203a:	5e                   	pop    %esi
  80203b:	5f                   	pop    %edi
  80203c:	5d                   	pop    %ebp
  80203d:	c3                   	ret    
  80203e:	66 90                	xchg   %ax,%ax
  802040:	31 ff                	xor    %edi,%edi
  802042:	89 e8                	mov    %ebp,%eax
  802044:	89 f2                	mov    %esi,%edx
  802046:	f7 f3                	div    %ebx
  802048:	89 fa                	mov    %edi,%edx
  80204a:	83 c4 1c             	add    $0x1c,%esp
  80204d:	5b                   	pop    %ebx
  80204e:	5e                   	pop    %esi
  80204f:	5f                   	pop    %edi
  802050:	5d                   	pop    %ebp
  802051:	c3                   	ret    
  802052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802058:	39 f2                	cmp    %esi,%edx
  80205a:	72 06                	jb     802062 <__udivdi3+0x102>
  80205c:	31 c0                	xor    %eax,%eax
  80205e:	39 eb                	cmp    %ebp,%ebx
  802060:	77 d2                	ja     802034 <__udivdi3+0xd4>
  802062:	b8 01 00 00 00       	mov    $0x1,%eax
  802067:	eb cb                	jmp    802034 <__udivdi3+0xd4>
  802069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802070:	89 d8                	mov    %ebx,%eax
  802072:	31 ff                	xor    %edi,%edi
  802074:	eb be                	jmp    802034 <__udivdi3+0xd4>
  802076:	66 90                	xchg   %ax,%ax
  802078:	66 90                	xchg   %ax,%ax
  80207a:	66 90                	xchg   %ax,%ax
  80207c:	66 90                	xchg   %ax,%ax
  80207e:	66 90                	xchg   %ax,%ax

00802080 <__umoddi3>:
  802080:	55                   	push   %ebp
  802081:	57                   	push   %edi
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	83 ec 1c             	sub    $0x1c,%esp
  802087:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80208b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80208f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802097:	85 ed                	test   %ebp,%ebp
  802099:	89 f0                	mov    %esi,%eax
  80209b:	89 da                	mov    %ebx,%edx
  80209d:	75 19                	jne    8020b8 <__umoddi3+0x38>
  80209f:	39 df                	cmp    %ebx,%edi
  8020a1:	0f 86 b1 00 00 00    	jbe    802158 <__umoddi3+0xd8>
  8020a7:	f7 f7                	div    %edi
  8020a9:	89 d0                	mov    %edx,%eax
  8020ab:	31 d2                	xor    %edx,%edx
  8020ad:	83 c4 1c             	add    $0x1c,%esp
  8020b0:	5b                   	pop    %ebx
  8020b1:	5e                   	pop    %esi
  8020b2:	5f                   	pop    %edi
  8020b3:	5d                   	pop    %ebp
  8020b4:	c3                   	ret    
  8020b5:	8d 76 00             	lea    0x0(%esi),%esi
  8020b8:	39 dd                	cmp    %ebx,%ebp
  8020ba:	77 f1                	ja     8020ad <__umoddi3+0x2d>
  8020bc:	0f bd cd             	bsr    %ebp,%ecx
  8020bf:	83 f1 1f             	xor    $0x1f,%ecx
  8020c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020c6:	0f 84 b4 00 00 00    	je     802180 <__umoddi3+0x100>
  8020cc:	b8 20 00 00 00       	mov    $0x20,%eax
  8020d1:	89 c2                	mov    %eax,%edx
  8020d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020d7:	29 c2                	sub    %eax,%edx
  8020d9:	89 c1                	mov    %eax,%ecx
  8020db:	89 f8                	mov    %edi,%eax
  8020dd:	d3 e5                	shl    %cl,%ebp
  8020df:	89 d1                	mov    %edx,%ecx
  8020e1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8020e5:	d3 e8                	shr    %cl,%eax
  8020e7:	09 c5                	or     %eax,%ebp
  8020e9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020ed:	89 c1                	mov    %eax,%ecx
  8020ef:	d3 e7                	shl    %cl,%edi
  8020f1:	89 d1                	mov    %edx,%ecx
  8020f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8020f7:	89 df                	mov    %ebx,%edi
  8020f9:	d3 ef                	shr    %cl,%edi
  8020fb:	89 c1                	mov    %eax,%ecx
  8020fd:	89 f0                	mov    %esi,%eax
  8020ff:	d3 e3                	shl    %cl,%ebx
  802101:	89 d1                	mov    %edx,%ecx
  802103:	89 fa                	mov    %edi,%edx
  802105:	d3 e8                	shr    %cl,%eax
  802107:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80210c:	09 d8                	or     %ebx,%eax
  80210e:	f7 f5                	div    %ebp
  802110:	d3 e6                	shl    %cl,%esi
  802112:	89 d1                	mov    %edx,%ecx
  802114:	f7 64 24 08          	mull   0x8(%esp)
  802118:	39 d1                	cmp    %edx,%ecx
  80211a:	89 c3                	mov    %eax,%ebx
  80211c:	89 d7                	mov    %edx,%edi
  80211e:	72 06                	jb     802126 <__umoddi3+0xa6>
  802120:	75 0e                	jne    802130 <__umoddi3+0xb0>
  802122:	39 c6                	cmp    %eax,%esi
  802124:	73 0a                	jae    802130 <__umoddi3+0xb0>
  802126:	2b 44 24 08          	sub    0x8(%esp),%eax
  80212a:	19 ea                	sbb    %ebp,%edx
  80212c:	89 d7                	mov    %edx,%edi
  80212e:	89 c3                	mov    %eax,%ebx
  802130:	89 ca                	mov    %ecx,%edx
  802132:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802137:	29 de                	sub    %ebx,%esi
  802139:	19 fa                	sbb    %edi,%edx
  80213b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80213f:	89 d0                	mov    %edx,%eax
  802141:	d3 e0                	shl    %cl,%eax
  802143:	89 d9                	mov    %ebx,%ecx
  802145:	d3 ee                	shr    %cl,%esi
  802147:	d3 ea                	shr    %cl,%edx
  802149:	09 f0                	or     %esi,%eax
  80214b:	83 c4 1c             	add    $0x1c,%esp
  80214e:	5b                   	pop    %ebx
  80214f:	5e                   	pop    %esi
  802150:	5f                   	pop    %edi
  802151:	5d                   	pop    %ebp
  802152:	c3                   	ret    
  802153:	90                   	nop
  802154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802158:	85 ff                	test   %edi,%edi
  80215a:	89 f9                	mov    %edi,%ecx
  80215c:	75 0b                	jne    802169 <__umoddi3+0xe9>
  80215e:	b8 01 00 00 00       	mov    $0x1,%eax
  802163:	31 d2                	xor    %edx,%edx
  802165:	f7 f7                	div    %edi
  802167:	89 c1                	mov    %eax,%ecx
  802169:	89 d8                	mov    %ebx,%eax
  80216b:	31 d2                	xor    %edx,%edx
  80216d:	f7 f1                	div    %ecx
  80216f:	89 f0                	mov    %esi,%eax
  802171:	f7 f1                	div    %ecx
  802173:	e9 31 ff ff ff       	jmp    8020a9 <__umoddi3+0x29>
  802178:	90                   	nop
  802179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802180:	39 dd                	cmp    %ebx,%ebp
  802182:	72 08                	jb     80218c <__umoddi3+0x10c>
  802184:	39 f7                	cmp    %esi,%edi
  802186:	0f 87 21 ff ff ff    	ja     8020ad <__umoddi3+0x2d>
  80218c:	89 da                	mov    %ebx,%edx
  80218e:	89 f0                	mov    %esi,%eax
  802190:	29 f8                	sub    %edi,%eax
  802192:	19 ea                	sbb    %ebp,%edx
  802194:	e9 14 ff ff ff       	jmp    8020ad <__umoddi3+0x2d>
