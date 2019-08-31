
obj/user/testpiperace.debug：     文件格式 elf32-i386


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
  80002c:	e8 bf 01 00 00       	call   8001f0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 80 21 80 00       	push   $0x802180
  800040:	e8 e6 02 00 00       	call   80032b <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 4c 1b 00 00       	call   801b9c <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 5b                	js     8000b2 <umain+0x7f>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 ba 0e 00 00       	call   800f16 <fork>
  80005c:	89 c6                	mov    %eax,%esi
  80005e:	85 c0                	test   %eax,%eax
  800060:	78 62                	js     8000c4 <umain+0x91>
		panic("fork: %e", r);
	if (r == 0) {
  800062:	85 c0                	test   %eax,%eax
  800064:	74 70                	je     8000d6 <umain+0xa3>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	56                   	push   %esi
  80006a:	68 da 21 80 00       	push   $0x8021da
  80006f:	e8 b7 02 00 00       	call   80032b <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800074:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  80007a:	83 c4 08             	add    $0x8,%esp
  80007d:	6b c6 7c             	imul   $0x7c,%esi,%eax
  800080:	c1 f8 02             	sar    $0x2,%eax
  800083:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
  800089:	50                   	push   %eax
  80008a:	68 e5 21 80 00       	push   $0x8021e5
  80008f:	e8 97 02 00 00       	call   80032b <cprintf>
	dup(p[0], 10);
  800094:	83 c4 08             	add    $0x8,%esp
  800097:	6a 0a                	push   $0xa
  800099:	ff 75 f0             	pushl  -0x10(%ebp)
  80009c:	e8 f9 12 00 00       	call   80139a <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	6b de 7c             	imul   $0x7c,%esi,%ebx
  8000a7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000ad:	e9 92 00 00 00       	jmp    800144 <umain+0x111>
		panic("pipe: %e", r);
  8000b2:	50                   	push   %eax
  8000b3:	68 99 21 80 00       	push   $0x802199
  8000b8:	6a 0d                	push   $0xd
  8000ba:	68 a2 21 80 00       	push   $0x8021a2
  8000bf:	e8 8c 01 00 00       	call   800250 <_panic>
		panic("fork: %e", r);
  8000c4:	50                   	push   %eax
  8000c5:	68 b6 21 80 00       	push   $0x8021b6
  8000ca:	6a 10                	push   $0x10
  8000cc:	68 a2 21 80 00       	push   $0x8021a2
  8000d1:	e8 7a 01 00 00       	call   800250 <_panic>
		close(p[1]);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000dc:	e8 69 12 00 00       	call   80134a <close>
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000e9:	eb 0a                	jmp    8000f5 <umain+0xc2>
			sys_yield();
  8000eb:	e8 ff 0b 00 00       	call   800cef <sys_yield>
		for (i=0; i<max; i++) {
  8000f0:	83 eb 01             	sub    $0x1,%ebx
  8000f3:	74 29                	je     80011e <umain+0xeb>
			if(pipeisclosed(p[0])){
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000fb:	e8 e5 1b 00 00       	call   801ce5 <pipeisclosed>
  800100:	83 c4 10             	add    $0x10,%esp
  800103:	85 c0                	test   %eax,%eax
  800105:	74 e4                	je     8000eb <umain+0xb8>
				cprintf("RACE: pipe appears closed\n");
  800107:	83 ec 0c             	sub    $0xc,%esp
  80010a:	68 bf 21 80 00       	push   $0x8021bf
  80010f:	e8 17 02 00 00       	call   80032b <cprintf>
				exit();
  800114:	e8 1d 01 00 00       	call   800236 <exit>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	eb cd                	jmp    8000eb <umain+0xb8>
		ipc_recv(0,0,0);
  80011e:	83 ec 04             	sub    $0x4,%esp
  800121:	6a 00                	push   $0x0
  800123:	6a 00                	push   $0x0
  800125:	6a 00                	push   $0x0
  800127:	e8 0c 10 00 00       	call   801138 <ipc_recv>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	e9 32 ff ff ff       	jmp    800066 <umain+0x33>
		dup(p[0], 10);
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	6a 0a                	push   $0xa
  800139:	ff 75 f0             	pushl  -0x10(%ebp)
  80013c:	e8 59 12 00 00       	call   80139a <dup>
  800141:	83 c4 10             	add    $0x10,%esp
	while (kid->env_status == ENV_RUNNABLE)
  800144:	8b 53 54             	mov    0x54(%ebx),%edx
  800147:	83 fa 02             	cmp    $0x2,%edx
  80014a:	74 e8                	je     800134 <umain+0x101>

	cprintf("child done with loop\n");
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	68 f0 21 80 00       	push   $0x8021f0
  800154:	e8 d2 01 00 00       	call   80032b <cprintf>
	if (pipeisclosed(p[0]))
  800159:	83 c4 04             	add    $0x4,%esp
  80015c:	ff 75 f0             	pushl  -0x10(%ebp)
  80015f:	e8 81 1b 00 00       	call   801ce5 <pipeisclosed>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	85 c0                	test   %eax,%eax
  800169:	75 48                	jne    8001b3 <umain+0x180>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800171:	50                   	push   %eax
  800172:	ff 75 f0             	pushl  -0x10(%ebp)
  800175:	e8 9b 10 00 00       	call   801215 <fd_lookup>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	85 c0                	test   %eax,%eax
  80017f:	78 46                	js     8001c7 <umain+0x194>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 ec             	pushl  -0x14(%ebp)
  800187:	e8 23 10 00 00       	call   8011af <fd2data>
	if (pageref(va) != 3+1)
  80018c:	89 04 24             	mov    %eax,(%esp)
  80018f:	e8 fc 17 00 00       	call   801990 <pageref>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	83 f8 04             	cmp    $0x4,%eax
  80019a:	74 3d                	je     8001d9 <umain+0x1a6>
		cprintf("\nchild detected race\n");
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	68 1e 22 80 00       	push   $0x80221e
  8001a4:	e8 82 01 00 00       	call   80032b <cprintf>
  8001a9:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001af:	5b                   	pop    %ebx
  8001b0:	5e                   	pop    %esi
  8001b1:	5d                   	pop    %ebp
  8001b2:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001b3:	83 ec 04             	sub    $0x4,%esp
  8001b6:	68 4c 22 80 00       	push   $0x80224c
  8001bb:	6a 3a                	push   $0x3a
  8001bd:	68 a2 21 80 00       	push   $0x8021a2
  8001c2:	e8 89 00 00 00       	call   800250 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c7:	50                   	push   %eax
  8001c8:	68 06 22 80 00       	push   $0x802206
  8001cd:	6a 3c                	push   $0x3c
  8001cf:	68 a2 21 80 00       	push   $0x8021a2
  8001d4:	e8 77 00 00 00       	call   800250 <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	68 c8 00 00 00       	push   $0xc8
  8001e1:	68 34 22 80 00       	push   $0x802234
  8001e6:	e8 40 01 00 00       	call   80032b <cprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
}
  8001ee:	eb bc                	jmp    8001ac <umain+0x179>

008001f0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
  8001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001f8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001fb:	e8 d0 0a 00 00       	call   800cd0 <sys_getenvid>
  800200:	25 ff 03 00 00       	and    $0x3ff,%eax
  800205:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800208:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020d:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800212:	85 db                	test   %ebx,%ebx
  800214:	7e 07                	jle    80021d <libmain+0x2d>
		binaryname = argv[0];
  800216:	8b 06                	mov    (%esi),%eax
  800218:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	56                   	push   %esi
  800221:	53                   	push   %ebx
  800222:	e8 0c fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800227:	e8 0a 00 00 00       	call   800236 <exit>
}
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800232:	5b                   	pop    %ebx
  800233:	5e                   	pop    %esi
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    

00800236 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80023c:	e8 34 11 00 00       	call   801375 <close_all>
	sys_env_destroy(0);
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	6a 00                	push   $0x0
  800246:	e8 44 0a 00 00       	call   800c8f <sys_env_destroy>
}
  80024b:	83 c4 10             	add    $0x10,%esp
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	56                   	push   %esi
  800254:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800255:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800258:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80025e:	e8 6d 0a 00 00       	call   800cd0 <sys_getenvid>
  800263:	83 ec 0c             	sub    $0xc,%esp
  800266:	ff 75 0c             	pushl  0xc(%ebp)
  800269:	ff 75 08             	pushl  0x8(%ebp)
  80026c:	56                   	push   %esi
  80026d:	50                   	push   %eax
  80026e:	68 80 22 80 00       	push   $0x802280
  800273:	e8 b3 00 00 00       	call   80032b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800278:	83 c4 18             	add    $0x18,%esp
  80027b:	53                   	push   %ebx
  80027c:	ff 75 10             	pushl  0x10(%ebp)
  80027f:	e8 56 00 00 00       	call   8002da <vcprintf>
	cprintf("\n");
  800284:	c7 04 24 97 21 80 00 	movl   $0x802197,(%esp)
  80028b:	e8 9b 00 00 00       	call   80032b <cprintf>
  800290:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800293:	cc                   	int3   
  800294:	eb fd                	jmp    800293 <_panic+0x43>

00800296 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	53                   	push   %ebx
  80029a:	83 ec 04             	sub    $0x4,%esp
  80029d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002a0:	8b 13                	mov    (%ebx),%edx
  8002a2:	8d 42 01             	lea    0x1(%edx),%eax
  8002a5:	89 03                	mov    %eax,(%ebx)
  8002a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b3:	74 09                	je     8002be <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002bc:	c9                   	leave  
  8002bd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	68 ff 00 00 00       	push   $0xff
  8002c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c9:	50                   	push   %eax
  8002ca:	e8 83 09 00 00       	call   800c52 <sys_cputs>
		b->idx = 0;
  8002cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002d5:	83 c4 10             	add    $0x10,%esp
  8002d8:	eb db                	jmp    8002b5 <putch+0x1f>

008002da <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ea:	00 00 00 
	b.cnt = 0;
  8002ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f7:	ff 75 0c             	pushl  0xc(%ebp)
  8002fa:	ff 75 08             	pushl  0x8(%ebp)
  8002fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800303:	50                   	push   %eax
  800304:	68 96 02 80 00       	push   $0x800296
  800309:	e8 1a 01 00 00       	call   800428 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80030e:	83 c4 08             	add    $0x8,%esp
  800311:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800317:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80031d:	50                   	push   %eax
  80031e:	e8 2f 09 00 00       	call   800c52 <sys_cputs>

	return b.cnt;
}
  800323:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800331:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800334:	50                   	push   %eax
  800335:	ff 75 08             	pushl  0x8(%ebp)
  800338:	e8 9d ff ff ff       	call   8002da <vcprintf>
	va_end(ap);

	return cnt;
}
  80033d:	c9                   	leave  
  80033e:	c3                   	ret    

0080033f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	57                   	push   %edi
  800343:	56                   	push   %esi
  800344:	53                   	push   %ebx
  800345:	83 ec 1c             	sub    $0x1c,%esp
  800348:	89 c7                	mov    %eax,%edi
  80034a:	89 d6                	mov    %edx,%esi
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800352:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800355:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800358:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80035b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800360:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800363:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800366:	39 d3                	cmp    %edx,%ebx
  800368:	72 05                	jb     80036f <printnum+0x30>
  80036a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80036d:	77 7a                	ja     8003e9 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	ff 75 18             	pushl  0x18(%ebp)
  800375:	8b 45 14             	mov    0x14(%ebp),%eax
  800378:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80037b:	53                   	push   %ebx
  80037c:	ff 75 10             	pushl  0x10(%ebp)
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 e4             	pushl  -0x1c(%ebp)
  800385:	ff 75 e0             	pushl  -0x20(%ebp)
  800388:	ff 75 dc             	pushl  -0x24(%ebp)
  80038b:	ff 75 d8             	pushl  -0x28(%ebp)
  80038e:	e8 9d 1b 00 00       	call   801f30 <__udivdi3>
  800393:	83 c4 18             	add    $0x18,%esp
  800396:	52                   	push   %edx
  800397:	50                   	push   %eax
  800398:	89 f2                	mov    %esi,%edx
  80039a:	89 f8                	mov    %edi,%eax
  80039c:	e8 9e ff ff ff       	call   80033f <printnum>
  8003a1:	83 c4 20             	add    $0x20,%esp
  8003a4:	eb 13                	jmp    8003b9 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	56                   	push   %esi
  8003aa:	ff 75 18             	pushl  0x18(%ebp)
  8003ad:	ff d7                	call   *%edi
  8003af:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003b2:	83 eb 01             	sub    $0x1,%ebx
  8003b5:	85 db                	test   %ebx,%ebx
  8003b7:	7f ed                	jg     8003a6 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	56                   	push   %esi
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8003cc:	e8 7f 1c 00 00       	call   802050 <__umoddi3>
  8003d1:	83 c4 14             	add    $0x14,%esp
  8003d4:	0f be 80 a3 22 80 00 	movsbl 0x8022a3(%eax),%eax
  8003db:	50                   	push   %eax
  8003dc:	ff d7                	call   *%edi
}
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e4:	5b                   	pop    %ebx
  8003e5:	5e                   	pop    %esi
  8003e6:	5f                   	pop    %edi
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    
  8003e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003ec:	eb c4                	jmp    8003b2 <printnum+0x73>

008003ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8003fd:	73 0a                	jae    800409 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800402:	89 08                	mov    %ecx,(%eax)
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	88 02                	mov    %al,(%edx)
}
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <printfmt>:
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800411:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800414:	50                   	push   %eax
  800415:	ff 75 10             	pushl  0x10(%ebp)
  800418:	ff 75 0c             	pushl  0xc(%ebp)
  80041b:	ff 75 08             	pushl  0x8(%ebp)
  80041e:	e8 05 00 00 00       	call   800428 <vprintfmt>
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	c9                   	leave  
  800427:	c3                   	ret    

00800428 <vprintfmt>:
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
  80042b:	57                   	push   %edi
  80042c:	56                   	push   %esi
  80042d:	53                   	push   %ebx
  80042e:	83 ec 2c             	sub    $0x2c,%esp
  800431:	8b 75 08             	mov    0x8(%ebp),%esi
  800434:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800437:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043a:	e9 8c 03 00 00       	jmp    8007cb <vprintfmt+0x3a3>
		padc = ' ';
  80043f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800443:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80044a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800451:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800458:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045d:	8d 47 01             	lea    0x1(%edi),%eax
  800460:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800463:	0f b6 17             	movzbl (%edi),%edx
  800466:	8d 42 dd             	lea    -0x23(%edx),%eax
  800469:	3c 55                	cmp    $0x55,%al
  80046b:	0f 87 dd 03 00 00    	ja     80084e <vprintfmt+0x426>
  800471:	0f b6 c0             	movzbl %al,%eax
  800474:	ff 24 85 e0 23 80 00 	jmp    *0x8023e0(,%eax,4)
  80047b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80047e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800482:	eb d9                	jmp    80045d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800484:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800487:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80048b:	eb d0                	jmp    80045d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80048d:	0f b6 d2             	movzbl %dl,%edx
  800490:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80049b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a8:	83 f9 09             	cmp    $0x9,%ecx
  8004ab:	77 55                	ja     800502 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8004ad:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004b0:	eb e9                	jmp    80049b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 40 04             	lea    0x4(%eax),%eax
  8004c0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ca:	79 91                	jns    80045d <vprintfmt+0x35>
				width = precision, precision = -1;
  8004cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004d9:	eb 82                	jmp    80045d <vprintfmt+0x35>
  8004db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004de:	85 c0                	test   %eax,%eax
  8004e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e5:	0f 49 d0             	cmovns %eax,%edx
  8004e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ee:	e9 6a ff ff ff       	jmp    80045d <vprintfmt+0x35>
  8004f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004fd:	e9 5b ff ff ff       	jmp    80045d <vprintfmt+0x35>
  800502:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800505:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800508:	eb bc                	jmp    8004c6 <vprintfmt+0x9e>
			lflag++;
  80050a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80050d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800510:	e9 48 ff ff ff       	jmp    80045d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	8d 78 04             	lea    0x4(%eax),%edi
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	53                   	push   %ebx
  80051f:	ff 30                	pushl  (%eax)
  800521:	ff d6                	call   *%esi
			break;
  800523:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800526:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800529:	e9 9a 02 00 00       	jmp    8007c8 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8d 78 04             	lea    0x4(%eax),%edi
  800534:	8b 00                	mov    (%eax),%eax
  800536:	99                   	cltd   
  800537:	31 d0                	xor    %edx,%eax
  800539:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80053b:	83 f8 0f             	cmp    $0xf,%eax
  80053e:	7f 23                	jg     800563 <vprintfmt+0x13b>
  800540:	8b 14 85 40 25 80 00 	mov    0x802540(,%eax,4),%edx
  800547:	85 d2                	test   %edx,%edx
  800549:	74 18                	je     800563 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80054b:	52                   	push   %edx
  80054c:	68 69 27 80 00       	push   $0x802769
  800551:	53                   	push   %ebx
  800552:	56                   	push   %esi
  800553:	e8 b3 fe ff ff       	call   80040b <printfmt>
  800558:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055e:	e9 65 02 00 00       	jmp    8007c8 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800563:	50                   	push   %eax
  800564:	68 bb 22 80 00       	push   $0x8022bb
  800569:	53                   	push   %ebx
  80056a:	56                   	push   %esi
  80056b:	e8 9b fe ff ff       	call   80040b <printfmt>
  800570:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800573:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800576:	e9 4d 02 00 00       	jmp    8007c8 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	83 c0 04             	add    $0x4,%eax
  800581:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800589:	85 ff                	test   %edi,%edi
  80058b:	b8 b4 22 80 00       	mov    $0x8022b4,%eax
  800590:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800593:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800597:	0f 8e bd 00 00 00    	jle    80065a <vprintfmt+0x232>
  80059d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005a1:	75 0e                	jne    8005b1 <vprintfmt+0x189>
  8005a3:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005ac:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005af:	eb 6d                	jmp    80061e <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	ff 75 d0             	pushl  -0x30(%ebp)
  8005b7:	57                   	push   %edi
  8005b8:	e8 39 03 00 00       	call   8008f6 <strnlen>
  8005bd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005c0:	29 c1                	sub    %eax,%ecx
  8005c2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005c5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005c8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005cf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005d2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d4:	eb 0f                	jmp    8005e5 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	53                   	push   %ebx
  8005da:	ff 75 e0             	pushl  -0x20(%ebp)
  8005dd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005df:	83 ef 01             	sub    $0x1,%edi
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	85 ff                	test   %edi,%edi
  8005e7:	7f ed                	jg     8005d6 <vprintfmt+0x1ae>
  8005e9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005ec:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005ef:	85 c9                	test   %ecx,%ecx
  8005f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f6:	0f 49 c1             	cmovns %ecx,%eax
  8005f9:	29 c1                	sub    %eax,%ecx
  8005fb:	89 75 08             	mov    %esi,0x8(%ebp)
  8005fe:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800601:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800604:	89 cb                	mov    %ecx,%ebx
  800606:	eb 16                	jmp    80061e <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800608:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80060c:	75 31                	jne    80063f <vprintfmt+0x217>
					putch(ch, putdat);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	ff 55 08             	call   *0x8(%ebp)
  800618:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061b:	83 eb 01             	sub    $0x1,%ebx
  80061e:	83 c7 01             	add    $0x1,%edi
  800621:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800625:	0f be c2             	movsbl %dl,%eax
  800628:	85 c0                	test   %eax,%eax
  80062a:	74 59                	je     800685 <vprintfmt+0x25d>
  80062c:	85 f6                	test   %esi,%esi
  80062e:	78 d8                	js     800608 <vprintfmt+0x1e0>
  800630:	83 ee 01             	sub    $0x1,%esi
  800633:	79 d3                	jns    800608 <vprintfmt+0x1e0>
  800635:	89 df                	mov    %ebx,%edi
  800637:	8b 75 08             	mov    0x8(%ebp),%esi
  80063a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80063d:	eb 37                	jmp    800676 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80063f:	0f be d2             	movsbl %dl,%edx
  800642:	83 ea 20             	sub    $0x20,%edx
  800645:	83 fa 5e             	cmp    $0x5e,%edx
  800648:	76 c4                	jbe    80060e <vprintfmt+0x1e6>
					putch('?', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	6a 3f                	push   $0x3f
  800652:	ff 55 08             	call   *0x8(%ebp)
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	eb c1                	jmp    80061b <vprintfmt+0x1f3>
  80065a:	89 75 08             	mov    %esi,0x8(%ebp)
  80065d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800660:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800663:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800666:	eb b6                	jmp    80061e <vprintfmt+0x1f6>
				putch(' ', putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	53                   	push   %ebx
  80066c:	6a 20                	push   $0x20
  80066e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800670:	83 ef 01             	sub    $0x1,%edi
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	85 ff                	test   %edi,%edi
  800678:	7f ee                	jg     800668 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80067a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80067d:	89 45 14             	mov    %eax,0x14(%ebp)
  800680:	e9 43 01 00 00       	jmp    8007c8 <vprintfmt+0x3a0>
  800685:	89 df                	mov    %ebx,%edi
  800687:	8b 75 08             	mov    0x8(%ebp),%esi
  80068a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80068d:	eb e7                	jmp    800676 <vprintfmt+0x24e>
	if (lflag >= 2)
  80068f:	83 f9 01             	cmp    $0x1,%ecx
  800692:	7e 3f                	jle    8006d3 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 50 04             	mov    0x4(%eax),%edx
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8d 40 08             	lea    0x8(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006af:	79 5c                	jns    80070d <vprintfmt+0x2e5>
				putch('-', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	6a 2d                	push   $0x2d
  8006b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006bf:	f7 da                	neg    %edx
  8006c1:	83 d1 00             	adc    $0x0,%ecx
  8006c4:	f7 d9                	neg    %ecx
  8006c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ce:	e9 db 00 00 00       	jmp    8007ae <vprintfmt+0x386>
	else if (lflag)
  8006d3:	85 c9                	test   %ecx,%ecx
  8006d5:	75 1b                	jne    8006f2 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	89 c1                	mov    %eax,%ecx
  8006e1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 40 04             	lea    0x4(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f0:	eb b9                	jmp    8006ab <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fa:	89 c1                	mov    %eax,%ecx
  8006fc:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ff:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 04             	lea    0x4(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
  80070b:	eb 9e                	jmp    8006ab <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80070d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800710:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800713:	b8 0a 00 00 00       	mov    $0xa,%eax
  800718:	e9 91 00 00 00       	jmp    8007ae <vprintfmt+0x386>
	if (lflag >= 2)
  80071d:	83 f9 01             	cmp    $0x1,%ecx
  800720:	7e 15                	jle    800737 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 10                	mov    (%eax),%edx
  800727:	8b 48 04             	mov    0x4(%eax),%ecx
  80072a:	8d 40 08             	lea    0x8(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800730:	b8 0a 00 00 00       	mov    $0xa,%eax
  800735:	eb 77                	jmp    8007ae <vprintfmt+0x386>
	else if (lflag)
  800737:	85 c9                	test   %ecx,%ecx
  800739:	75 17                	jne    800752 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	b9 00 00 00 00       	mov    $0x0,%ecx
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800750:	eb 5c                	jmp    8007ae <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 10                	mov    (%eax),%edx
  800757:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075c:	8d 40 04             	lea    0x4(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800762:	b8 0a 00 00 00       	mov    $0xa,%eax
  800767:	eb 45                	jmp    8007ae <vprintfmt+0x386>
			putch('X', putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	53                   	push   %ebx
  80076d:	6a 58                	push   $0x58
  80076f:	ff d6                	call   *%esi
			putch('X', putdat);
  800771:	83 c4 08             	add    $0x8,%esp
  800774:	53                   	push   %ebx
  800775:	6a 58                	push   $0x58
  800777:	ff d6                	call   *%esi
			putch('X', putdat);
  800779:	83 c4 08             	add    $0x8,%esp
  80077c:	53                   	push   %ebx
  80077d:	6a 58                	push   $0x58
  80077f:	ff d6                	call   *%esi
			break;
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	eb 42                	jmp    8007c8 <vprintfmt+0x3a0>
			putch('0', putdat);
  800786:	83 ec 08             	sub    $0x8,%esp
  800789:	53                   	push   %ebx
  80078a:	6a 30                	push   $0x30
  80078c:	ff d6                	call   *%esi
			putch('x', putdat);
  80078e:	83 c4 08             	add    $0x8,%esp
  800791:	53                   	push   %ebx
  800792:	6a 78                	push   $0x78
  800794:	ff d6                	call   *%esi
			num = (unsigned long long)
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 10                	mov    (%eax),%edx
  80079b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007a0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a3:	8d 40 04             	lea    0x4(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007ae:	83 ec 0c             	sub    $0xc,%esp
  8007b1:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007b5:	57                   	push   %edi
  8007b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	51                   	push   %ecx
  8007bb:	52                   	push   %edx
  8007bc:	89 da                	mov    %ebx,%edx
  8007be:	89 f0                	mov    %esi,%eax
  8007c0:	e8 7a fb ff ff       	call   80033f <printnum>
			break;
  8007c5:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cb:	83 c7 01             	add    $0x1,%edi
  8007ce:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d2:	83 f8 25             	cmp    $0x25,%eax
  8007d5:	0f 84 64 fc ff ff    	je     80043f <vprintfmt+0x17>
			if (ch == '\0')
  8007db:	85 c0                	test   %eax,%eax
  8007dd:	0f 84 8b 00 00 00    	je     80086e <vprintfmt+0x446>
			putch(ch, putdat);
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	53                   	push   %ebx
  8007e7:	50                   	push   %eax
  8007e8:	ff d6                	call   *%esi
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	eb dc                	jmp    8007cb <vprintfmt+0x3a3>
	if (lflag >= 2)
  8007ef:	83 f9 01             	cmp    $0x1,%ecx
  8007f2:	7e 15                	jle    800809 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8b 10                	mov    (%eax),%edx
  8007f9:	8b 48 04             	mov    0x4(%eax),%ecx
  8007fc:	8d 40 08             	lea    0x8(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800802:	b8 10 00 00 00       	mov    $0x10,%eax
  800807:	eb a5                	jmp    8007ae <vprintfmt+0x386>
	else if (lflag)
  800809:	85 c9                	test   %ecx,%ecx
  80080b:	75 17                	jne    800824 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 10                	mov    (%eax),%edx
  800812:	b9 00 00 00 00       	mov    $0x0,%ecx
  800817:	8d 40 04             	lea    0x4(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081d:	b8 10 00 00 00       	mov    $0x10,%eax
  800822:	eb 8a                	jmp    8007ae <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 10                	mov    (%eax),%edx
  800829:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082e:	8d 40 04             	lea    0x4(%eax),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800834:	b8 10 00 00 00       	mov    $0x10,%eax
  800839:	e9 70 ff ff ff       	jmp    8007ae <vprintfmt+0x386>
			putch(ch, putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	53                   	push   %ebx
  800842:	6a 25                	push   $0x25
  800844:	ff d6                	call   *%esi
			break;
  800846:	83 c4 10             	add    $0x10,%esp
  800849:	e9 7a ff ff ff       	jmp    8007c8 <vprintfmt+0x3a0>
			putch('%', putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	53                   	push   %ebx
  800852:	6a 25                	push   $0x25
  800854:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800856:	83 c4 10             	add    $0x10,%esp
  800859:	89 f8                	mov    %edi,%eax
  80085b:	eb 03                	jmp    800860 <vprintfmt+0x438>
  80085d:	83 e8 01             	sub    $0x1,%eax
  800860:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800864:	75 f7                	jne    80085d <vprintfmt+0x435>
  800866:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800869:	e9 5a ff ff ff       	jmp    8007c8 <vprintfmt+0x3a0>
}
  80086e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800871:	5b                   	pop    %ebx
  800872:	5e                   	pop    %esi
  800873:	5f                   	pop    %edi
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    

00800876 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	83 ec 18             	sub    $0x18,%esp
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800882:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800885:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800889:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80088c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800893:	85 c0                	test   %eax,%eax
  800895:	74 26                	je     8008bd <vsnprintf+0x47>
  800897:	85 d2                	test   %edx,%edx
  800899:	7e 22                	jle    8008bd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80089b:	ff 75 14             	pushl  0x14(%ebp)
  80089e:	ff 75 10             	pushl  0x10(%ebp)
  8008a1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a4:	50                   	push   %eax
  8008a5:	68 ee 03 80 00       	push   $0x8003ee
  8008aa:	e8 79 fb ff ff       	call   800428 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b8:	83 c4 10             	add    $0x10,%esp
}
  8008bb:	c9                   	leave  
  8008bc:	c3                   	ret    
		return -E_INVAL;
  8008bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c2:	eb f7                	jmp    8008bb <vsnprintf+0x45>

008008c4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ca:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008cd:	50                   	push   %eax
  8008ce:	ff 75 10             	pushl  0x10(%ebp)
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	ff 75 08             	pushl  0x8(%ebp)
  8008d7:	e8 9a ff ff ff       	call   800876 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008dc:	c9                   	leave  
  8008dd:	c3                   	ret    

008008de <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e9:	eb 03                	jmp    8008ee <strlen+0x10>
		n++;
  8008eb:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008ee:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008f2:	75 f7                	jne    8008eb <strlen+0xd>
	return n;
}
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800904:	eb 03                	jmp    800909 <strnlen+0x13>
		n++;
  800906:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800909:	39 d0                	cmp    %edx,%eax
  80090b:	74 06                	je     800913 <strnlen+0x1d>
  80090d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800911:	75 f3                	jne    800906 <strnlen+0x10>
	return n;
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	53                   	push   %ebx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80091f:	89 c2                	mov    %eax,%edx
  800921:	83 c1 01             	add    $0x1,%ecx
  800924:	83 c2 01             	add    $0x1,%edx
  800927:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80092b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80092e:	84 db                	test   %bl,%bl
  800930:	75 ef                	jne    800921 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800932:	5b                   	pop    %ebx
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	53                   	push   %ebx
  800939:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80093c:	53                   	push   %ebx
  80093d:	e8 9c ff ff ff       	call   8008de <strlen>
  800942:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	01 d8                	add    %ebx,%eax
  80094a:	50                   	push   %eax
  80094b:	e8 c5 ff ff ff       	call   800915 <strcpy>
	return dst;
}
  800950:	89 d8                	mov    %ebx,%eax
  800952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800955:	c9                   	leave  
  800956:	c3                   	ret    

00800957 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	56                   	push   %esi
  80095b:	53                   	push   %ebx
  80095c:	8b 75 08             	mov    0x8(%ebp),%esi
  80095f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800962:	89 f3                	mov    %esi,%ebx
  800964:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800967:	89 f2                	mov    %esi,%edx
  800969:	eb 0f                	jmp    80097a <strncpy+0x23>
		*dst++ = *src;
  80096b:	83 c2 01             	add    $0x1,%edx
  80096e:	0f b6 01             	movzbl (%ecx),%eax
  800971:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800974:	80 39 01             	cmpb   $0x1,(%ecx)
  800977:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80097a:	39 da                	cmp    %ebx,%edx
  80097c:	75 ed                	jne    80096b <strncpy+0x14>
	}
	return ret;
}
  80097e:	89 f0                	mov    %esi,%eax
  800980:	5b                   	pop    %ebx
  800981:	5e                   	pop    %esi
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	8b 75 08             	mov    0x8(%ebp),%esi
  80098c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800992:	89 f0                	mov    %esi,%eax
  800994:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800998:	85 c9                	test   %ecx,%ecx
  80099a:	75 0b                	jne    8009a7 <strlcpy+0x23>
  80099c:	eb 17                	jmp    8009b5 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80099e:	83 c2 01             	add    $0x1,%edx
  8009a1:	83 c0 01             	add    $0x1,%eax
  8009a4:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009a7:	39 d8                	cmp    %ebx,%eax
  8009a9:	74 07                	je     8009b2 <strlcpy+0x2e>
  8009ab:	0f b6 0a             	movzbl (%edx),%ecx
  8009ae:	84 c9                	test   %cl,%cl
  8009b0:	75 ec                	jne    80099e <strlcpy+0x1a>
		*dst = '\0';
  8009b2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009b5:	29 f0                	sub    %esi,%eax
}
  8009b7:	5b                   	pop    %ebx
  8009b8:	5e                   	pop    %esi
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c4:	eb 06                	jmp    8009cc <strcmp+0x11>
		p++, q++;
  8009c6:	83 c1 01             	add    $0x1,%ecx
  8009c9:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009cc:	0f b6 01             	movzbl (%ecx),%eax
  8009cf:	84 c0                	test   %al,%al
  8009d1:	74 04                	je     8009d7 <strcmp+0x1c>
  8009d3:	3a 02                	cmp    (%edx),%al
  8009d5:	74 ef                	je     8009c6 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d7:	0f b6 c0             	movzbl %al,%eax
  8009da:	0f b6 12             	movzbl (%edx),%edx
  8009dd:	29 d0                	sub    %edx,%eax
}
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	53                   	push   %ebx
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009eb:	89 c3                	mov    %eax,%ebx
  8009ed:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f0:	eb 06                	jmp    8009f8 <strncmp+0x17>
		n--, p++, q++;
  8009f2:	83 c0 01             	add    $0x1,%eax
  8009f5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f8:	39 d8                	cmp    %ebx,%eax
  8009fa:	74 16                	je     800a12 <strncmp+0x31>
  8009fc:	0f b6 08             	movzbl (%eax),%ecx
  8009ff:	84 c9                	test   %cl,%cl
  800a01:	74 04                	je     800a07 <strncmp+0x26>
  800a03:	3a 0a                	cmp    (%edx),%cl
  800a05:	74 eb                	je     8009f2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a07:	0f b6 00             	movzbl (%eax),%eax
  800a0a:	0f b6 12             	movzbl (%edx),%edx
  800a0d:	29 d0                	sub    %edx,%eax
}
  800a0f:	5b                   	pop    %ebx
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    
		return 0;
  800a12:	b8 00 00 00 00       	mov    $0x0,%eax
  800a17:	eb f6                	jmp    800a0f <strncmp+0x2e>

00800a19 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a23:	0f b6 10             	movzbl (%eax),%edx
  800a26:	84 d2                	test   %dl,%dl
  800a28:	74 09                	je     800a33 <strchr+0x1a>
		if (*s == c)
  800a2a:	38 ca                	cmp    %cl,%dl
  800a2c:	74 0a                	je     800a38 <strchr+0x1f>
	for (; *s; s++)
  800a2e:	83 c0 01             	add    $0x1,%eax
  800a31:	eb f0                	jmp    800a23 <strchr+0xa>
			return (char *) s;
	return 0;
  800a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a44:	eb 03                	jmp    800a49 <strfind+0xf>
  800a46:	83 c0 01             	add    $0x1,%eax
  800a49:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a4c:	38 ca                	cmp    %cl,%dl
  800a4e:	74 04                	je     800a54 <strfind+0x1a>
  800a50:	84 d2                	test   %dl,%dl
  800a52:	75 f2                	jne    800a46 <strfind+0xc>
			break;
	return (char *) s;
}
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	57                   	push   %edi
  800a5a:	56                   	push   %esi
  800a5b:	53                   	push   %ebx
  800a5c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a62:	85 c9                	test   %ecx,%ecx
  800a64:	74 13                	je     800a79 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a66:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a6c:	75 05                	jne    800a73 <memset+0x1d>
  800a6e:	f6 c1 03             	test   $0x3,%cl
  800a71:	74 0d                	je     800a80 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a76:	fc                   	cld    
  800a77:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a79:	89 f8                	mov    %edi,%eax
  800a7b:	5b                   	pop    %ebx
  800a7c:	5e                   	pop    %esi
  800a7d:	5f                   	pop    %edi
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    
		c &= 0xFF;
  800a80:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a84:	89 d3                	mov    %edx,%ebx
  800a86:	c1 e3 08             	shl    $0x8,%ebx
  800a89:	89 d0                	mov    %edx,%eax
  800a8b:	c1 e0 18             	shl    $0x18,%eax
  800a8e:	89 d6                	mov    %edx,%esi
  800a90:	c1 e6 10             	shl    $0x10,%esi
  800a93:	09 f0                	or     %esi,%eax
  800a95:	09 c2                	or     %eax,%edx
  800a97:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a99:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a9c:	89 d0                	mov    %edx,%eax
  800a9e:	fc                   	cld    
  800a9f:	f3 ab                	rep stos %eax,%es:(%edi)
  800aa1:	eb d6                	jmp    800a79 <memset+0x23>

00800aa3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	57                   	push   %edi
  800aa7:	56                   	push   %esi
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ab1:	39 c6                	cmp    %eax,%esi
  800ab3:	73 35                	jae    800aea <memmove+0x47>
  800ab5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab8:	39 c2                	cmp    %eax,%edx
  800aba:	76 2e                	jbe    800aea <memmove+0x47>
		s += n;
		d += n;
  800abc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abf:	89 d6                	mov    %edx,%esi
  800ac1:	09 fe                	or     %edi,%esi
  800ac3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac9:	74 0c                	je     800ad7 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800acb:	83 ef 01             	sub    $0x1,%edi
  800ace:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ad1:	fd                   	std    
  800ad2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ad4:	fc                   	cld    
  800ad5:	eb 21                	jmp    800af8 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad7:	f6 c1 03             	test   $0x3,%cl
  800ada:	75 ef                	jne    800acb <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800adc:	83 ef 04             	sub    $0x4,%edi
  800adf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ae2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ae5:	fd                   	std    
  800ae6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae8:	eb ea                	jmp    800ad4 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aea:	89 f2                	mov    %esi,%edx
  800aec:	09 c2                	or     %eax,%edx
  800aee:	f6 c2 03             	test   $0x3,%dl
  800af1:	74 09                	je     800afc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800af3:	89 c7                	mov    %eax,%edi
  800af5:	fc                   	cld    
  800af6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af8:	5e                   	pop    %esi
  800af9:	5f                   	pop    %edi
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afc:	f6 c1 03             	test   $0x3,%cl
  800aff:	75 f2                	jne    800af3 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b01:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b04:	89 c7                	mov    %eax,%edi
  800b06:	fc                   	cld    
  800b07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b09:	eb ed                	jmp    800af8 <memmove+0x55>

00800b0b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b0e:	ff 75 10             	pushl  0x10(%ebp)
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	ff 75 08             	pushl  0x8(%ebp)
  800b17:	e8 87 ff ff ff       	call   800aa3 <memmove>
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	56                   	push   %esi
  800b22:	53                   	push   %ebx
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 c6                	mov    %eax,%esi
  800b2b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b2e:	39 f0                	cmp    %esi,%eax
  800b30:	74 1c                	je     800b4e <memcmp+0x30>
		if (*s1 != *s2)
  800b32:	0f b6 08             	movzbl (%eax),%ecx
  800b35:	0f b6 1a             	movzbl (%edx),%ebx
  800b38:	38 d9                	cmp    %bl,%cl
  800b3a:	75 08                	jne    800b44 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b3c:	83 c0 01             	add    $0x1,%eax
  800b3f:	83 c2 01             	add    $0x1,%edx
  800b42:	eb ea                	jmp    800b2e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b44:	0f b6 c1             	movzbl %cl,%eax
  800b47:	0f b6 db             	movzbl %bl,%ebx
  800b4a:	29 d8                	sub    %ebx,%eax
  800b4c:	eb 05                	jmp    800b53 <memcmp+0x35>
	}

	return 0;
  800b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b53:	5b                   	pop    %ebx
  800b54:	5e                   	pop    %esi
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b60:	89 c2                	mov    %eax,%edx
  800b62:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b65:	39 d0                	cmp    %edx,%eax
  800b67:	73 09                	jae    800b72 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b69:	38 08                	cmp    %cl,(%eax)
  800b6b:	74 05                	je     800b72 <memfind+0x1b>
	for (; s < ends; s++)
  800b6d:	83 c0 01             	add    $0x1,%eax
  800b70:	eb f3                	jmp    800b65 <memfind+0xe>
			break;
	return (void *) s;
}
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
  800b7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b80:	eb 03                	jmp    800b85 <strtol+0x11>
		s++;
  800b82:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b85:	0f b6 01             	movzbl (%ecx),%eax
  800b88:	3c 20                	cmp    $0x20,%al
  800b8a:	74 f6                	je     800b82 <strtol+0xe>
  800b8c:	3c 09                	cmp    $0x9,%al
  800b8e:	74 f2                	je     800b82 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b90:	3c 2b                	cmp    $0x2b,%al
  800b92:	74 2e                	je     800bc2 <strtol+0x4e>
	int neg = 0;
  800b94:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b99:	3c 2d                	cmp    $0x2d,%al
  800b9b:	74 2f                	je     800bcc <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ba3:	75 05                	jne    800baa <strtol+0x36>
  800ba5:	80 39 30             	cmpb   $0x30,(%ecx)
  800ba8:	74 2c                	je     800bd6 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800baa:	85 db                	test   %ebx,%ebx
  800bac:	75 0a                	jne    800bb8 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bae:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bb3:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb6:	74 28                	je     800be0 <strtol+0x6c>
		base = 10;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bc0:	eb 50                	jmp    800c12 <strtol+0x9e>
		s++;
  800bc2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bc5:	bf 00 00 00 00       	mov    $0x0,%edi
  800bca:	eb d1                	jmp    800b9d <strtol+0x29>
		s++, neg = 1;
  800bcc:	83 c1 01             	add    $0x1,%ecx
  800bcf:	bf 01 00 00 00       	mov    $0x1,%edi
  800bd4:	eb c7                	jmp    800b9d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bda:	74 0e                	je     800bea <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bdc:	85 db                	test   %ebx,%ebx
  800bde:	75 d8                	jne    800bb8 <strtol+0x44>
		s++, base = 8;
  800be0:	83 c1 01             	add    $0x1,%ecx
  800be3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800be8:	eb ce                	jmp    800bb8 <strtol+0x44>
		s += 2, base = 16;
  800bea:	83 c1 02             	add    $0x2,%ecx
  800bed:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bf2:	eb c4                	jmp    800bb8 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bf4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bf7:	89 f3                	mov    %esi,%ebx
  800bf9:	80 fb 19             	cmp    $0x19,%bl
  800bfc:	77 29                	ja     800c27 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bfe:	0f be d2             	movsbl %dl,%edx
  800c01:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c04:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c07:	7d 30                	jge    800c39 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c09:	83 c1 01             	add    $0x1,%ecx
  800c0c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c10:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c12:	0f b6 11             	movzbl (%ecx),%edx
  800c15:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c18:	89 f3                	mov    %esi,%ebx
  800c1a:	80 fb 09             	cmp    $0x9,%bl
  800c1d:	77 d5                	ja     800bf4 <strtol+0x80>
			dig = *s - '0';
  800c1f:	0f be d2             	movsbl %dl,%edx
  800c22:	83 ea 30             	sub    $0x30,%edx
  800c25:	eb dd                	jmp    800c04 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c27:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c2a:	89 f3                	mov    %esi,%ebx
  800c2c:	80 fb 19             	cmp    $0x19,%bl
  800c2f:	77 08                	ja     800c39 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c31:	0f be d2             	movsbl %dl,%edx
  800c34:	83 ea 37             	sub    $0x37,%edx
  800c37:	eb cb                	jmp    800c04 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3d:	74 05                	je     800c44 <strtol+0xd0>
		*endptr = (char *) s;
  800c3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c42:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c44:	89 c2                	mov    %eax,%edx
  800c46:	f7 da                	neg    %edx
  800c48:	85 ff                	test   %edi,%edi
  800c4a:	0f 45 c2             	cmovne %edx,%eax
}
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c58:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c63:	89 c3                	mov    %eax,%ebx
  800c65:	89 c7                	mov    %eax,%edi
  800c67:	89 c6                	mov    %eax,%esi
  800c69:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5f                   	pop    %edi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    

00800c70 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	57                   	push   %edi
  800c74:	56                   	push   %esi
  800c75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c76:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c80:	89 d1                	mov    %edx,%ecx
  800c82:	89 d3                	mov    %edx,%ebx
  800c84:	89 d7                	mov    %edx,%edi
  800c86:	89 d6                	mov    %edx,%esi
  800c88:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c8a:	5b                   	pop    %ebx
  800c8b:	5e                   	pop    %esi
  800c8c:	5f                   	pop    %edi
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	57                   	push   %edi
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
  800c95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c98:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca0:	b8 03 00 00 00       	mov    $0x3,%eax
  800ca5:	89 cb                	mov    %ecx,%ebx
  800ca7:	89 cf                	mov    %ecx,%edi
  800ca9:	89 ce                	mov    %ecx,%esi
  800cab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cad:	85 c0                	test   %eax,%eax
  800caf:	7f 08                	jg     800cb9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb4:	5b                   	pop    %ebx
  800cb5:	5e                   	pop    %esi
  800cb6:	5f                   	pop    %edi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb9:	83 ec 0c             	sub    $0xc,%esp
  800cbc:	50                   	push   %eax
  800cbd:	6a 03                	push   $0x3
  800cbf:	68 9f 25 80 00       	push   $0x80259f
  800cc4:	6a 23                	push   $0x23
  800cc6:	68 bc 25 80 00       	push   $0x8025bc
  800ccb:	e8 80 f5 ff ff       	call   800250 <_panic>

00800cd0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	57                   	push   %edi
  800cd4:	56                   	push   %esi
  800cd5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdb:	b8 02 00 00 00       	mov    $0x2,%eax
  800ce0:	89 d1                	mov    %edx,%ecx
  800ce2:	89 d3                	mov    %edx,%ebx
  800ce4:	89 d7                	mov    %edx,%edi
  800ce6:	89 d6                	mov    %edx,%esi
  800ce8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cea:	5b                   	pop    %ebx
  800ceb:	5e                   	pop    %esi
  800cec:	5f                   	pop    %edi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <sys_yield>:

void
sys_yield(void)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	57                   	push   %edi
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfa:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cff:	89 d1                	mov    %edx,%ecx
  800d01:	89 d3                	mov    %edx,%ebx
  800d03:	89 d7                	mov    %edx,%edi
  800d05:	89 d6                	mov    %edx,%esi
  800d07:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
  800d14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d17:	be 00 00 00 00       	mov    $0x0,%esi
  800d1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d22:	b8 04 00 00 00       	mov    $0x4,%eax
  800d27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d2a:	89 f7                	mov    %esi,%edi
  800d2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	7f 08                	jg     800d3a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3a:	83 ec 0c             	sub    $0xc,%esp
  800d3d:	50                   	push   %eax
  800d3e:	6a 04                	push   $0x4
  800d40:	68 9f 25 80 00       	push   $0x80259f
  800d45:	6a 23                	push   $0x23
  800d47:	68 bc 25 80 00       	push   $0x8025bc
  800d4c:	e8 ff f4 ff ff       	call   800250 <_panic>

00800d51 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
  800d57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d60:	b8 05 00 00 00       	mov    $0x5,%eax
  800d65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d68:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6b:	8b 75 18             	mov    0x18(%ebp),%esi
  800d6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d70:	85 c0                	test   %eax,%eax
  800d72:	7f 08                	jg     800d7c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7c:	83 ec 0c             	sub    $0xc,%esp
  800d7f:	50                   	push   %eax
  800d80:	6a 05                	push   $0x5
  800d82:	68 9f 25 80 00       	push   $0x80259f
  800d87:	6a 23                	push   $0x23
  800d89:	68 bc 25 80 00       	push   $0x8025bc
  800d8e:	e8 bd f4 ff ff       	call   800250 <_panic>

00800d93 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da1:	8b 55 08             	mov    0x8(%ebp),%edx
  800da4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da7:	b8 06 00 00 00       	mov    $0x6,%eax
  800dac:	89 df                	mov    %ebx,%edi
  800dae:	89 de                	mov    %ebx,%esi
  800db0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	7f 08                	jg     800dbe <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbe:	83 ec 0c             	sub    $0xc,%esp
  800dc1:	50                   	push   %eax
  800dc2:	6a 06                	push   $0x6
  800dc4:	68 9f 25 80 00       	push   $0x80259f
  800dc9:	6a 23                	push   $0x23
  800dcb:	68 bc 25 80 00       	push   $0x8025bc
  800dd0:	e8 7b f4 ff ff       	call   800250 <_panic>

00800dd5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	57                   	push   %edi
  800dd9:	56                   	push   %esi
  800dda:	53                   	push   %ebx
  800ddb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dde:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de3:	8b 55 08             	mov    0x8(%ebp),%edx
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	b8 08 00 00 00       	mov    $0x8,%eax
  800dee:	89 df                	mov    %ebx,%edi
  800df0:	89 de                	mov    %ebx,%esi
  800df2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df4:	85 c0                	test   %eax,%eax
  800df6:	7f 08                	jg     800e00 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800df8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5f                   	pop    %edi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e00:	83 ec 0c             	sub    $0xc,%esp
  800e03:	50                   	push   %eax
  800e04:	6a 08                	push   $0x8
  800e06:	68 9f 25 80 00       	push   $0x80259f
  800e0b:	6a 23                	push   $0x23
  800e0d:	68 bc 25 80 00       	push   $0x8025bc
  800e12:	e8 39 f4 ff ff       	call   800250 <_panic>

00800e17 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
  800e1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e25:	8b 55 08             	mov    0x8(%ebp),%edx
  800e28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2b:	b8 09 00 00 00       	mov    $0x9,%eax
  800e30:	89 df                	mov    %ebx,%edi
  800e32:	89 de                	mov    %ebx,%esi
  800e34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e36:	85 c0                	test   %eax,%eax
  800e38:	7f 08                	jg     800e42 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3d:	5b                   	pop    %ebx
  800e3e:	5e                   	pop    %esi
  800e3f:	5f                   	pop    %edi
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e42:	83 ec 0c             	sub    $0xc,%esp
  800e45:	50                   	push   %eax
  800e46:	6a 09                	push   $0x9
  800e48:	68 9f 25 80 00       	push   $0x80259f
  800e4d:	6a 23                	push   $0x23
  800e4f:	68 bc 25 80 00       	push   $0x8025bc
  800e54:	e8 f7 f3 ff ff       	call   800250 <_panic>

00800e59 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
  800e5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e67:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e72:	89 df                	mov    %ebx,%edi
  800e74:	89 de                	mov    %ebx,%esi
  800e76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	7f 08                	jg     800e84 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7f:	5b                   	pop    %ebx
  800e80:	5e                   	pop    %esi
  800e81:	5f                   	pop    %edi
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e84:	83 ec 0c             	sub    $0xc,%esp
  800e87:	50                   	push   %eax
  800e88:	6a 0a                	push   $0xa
  800e8a:	68 9f 25 80 00       	push   $0x80259f
  800e8f:	6a 23                	push   $0x23
  800e91:	68 bc 25 80 00       	push   $0x8025bc
  800e96:	e8 b5 f3 ff ff       	call   800250 <_panic>

00800e9b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	57                   	push   %edi
  800e9f:	56                   	push   %esi
  800ea0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eac:	be 00 00 00 00       	mov    $0x0,%esi
  800eb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eb9:	5b                   	pop    %ebx
  800eba:	5e                   	pop    %esi
  800ebb:	5f                   	pop    %edi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    

00800ebe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ed4:	89 cb                	mov    %ecx,%ebx
  800ed6:	89 cf                	mov    %ecx,%edi
  800ed8:	89 ce                	mov    %ecx,%esi
  800eda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edc:	85 c0                	test   %eax,%eax
  800ede:	7f 08                	jg     800ee8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee3:	5b                   	pop    %ebx
  800ee4:	5e                   	pop    %esi
  800ee5:	5f                   	pop    %edi
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee8:	83 ec 0c             	sub    $0xc,%esp
  800eeb:	50                   	push   %eax
  800eec:	6a 0d                	push   $0xd
  800eee:	68 9f 25 80 00       	push   $0x80259f
  800ef3:	6a 23                	push   $0x23
  800ef5:	68 bc 25 80 00       	push   $0x8025bc
  800efa:	e8 51 f3 ff ff       	call   800250 <_panic>

00800eff <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800f05:	68 ca 25 80 00       	push   $0x8025ca
  800f0a:	6a 25                	push   $0x25
  800f0c:	68 e2 25 80 00       	push   $0x8025e2
  800f11:	e8 3a f3 ff ff       	call   800250 <_panic>

00800f16 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	57                   	push   %edi
  800f1a:	56                   	push   %esi
  800f1b:	53                   	push   %ebx
  800f1c:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800f1f:	68 ff 0e 80 00       	push   $0x800eff
  800f24:	e8 6c 0f 00 00       	call   801e95 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f29:	b8 07 00 00 00       	mov    $0x7,%eax
  800f2e:	cd 30                	int    $0x30
  800f30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800f36:	83 c4 10             	add    $0x10,%esp
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	78 27                	js     800f64 <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800f3d:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800f42:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f46:	75 65                	jne    800fad <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f48:	e8 83 fd ff ff       	call   800cd0 <sys_getenvid>
  800f4d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f52:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f55:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f5a:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f5f:	e9 11 01 00 00       	jmp    801075 <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800f64:	50                   	push   %eax
  800f65:	68 b6 21 80 00       	push   $0x8021b6
  800f6a:	6a 6f                	push   $0x6f
  800f6c:	68 e2 25 80 00       	push   $0x8025e2
  800f71:	e8 da f2 ff ff       	call   800250 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800f76:	e8 55 fd ff ff       	call   800cd0 <sys_getenvid>
  800f7b:	83 ec 0c             	sub    $0xc,%esp
  800f7e:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800f84:	56                   	push   %esi
  800f85:	57                   	push   %edi
  800f86:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f89:	57                   	push   %edi
  800f8a:	50                   	push   %eax
  800f8b:	e8 c1 fd ff ff       	call   800d51 <sys_page_map>
  800f90:	83 c4 20             	add    $0x20,%esp
  800f93:	85 c0                	test   %eax,%eax
  800f95:	0f 88 84 00 00 00    	js     80101f <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800f9b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800fa1:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fa7:	0f 84 84 00 00 00    	je     801031 <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800fad:	89 d8                	mov    %ebx,%eax
  800faf:	c1 e8 16             	shr    $0x16,%eax
  800fb2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fb9:	a8 01                	test   $0x1,%al
  800fbb:	74 de                	je     800f9b <fork+0x85>
  800fbd:	89 d8                	mov    %ebx,%eax
  800fbf:	c1 e8 0c             	shr    $0xc,%eax
  800fc2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fc9:	f6 c2 01             	test   $0x1,%dl
  800fcc:	74 cd                	je     800f9b <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  800fce:	89 c7                	mov    %eax,%edi
  800fd0:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  800fd3:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  800fda:	f7 c6 00 04 00 00    	test   $0x400,%esi
  800fe0:	75 94                	jne    800f76 <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  800fe2:	f7 c6 02 08 00 00    	test   $0x802,%esi
  800fe8:	0f 85 d1 00 00 00    	jne    8010bf <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800fee:	a1 04 40 80 00       	mov    0x804004,%eax
  800ff3:	8b 40 48             	mov    0x48(%eax),%eax
  800ff6:	83 ec 0c             	sub    $0xc,%esp
  800ff9:	6a 05                	push   $0x5
  800ffb:	57                   	push   %edi
  800ffc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fff:	57                   	push   %edi
  801000:	50                   	push   %eax
  801001:	e8 4b fd ff ff       	call   800d51 <sys_page_map>
  801006:	83 c4 20             	add    $0x20,%esp
  801009:	85 c0                	test   %eax,%eax
  80100b:	79 8e                	jns    800f9b <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  80100d:	50                   	push   %eax
  80100e:	68 3c 26 80 00       	push   $0x80263c
  801013:	6a 4a                	push   $0x4a
  801015:	68 e2 25 80 00       	push   $0x8025e2
  80101a:	e8 31 f2 ff ff       	call   800250 <_panic>
                        panic("duppage: page mapping failed %e", r);
  80101f:	50                   	push   %eax
  801020:	68 1c 26 80 00       	push   $0x80261c
  801025:	6a 41                	push   $0x41
  801027:	68 e2 25 80 00       	push   $0x8025e2
  80102c:	e8 1f f2 ff ff       	call   800250 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801031:	83 ec 04             	sub    $0x4,%esp
  801034:	6a 07                	push   $0x7
  801036:	68 00 f0 bf ee       	push   $0xeebff000
  80103b:	ff 75 e0             	pushl  -0x20(%ebp)
  80103e:	e8 cb fc ff ff       	call   800d0e <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  801043:	83 c4 10             	add    $0x10,%esp
  801046:	85 c0                	test   %eax,%eax
  801048:	78 36                	js     801080 <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  80104a:	83 ec 08             	sub    $0x8,%esp
  80104d:	68 09 1f 80 00       	push   $0x801f09
  801052:	ff 75 e0             	pushl  -0x20(%ebp)
  801055:	e8 ff fd ff ff       	call   800e59 <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80105a:	83 c4 10             	add    $0x10,%esp
  80105d:	85 c0                	test   %eax,%eax
  80105f:	78 34                	js     801095 <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801061:	83 ec 08             	sub    $0x8,%esp
  801064:	6a 02                	push   $0x2
  801066:	ff 75 e0             	pushl  -0x20(%ebp)
  801069:	e8 67 fd ff ff       	call   800dd5 <sys_env_set_status>
  80106e:	83 c4 10             	add    $0x10,%esp
  801071:	85 c0                	test   %eax,%eax
  801073:	78 35                	js     8010aa <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  801075:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801078:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107b:	5b                   	pop    %ebx
  80107c:	5e                   	pop    %esi
  80107d:	5f                   	pop    %edi
  80107e:	5d                   	pop    %ebp
  80107f:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  801080:	50                   	push   %eax
  801081:	68 b6 21 80 00       	push   $0x8021b6
  801086:	68 82 00 00 00       	push   $0x82
  80108b:	68 e2 25 80 00       	push   $0x8025e2
  801090:	e8 bb f1 ff ff       	call   800250 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801095:	50                   	push   %eax
  801096:	68 60 26 80 00       	push   $0x802660
  80109b:	68 87 00 00 00       	push   $0x87
  8010a0:	68 e2 25 80 00       	push   $0x8025e2
  8010a5:	e8 a6 f1 ff ff       	call   800250 <_panic>
        	panic("sys_env_set_status: %e", r);
  8010aa:	50                   	push   %eax
  8010ab:	68 ed 25 80 00       	push   $0x8025ed
  8010b0:	68 8b 00 00 00       	push   $0x8b
  8010b5:	68 e2 25 80 00       	push   $0x8025e2
  8010ba:	e8 91 f1 ff ff       	call   800250 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  8010bf:	a1 04 40 80 00       	mov    0x804004,%eax
  8010c4:	8b 40 48             	mov    0x48(%eax),%eax
  8010c7:	83 ec 0c             	sub    $0xc,%esp
  8010ca:	68 05 08 00 00       	push   $0x805
  8010cf:	57                   	push   %edi
  8010d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d3:	57                   	push   %edi
  8010d4:	50                   	push   %eax
  8010d5:	e8 77 fc ff ff       	call   800d51 <sys_page_map>
  8010da:	83 c4 20             	add    $0x20,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	0f 88 28 ff ff ff    	js     80100d <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  8010e5:	a1 04 40 80 00       	mov    0x804004,%eax
  8010ea:	8b 50 48             	mov    0x48(%eax),%edx
  8010ed:	8b 40 48             	mov    0x48(%eax),%eax
  8010f0:	83 ec 0c             	sub    $0xc,%esp
  8010f3:	68 05 08 00 00       	push   $0x805
  8010f8:	57                   	push   %edi
  8010f9:	52                   	push   %edx
  8010fa:	57                   	push   %edi
  8010fb:	50                   	push   %eax
  8010fc:	e8 50 fc ff ff       	call   800d51 <sys_page_map>
  801101:	83 c4 20             	add    $0x20,%esp
  801104:	85 c0                	test   %eax,%eax
  801106:	0f 89 8f fe ff ff    	jns    800f9b <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  80110c:	50                   	push   %eax
  80110d:	68 3c 26 80 00       	push   $0x80263c
  801112:	6a 4f                	push   $0x4f
  801114:	68 e2 25 80 00       	push   $0x8025e2
  801119:	e8 32 f1 ff ff       	call   800250 <_panic>

0080111e <sfork>:

// Challenge!
int
sfork(void)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801124:	68 04 26 80 00       	push   $0x802604
  801129:	68 94 00 00 00       	push   $0x94
  80112e:	68 e2 25 80 00       	push   $0x8025e2
  801133:	e8 18 f1 ff ff       	call   800250 <_panic>

00801138 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  80113e:	68 84 26 80 00       	push   $0x802684
  801143:	6a 1a                	push   $0x1a
  801145:	68 9d 26 80 00       	push   $0x80269d
  80114a:	e8 01 f1 ff ff       	call   800250 <_panic>

0080114f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801155:	68 a7 26 80 00       	push   $0x8026a7
  80115a:	6a 2a                	push   $0x2a
  80115c:	68 9d 26 80 00       	push   $0x80269d
  801161:	e8 ea f0 ff ff       	call   800250 <_panic>

00801166 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80116c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801171:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801174:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80117a:	8b 52 50             	mov    0x50(%edx),%edx
  80117d:	39 ca                	cmp    %ecx,%edx
  80117f:	74 11                	je     801192 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801181:	83 c0 01             	add    $0x1,%eax
  801184:	3d 00 04 00 00       	cmp    $0x400,%eax
  801189:	75 e6                	jne    801171 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80118b:	b8 00 00 00 00       	mov    $0x0,%eax
  801190:	eb 0b                	jmp    80119d <ipc_find_env+0x37>
			return envs[i].env_id;
  801192:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801195:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80119a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    

0080119f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	05 00 00 00 30       	add    $0x30000000,%eax
  8011aa:	c1 e8 0c             	shr    $0xc,%eax
}
  8011ad:	5d                   	pop    %ebp
  8011ae:	c3                   	ret    

008011af <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011bf:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    

008011c6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011d1:	89 c2                	mov    %eax,%edx
  8011d3:	c1 ea 16             	shr    $0x16,%edx
  8011d6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011dd:	f6 c2 01             	test   $0x1,%dl
  8011e0:	74 2a                	je     80120c <fd_alloc+0x46>
  8011e2:	89 c2                	mov    %eax,%edx
  8011e4:	c1 ea 0c             	shr    $0xc,%edx
  8011e7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011ee:	f6 c2 01             	test   $0x1,%dl
  8011f1:	74 19                	je     80120c <fd_alloc+0x46>
  8011f3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011f8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011fd:	75 d2                	jne    8011d1 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011ff:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801205:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80120a:	eb 07                	jmp    801213 <fd_alloc+0x4d>
			*fd_store = fd;
  80120c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80120e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80121b:	83 f8 1f             	cmp    $0x1f,%eax
  80121e:	77 36                	ja     801256 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801220:	c1 e0 0c             	shl    $0xc,%eax
  801223:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801228:	89 c2                	mov    %eax,%edx
  80122a:	c1 ea 16             	shr    $0x16,%edx
  80122d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801234:	f6 c2 01             	test   $0x1,%dl
  801237:	74 24                	je     80125d <fd_lookup+0x48>
  801239:	89 c2                	mov    %eax,%edx
  80123b:	c1 ea 0c             	shr    $0xc,%edx
  80123e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801245:	f6 c2 01             	test   $0x1,%dl
  801248:	74 1a                	je     801264 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80124a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124d:	89 02                	mov    %eax,(%edx)
	return 0;
  80124f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    
		return -E_INVAL;
  801256:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125b:	eb f7                	jmp    801254 <fd_lookup+0x3f>
		return -E_INVAL;
  80125d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801262:	eb f0                	jmp    801254 <fd_lookup+0x3f>
  801264:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801269:	eb e9                	jmp    801254 <fd_lookup+0x3f>

0080126b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801274:	ba 40 27 80 00       	mov    $0x802740,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801279:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80127e:	39 08                	cmp    %ecx,(%eax)
  801280:	74 33                	je     8012b5 <dev_lookup+0x4a>
  801282:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801285:	8b 02                	mov    (%edx),%eax
  801287:	85 c0                	test   %eax,%eax
  801289:	75 f3                	jne    80127e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80128b:	a1 04 40 80 00       	mov    0x804004,%eax
  801290:	8b 40 48             	mov    0x48(%eax),%eax
  801293:	83 ec 04             	sub    $0x4,%esp
  801296:	51                   	push   %ecx
  801297:	50                   	push   %eax
  801298:	68 c0 26 80 00       	push   $0x8026c0
  80129d:	e8 89 f0 ff ff       	call   80032b <cprintf>
	*dev = 0;
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012ab:	83 c4 10             	add    $0x10,%esp
  8012ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    
			*dev = devtab[i];
  8012b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bf:	eb f2                	jmp    8012b3 <dev_lookup+0x48>

008012c1 <fd_close>:
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	57                   	push   %edi
  8012c5:	56                   	push   %esi
  8012c6:	53                   	push   %ebx
  8012c7:	83 ec 1c             	sub    $0x1c,%esp
  8012ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8012cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012d3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012d4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012da:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012dd:	50                   	push   %eax
  8012de:	e8 32 ff ff ff       	call   801215 <fd_lookup>
  8012e3:	89 c3                	mov    %eax,%ebx
  8012e5:	83 c4 08             	add    $0x8,%esp
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	78 05                	js     8012f1 <fd_close+0x30>
	    || fd != fd2)
  8012ec:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012ef:	74 16                	je     801307 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012f1:	89 f8                	mov    %edi,%eax
  8012f3:	84 c0                	test   %al,%al
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fa:	0f 44 d8             	cmove  %eax,%ebx
}
  8012fd:	89 d8                	mov    %ebx,%eax
  8012ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801302:	5b                   	pop    %ebx
  801303:	5e                   	pop    %esi
  801304:	5f                   	pop    %edi
  801305:	5d                   	pop    %ebp
  801306:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801307:	83 ec 08             	sub    $0x8,%esp
  80130a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80130d:	50                   	push   %eax
  80130e:	ff 36                	pushl  (%esi)
  801310:	e8 56 ff ff ff       	call   80126b <dev_lookup>
  801315:	89 c3                	mov    %eax,%ebx
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	85 c0                	test   %eax,%eax
  80131c:	78 15                	js     801333 <fd_close+0x72>
		if (dev->dev_close)
  80131e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801321:	8b 40 10             	mov    0x10(%eax),%eax
  801324:	85 c0                	test   %eax,%eax
  801326:	74 1b                	je     801343 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801328:	83 ec 0c             	sub    $0xc,%esp
  80132b:	56                   	push   %esi
  80132c:	ff d0                	call   *%eax
  80132e:	89 c3                	mov    %eax,%ebx
  801330:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801333:	83 ec 08             	sub    $0x8,%esp
  801336:	56                   	push   %esi
  801337:	6a 00                	push   $0x0
  801339:	e8 55 fa ff ff       	call   800d93 <sys_page_unmap>
	return r;
  80133e:	83 c4 10             	add    $0x10,%esp
  801341:	eb ba                	jmp    8012fd <fd_close+0x3c>
			r = 0;
  801343:	bb 00 00 00 00       	mov    $0x0,%ebx
  801348:	eb e9                	jmp    801333 <fd_close+0x72>

0080134a <close>:

int
close(int fdnum)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801350:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801353:	50                   	push   %eax
  801354:	ff 75 08             	pushl  0x8(%ebp)
  801357:	e8 b9 fe ff ff       	call   801215 <fd_lookup>
  80135c:	83 c4 08             	add    $0x8,%esp
  80135f:	85 c0                	test   %eax,%eax
  801361:	78 10                	js     801373 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801363:	83 ec 08             	sub    $0x8,%esp
  801366:	6a 01                	push   $0x1
  801368:	ff 75 f4             	pushl  -0xc(%ebp)
  80136b:	e8 51 ff ff ff       	call   8012c1 <fd_close>
  801370:	83 c4 10             	add    $0x10,%esp
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <close_all>:

void
close_all(void)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	53                   	push   %ebx
  801379:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80137c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801381:	83 ec 0c             	sub    $0xc,%esp
  801384:	53                   	push   %ebx
  801385:	e8 c0 ff ff ff       	call   80134a <close>
	for (i = 0; i < MAXFD; i++)
  80138a:	83 c3 01             	add    $0x1,%ebx
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	83 fb 20             	cmp    $0x20,%ebx
  801393:	75 ec                	jne    801381 <close_all+0xc>
}
  801395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	57                   	push   %edi
  80139e:	56                   	push   %esi
  80139f:	53                   	push   %ebx
  8013a0:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	ff 75 08             	pushl  0x8(%ebp)
  8013aa:	e8 66 fe ff ff       	call   801215 <fd_lookup>
  8013af:	89 c3                	mov    %eax,%ebx
  8013b1:	83 c4 08             	add    $0x8,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	0f 88 81 00 00 00    	js     80143d <dup+0xa3>
		return r;
	close(newfdnum);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 0c             	pushl  0xc(%ebp)
  8013c2:	e8 83 ff ff ff       	call   80134a <close>

	newfd = INDEX2FD(newfdnum);
  8013c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013ca:	c1 e6 0c             	shl    $0xc,%esi
  8013cd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013d3:	83 c4 04             	add    $0x4,%esp
  8013d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013d9:	e8 d1 fd ff ff       	call   8011af <fd2data>
  8013de:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013e0:	89 34 24             	mov    %esi,(%esp)
  8013e3:	e8 c7 fd ff ff       	call   8011af <fd2data>
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013ed:	89 d8                	mov    %ebx,%eax
  8013ef:	c1 e8 16             	shr    $0x16,%eax
  8013f2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013f9:	a8 01                	test   $0x1,%al
  8013fb:	74 11                	je     80140e <dup+0x74>
  8013fd:	89 d8                	mov    %ebx,%eax
  8013ff:	c1 e8 0c             	shr    $0xc,%eax
  801402:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801409:	f6 c2 01             	test   $0x1,%dl
  80140c:	75 39                	jne    801447 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80140e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801411:	89 d0                	mov    %edx,%eax
  801413:	c1 e8 0c             	shr    $0xc,%eax
  801416:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80141d:	83 ec 0c             	sub    $0xc,%esp
  801420:	25 07 0e 00 00       	and    $0xe07,%eax
  801425:	50                   	push   %eax
  801426:	56                   	push   %esi
  801427:	6a 00                	push   $0x0
  801429:	52                   	push   %edx
  80142a:	6a 00                	push   $0x0
  80142c:	e8 20 f9 ff ff       	call   800d51 <sys_page_map>
  801431:	89 c3                	mov    %eax,%ebx
  801433:	83 c4 20             	add    $0x20,%esp
  801436:	85 c0                	test   %eax,%eax
  801438:	78 31                	js     80146b <dup+0xd1>
		goto err;

	return newfdnum;
  80143a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80143d:	89 d8                	mov    %ebx,%eax
  80143f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801442:	5b                   	pop    %ebx
  801443:	5e                   	pop    %esi
  801444:	5f                   	pop    %edi
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801447:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	25 07 0e 00 00       	and    $0xe07,%eax
  801456:	50                   	push   %eax
  801457:	57                   	push   %edi
  801458:	6a 00                	push   $0x0
  80145a:	53                   	push   %ebx
  80145b:	6a 00                	push   $0x0
  80145d:	e8 ef f8 ff ff       	call   800d51 <sys_page_map>
  801462:	89 c3                	mov    %eax,%ebx
  801464:	83 c4 20             	add    $0x20,%esp
  801467:	85 c0                	test   %eax,%eax
  801469:	79 a3                	jns    80140e <dup+0x74>
	sys_page_unmap(0, newfd);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	56                   	push   %esi
  80146f:	6a 00                	push   $0x0
  801471:	e8 1d f9 ff ff       	call   800d93 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801476:	83 c4 08             	add    $0x8,%esp
  801479:	57                   	push   %edi
  80147a:	6a 00                	push   $0x0
  80147c:	e8 12 f9 ff ff       	call   800d93 <sys_page_unmap>
	return r;
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	eb b7                	jmp    80143d <dup+0xa3>

00801486 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	53                   	push   %ebx
  80148a:	83 ec 14             	sub    $0x14,%esp
  80148d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801490:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801493:	50                   	push   %eax
  801494:	53                   	push   %ebx
  801495:	e8 7b fd ff ff       	call   801215 <fd_lookup>
  80149a:	83 c4 08             	add    $0x8,%esp
  80149d:	85 c0                	test   %eax,%eax
  80149f:	78 3f                	js     8014e0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a7:	50                   	push   %eax
  8014a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ab:	ff 30                	pushl  (%eax)
  8014ad:	e8 b9 fd ff ff       	call   80126b <dev_lookup>
  8014b2:	83 c4 10             	add    $0x10,%esp
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	78 27                	js     8014e0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014bc:	8b 42 08             	mov    0x8(%edx),%eax
  8014bf:	83 e0 03             	and    $0x3,%eax
  8014c2:	83 f8 01             	cmp    $0x1,%eax
  8014c5:	74 1e                	je     8014e5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ca:	8b 40 08             	mov    0x8(%eax),%eax
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	74 35                	je     801506 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	ff 75 10             	pushl  0x10(%ebp)
  8014d7:	ff 75 0c             	pushl  0xc(%ebp)
  8014da:	52                   	push   %edx
  8014db:	ff d0                	call   *%eax
  8014dd:	83 c4 10             	add    $0x10,%esp
}
  8014e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014e5:	a1 04 40 80 00       	mov    0x804004,%eax
  8014ea:	8b 40 48             	mov    0x48(%eax),%eax
  8014ed:	83 ec 04             	sub    $0x4,%esp
  8014f0:	53                   	push   %ebx
  8014f1:	50                   	push   %eax
  8014f2:	68 04 27 80 00       	push   $0x802704
  8014f7:	e8 2f ee ff ff       	call   80032b <cprintf>
		return -E_INVAL;
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801504:	eb da                	jmp    8014e0 <read+0x5a>
		return -E_NOT_SUPP;
  801506:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80150b:	eb d3                	jmp    8014e0 <read+0x5a>

0080150d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	57                   	push   %edi
  801511:	56                   	push   %esi
  801512:	53                   	push   %ebx
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	8b 7d 08             	mov    0x8(%ebp),%edi
  801519:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80151c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801521:	39 f3                	cmp    %esi,%ebx
  801523:	73 25                	jae    80154a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801525:	83 ec 04             	sub    $0x4,%esp
  801528:	89 f0                	mov    %esi,%eax
  80152a:	29 d8                	sub    %ebx,%eax
  80152c:	50                   	push   %eax
  80152d:	89 d8                	mov    %ebx,%eax
  80152f:	03 45 0c             	add    0xc(%ebp),%eax
  801532:	50                   	push   %eax
  801533:	57                   	push   %edi
  801534:	e8 4d ff ff ff       	call   801486 <read>
		if (m < 0)
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 08                	js     801548 <readn+0x3b>
			return m;
		if (m == 0)
  801540:	85 c0                	test   %eax,%eax
  801542:	74 06                	je     80154a <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801544:	01 c3                	add    %eax,%ebx
  801546:	eb d9                	jmp    801521 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801548:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80154a:	89 d8                	mov    %ebx,%eax
  80154c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80154f:	5b                   	pop    %ebx
  801550:	5e                   	pop    %esi
  801551:	5f                   	pop    %edi
  801552:	5d                   	pop    %ebp
  801553:	c3                   	ret    

00801554 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	53                   	push   %ebx
  801558:	83 ec 14             	sub    $0x14,%esp
  80155b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80155e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801561:	50                   	push   %eax
  801562:	53                   	push   %ebx
  801563:	e8 ad fc ff ff       	call   801215 <fd_lookup>
  801568:	83 c4 08             	add    $0x8,%esp
  80156b:	85 c0                	test   %eax,%eax
  80156d:	78 3a                	js     8015a9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801575:	50                   	push   %eax
  801576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801579:	ff 30                	pushl  (%eax)
  80157b:	e8 eb fc ff ff       	call   80126b <dev_lookup>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	85 c0                	test   %eax,%eax
  801585:	78 22                	js     8015a9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80158e:	74 1e                	je     8015ae <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801590:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801593:	8b 52 0c             	mov    0xc(%edx),%edx
  801596:	85 d2                	test   %edx,%edx
  801598:	74 35                	je     8015cf <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80159a:	83 ec 04             	sub    $0x4,%esp
  80159d:	ff 75 10             	pushl  0x10(%ebp)
  8015a0:	ff 75 0c             	pushl  0xc(%ebp)
  8015a3:	50                   	push   %eax
  8015a4:	ff d2                	call   *%edx
  8015a6:	83 c4 10             	add    $0x10,%esp
}
  8015a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8015b3:	8b 40 48             	mov    0x48(%eax),%eax
  8015b6:	83 ec 04             	sub    $0x4,%esp
  8015b9:	53                   	push   %ebx
  8015ba:	50                   	push   %eax
  8015bb:	68 20 27 80 00       	push   $0x802720
  8015c0:	e8 66 ed ff ff       	call   80032b <cprintf>
		return -E_INVAL;
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cd:	eb da                	jmp    8015a9 <write+0x55>
		return -E_NOT_SUPP;
  8015cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d4:	eb d3                	jmp    8015a9 <write+0x55>

008015d6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015dc:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015df:	50                   	push   %eax
  8015e0:	ff 75 08             	pushl  0x8(%ebp)
  8015e3:	e8 2d fc ff ff       	call   801215 <fd_lookup>
  8015e8:	83 c4 08             	add    $0x8,%esp
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	78 0e                	js     8015fd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	53                   	push   %ebx
  801603:	83 ec 14             	sub    $0x14,%esp
  801606:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801609:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160c:	50                   	push   %eax
  80160d:	53                   	push   %ebx
  80160e:	e8 02 fc ff ff       	call   801215 <fd_lookup>
  801613:	83 c4 08             	add    $0x8,%esp
  801616:	85 c0                	test   %eax,%eax
  801618:	78 37                	js     801651 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801620:	50                   	push   %eax
  801621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801624:	ff 30                	pushl  (%eax)
  801626:	e8 40 fc ff ff       	call   80126b <dev_lookup>
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	85 c0                	test   %eax,%eax
  801630:	78 1f                	js     801651 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801632:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801635:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801639:	74 1b                	je     801656 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80163b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80163e:	8b 52 18             	mov    0x18(%edx),%edx
  801641:	85 d2                	test   %edx,%edx
  801643:	74 32                	je     801677 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801645:	83 ec 08             	sub    $0x8,%esp
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	50                   	push   %eax
  80164c:	ff d2                	call   *%edx
  80164e:	83 c4 10             	add    $0x10,%esp
}
  801651:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801654:	c9                   	leave  
  801655:	c3                   	ret    
			thisenv->env_id, fdnum);
  801656:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80165b:	8b 40 48             	mov    0x48(%eax),%eax
  80165e:	83 ec 04             	sub    $0x4,%esp
  801661:	53                   	push   %ebx
  801662:	50                   	push   %eax
  801663:	68 e0 26 80 00       	push   $0x8026e0
  801668:	e8 be ec ff ff       	call   80032b <cprintf>
		return -E_INVAL;
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801675:	eb da                	jmp    801651 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801677:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80167c:	eb d3                	jmp    801651 <ftruncate+0x52>

0080167e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	53                   	push   %ebx
  801682:	83 ec 14             	sub    $0x14,%esp
  801685:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801688:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80168b:	50                   	push   %eax
  80168c:	ff 75 08             	pushl  0x8(%ebp)
  80168f:	e8 81 fb ff ff       	call   801215 <fd_lookup>
  801694:	83 c4 08             	add    $0x8,%esp
  801697:	85 c0                	test   %eax,%eax
  801699:	78 4b                	js     8016e6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a1:	50                   	push   %eax
  8016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a5:	ff 30                	pushl  (%eax)
  8016a7:	e8 bf fb ff ff       	call   80126b <dev_lookup>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	78 33                	js     8016e6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016ba:	74 2f                	je     8016eb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016bc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016bf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016c6:	00 00 00 
	stat->st_isdir = 0;
  8016c9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016d0:	00 00 00 
	stat->st_dev = dev;
  8016d3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016d9:	83 ec 08             	sub    $0x8,%esp
  8016dc:	53                   	push   %ebx
  8016dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8016e0:	ff 50 14             	call   *0x14(%eax)
  8016e3:	83 c4 10             	add    $0x10,%esp
}
  8016e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    
		return -E_NOT_SUPP;
  8016eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f0:	eb f4                	jmp    8016e6 <fstat+0x68>

008016f2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	56                   	push   %esi
  8016f6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016f7:	83 ec 08             	sub    $0x8,%esp
  8016fa:	6a 00                	push   $0x0
  8016fc:	ff 75 08             	pushl  0x8(%ebp)
  8016ff:	e8 e7 01 00 00       	call   8018eb <open>
  801704:	89 c3                	mov    %eax,%ebx
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	85 c0                	test   %eax,%eax
  80170b:	78 1b                	js     801728 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80170d:	83 ec 08             	sub    $0x8,%esp
  801710:	ff 75 0c             	pushl  0xc(%ebp)
  801713:	50                   	push   %eax
  801714:	e8 65 ff ff ff       	call   80167e <fstat>
  801719:	89 c6                	mov    %eax,%esi
	close(fd);
  80171b:	89 1c 24             	mov    %ebx,(%esp)
  80171e:	e8 27 fc ff ff       	call   80134a <close>
	return r;
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	89 f3                	mov    %esi,%ebx
}
  801728:	89 d8                	mov    %ebx,%eax
  80172a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80172d:	5b                   	pop    %ebx
  80172e:	5e                   	pop    %esi
  80172f:	5d                   	pop    %ebp
  801730:	c3                   	ret    

00801731 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	56                   	push   %esi
  801735:	53                   	push   %ebx
  801736:	89 c6                	mov    %eax,%esi
  801738:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80173a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801741:	74 27                	je     80176a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801743:	6a 07                	push   $0x7
  801745:	68 00 50 80 00       	push   $0x805000
  80174a:	56                   	push   %esi
  80174b:	ff 35 00 40 80 00    	pushl  0x804000
  801751:	e8 f9 f9 ff ff       	call   80114f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801756:	83 c4 0c             	add    $0xc,%esp
  801759:	6a 00                	push   $0x0
  80175b:	53                   	push   %ebx
  80175c:	6a 00                	push   $0x0
  80175e:	e8 d5 f9 ff ff       	call   801138 <ipc_recv>
}
  801763:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801766:	5b                   	pop    %ebx
  801767:	5e                   	pop    %esi
  801768:	5d                   	pop    %ebp
  801769:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80176a:	83 ec 0c             	sub    $0xc,%esp
  80176d:	6a 01                	push   $0x1
  80176f:	e8 f2 f9 ff ff       	call   801166 <ipc_find_env>
  801774:	a3 00 40 80 00       	mov    %eax,0x804000
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	eb c5                	jmp    801743 <fsipc+0x12>

0080177e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8b 40 0c             	mov    0xc(%eax),%eax
  80178a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80178f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801792:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	b8 02 00 00 00       	mov    $0x2,%eax
  8017a1:	e8 8b ff ff ff       	call   801731 <fsipc>
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <devfile_flush>:
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017be:	b8 06 00 00 00       	mov    $0x6,%eax
  8017c3:	e8 69 ff ff ff       	call   801731 <fsipc>
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <devfile_stat>:
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	53                   	push   %ebx
  8017ce:	83 ec 04             	sub    $0x4,%esp
  8017d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017da:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017df:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e4:	b8 05 00 00 00       	mov    $0x5,%eax
  8017e9:	e8 43 ff ff ff       	call   801731 <fsipc>
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 2c                	js     80181e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017f2:	83 ec 08             	sub    $0x8,%esp
  8017f5:	68 00 50 80 00       	push   $0x805000
  8017fa:	53                   	push   %ebx
  8017fb:	e8 15 f1 ff ff       	call   800915 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801800:	a1 80 50 80 00       	mov    0x805080,%eax
  801805:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80180b:	a1 84 50 80 00       	mov    0x805084,%eax
  801810:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <devfile_write>:
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 0c             	sub    $0xc,%esp
  801829:	8b 45 10             	mov    0x10(%ebp),%eax
  80182c:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801831:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801836:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801839:	8b 55 08             	mov    0x8(%ebp),%edx
  80183c:	8b 52 0c             	mov    0xc(%edx),%edx
  80183f:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801845:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  80184a:	50                   	push   %eax
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	68 08 50 80 00       	push   $0x805008
  801853:	e8 4b f2 ff ff       	call   800aa3 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	b8 04 00 00 00       	mov    $0x4,%eax
  801862:	e8 ca fe ff ff       	call   801731 <fsipc>
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <devfile_read>:
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	56                   	push   %esi
  80186d:	53                   	push   %ebx
  80186e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8b 40 0c             	mov    0xc(%eax),%eax
  801877:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80187c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801882:	ba 00 00 00 00       	mov    $0x0,%edx
  801887:	b8 03 00 00 00       	mov    $0x3,%eax
  80188c:	e8 a0 fe ff ff       	call   801731 <fsipc>
  801891:	89 c3                	mov    %eax,%ebx
  801893:	85 c0                	test   %eax,%eax
  801895:	78 1f                	js     8018b6 <devfile_read+0x4d>
	assert(r <= n);
  801897:	39 f0                	cmp    %esi,%eax
  801899:	77 24                	ja     8018bf <devfile_read+0x56>
	assert(r <= PGSIZE);
  80189b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018a0:	7f 33                	jg     8018d5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	50                   	push   %eax
  8018a6:	68 00 50 80 00       	push   $0x805000
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	e8 f0 f1 ff ff       	call   800aa3 <memmove>
	return r;
  8018b3:	83 c4 10             	add    $0x10,%esp
}
  8018b6:	89 d8                	mov    %ebx,%eax
  8018b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5d                   	pop    %ebp
  8018be:	c3                   	ret    
	assert(r <= n);
  8018bf:	68 50 27 80 00       	push   $0x802750
  8018c4:	68 57 27 80 00       	push   $0x802757
  8018c9:	6a 7c                	push   $0x7c
  8018cb:	68 6c 27 80 00       	push   $0x80276c
  8018d0:	e8 7b e9 ff ff       	call   800250 <_panic>
	assert(r <= PGSIZE);
  8018d5:	68 77 27 80 00       	push   $0x802777
  8018da:	68 57 27 80 00       	push   $0x802757
  8018df:	6a 7d                	push   $0x7d
  8018e1:	68 6c 27 80 00       	push   $0x80276c
  8018e6:	e8 65 e9 ff ff       	call   800250 <_panic>

008018eb <open>:
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	56                   	push   %esi
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 1c             	sub    $0x1c,%esp
  8018f3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018f6:	56                   	push   %esi
  8018f7:	e8 e2 ef ff ff       	call   8008de <strlen>
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801904:	7f 6c                	jg     801972 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801906:	83 ec 0c             	sub    $0xc,%esp
  801909:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190c:	50                   	push   %eax
  80190d:	e8 b4 f8 ff ff       	call   8011c6 <fd_alloc>
  801912:	89 c3                	mov    %eax,%ebx
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	85 c0                	test   %eax,%eax
  801919:	78 3c                	js     801957 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80191b:	83 ec 08             	sub    $0x8,%esp
  80191e:	56                   	push   %esi
  80191f:	68 00 50 80 00       	push   $0x805000
  801924:	e8 ec ef ff ff       	call   800915 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801934:	b8 01 00 00 00       	mov    $0x1,%eax
  801939:	e8 f3 fd ff ff       	call   801731 <fsipc>
  80193e:	89 c3                	mov    %eax,%ebx
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	85 c0                	test   %eax,%eax
  801945:	78 19                	js     801960 <open+0x75>
	return fd2num(fd);
  801947:	83 ec 0c             	sub    $0xc,%esp
  80194a:	ff 75 f4             	pushl  -0xc(%ebp)
  80194d:	e8 4d f8 ff ff       	call   80119f <fd2num>
  801952:	89 c3                	mov    %eax,%ebx
  801954:	83 c4 10             	add    $0x10,%esp
}
  801957:	89 d8                	mov    %ebx,%eax
  801959:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195c:	5b                   	pop    %ebx
  80195d:	5e                   	pop    %esi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    
		fd_close(fd, 0);
  801960:	83 ec 08             	sub    $0x8,%esp
  801963:	6a 00                	push   $0x0
  801965:	ff 75 f4             	pushl  -0xc(%ebp)
  801968:	e8 54 f9 ff ff       	call   8012c1 <fd_close>
		return r;
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	eb e5                	jmp    801957 <open+0x6c>
		return -E_BAD_PATH;
  801972:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801977:	eb de                	jmp    801957 <open+0x6c>

00801979 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80197f:	ba 00 00 00 00       	mov    $0x0,%edx
  801984:	b8 08 00 00 00       	mov    $0x8,%eax
  801989:	e8 a3 fd ff ff       	call   801731 <fsipc>
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801996:	89 d0                	mov    %edx,%eax
  801998:	c1 e8 16             	shr    $0x16,%eax
  80199b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8019a2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8019a7:	f6 c1 01             	test   $0x1,%cl
  8019aa:	74 1d                	je     8019c9 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8019ac:	c1 ea 0c             	shr    $0xc,%edx
  8019af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8019b6:	f6 c2 01             	test   $0x1,%dl
  8019b9:	74 0e                	je     8019c9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8019bb:	c1 ea 0c             	shr    $0xc,%edx
  8019be:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8019c5:	ef 
  8019c6:	0f b7 c0             	movzwl %ax,%eax
}
  8019c9:	5d                   	pop    %ebp
  8019ca:	c3                   	ret    

008019cb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	56                   	push   %esi
  8019cf:	53                   	push   %ebx
  8019d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019d3:	83 ec 0c             	sub    $0xc,%esp
  8019d6:	ff 75 08             	pushl  0x8(%ebp)
  8019d9:	e8 d1 f7 ff ff       	call   8011af <fd2data>
  8019de:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019e0:	83 c4 08             	add    $0x8,%esp
  8019e3:	68 83 27 80 00       	push   $0x802783
  8019e8:	53                   	push   %ebx
  8019e9:	e8 27 ef ff ff       	call   800915 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019ee:	8b 46 04             	mov    0x4(%esi),%eax
  8019f1:	2b 06                	sub    (%esi),%eax
  8019f3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019f9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a00:	00 00 00 
	stat->st_dev = &devpipe;
  801a03:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a0a:	30 80 00 
	return 0;
}
  801a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a15:	5b                   	pop    %ebx
  801a16:	5e                   	pop    %esi
  801a17:	5d                   	pop    %ebp
  801a18:	c3                   	ret    

00801a19 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	53                   	push   %ebx
  801a1d:	83 ec 0c             	sub    $0xc,%esp
  801a20:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a23:	53                   	push   %ebx
  801a24:	6a 00                	push   $0x0
  801a26:	e8 68 f3 ff ff       	call   800d93 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a2b:	89 1c 24             	mov    %ebx,(%esp)
  801a2e:	e8 7c f7 ff ff       	call   8011af <fd2data>
  801a33:	83 c4 08             	add    $0x8,%esp
  801a36:	50                   	push   %eax
  801a37:	6a 00                	push   $0x0
  801a39:	e8 55 f3 ff ff       	call   800d93 <sys_page_unmap>
}
  801a3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <_pipeisclosed>:
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	57                   	push   %edi
  801a47:	56                   	push   %esi
  801a48:	53                   	push   %ebx
  801a49:	83 ec 1c             	sub    $0x1c,%esp
  801a4c:	89 c7                	mov    %eax,%edi
  801a4e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a50:	a1 04 40 80 00       	mov    0x804004,%eax
  801a55:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a58:	83 ec 0c             	sub    $0xc,%esp
  801a5b:	57                   	push   %edi
  801a5c:	e8 2f ff ff ff       	call   801990 <pageref>
  801a61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a64:	89 34 24             	mov    %esi,(%esp)
  801a67:	e8 24 ff ff ff       	call   801990 <pageref>
		nn = thisenv->env_runs;
  801a6c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801a72:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	39 cb                	cmp    %ecx,%ebx
  801a7a:	74 1b                	je     801a97 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a7c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a7f:	75 cf                	jne    801a50 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a81:	8b 42 58             	mov    0x58(%edx),%eax
  801a84:	6a 01                	push   $0x1
  801a86:	50                   	push   %eax
  801a87:	53                   	push   %ebx
  801a88:	68 8a 27 80 00       	push   $0x80278a
  801a8d:	e8 99 e8 ff ff       	call   80032b <cprintf>
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	eb b9                	jmp    801a50 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a97:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a9a:	0f 94 c0             	sete   %al
  801a9d:	0f b6 c0             	movzbl %al,%eax
}
  801aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5e                   	pop    %esi
  801aa5:	5f                   	pop    %edi
  801aa6:	5d                   	pop    %ebp
  801aa7:	c3                   	ret    

00801aa8 <devpipe_write>:
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	57                   	push   %edi
  801aac:	56                   	push   %esi
  801aad:	53                   	push   %ebx
  801aae:	83 ec 28             	sub    $0x28,%esp
  801ab1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ab4:	56                   	push   %esi
  801ab5:	e8 f5 f6 ff ff       	call   8011af <fd2data>
  801aba:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	bf 00 00 00 00       	mov    $0x0,%edi
  801ac4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ac7:	74 4f                	je     801b18 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ac9:	8b 43 04             	mov    0x4(%ebx),%eax
  801acc:	8b 0b                	mov    (%ebx),%ecx
  801ace:	8d 51 20             	lea    0x20(%ecx),%edx
  801ad1:	39 d0                	cmp    %edx,%eax
  801ad3:	72 14                	jb     801ae9 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ad5:	89 da                	mov    %ebx,%edx
  801ad7:	89 f0                	mov    %esi,%eax
  801ad9:	e8 65 ff ff ff       	call   801a43 <_pipeisclosed>
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	75 3a                	jne    801b1c <devpipe_write+0x74>
			sys_yield();
  801ae2:	e8 08 f2 ff ff       	call   800cef <sys_yield>
  801ae7:	eb e0                	jmp    801ac9 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ae9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801aec:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801af0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801af3:	89 c2                	mov    %eax,%edx
  801af5:	c1 fa 1f             	sar    $0x1f,%edx
  801af8:	89 d1                	mov    %edx,%ecx
  801afa:	c1 e9 1b             	shr    $0x1b,%ecx
  801afd:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b00:	83 e2 1f             	and    $0x1f,%edx
  801b03:	29 ca                	sub    %ecx,%edx
  801b05:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b09:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b0d:	83 c0 01             	add    $0x1,%eax
  801b10:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b13:	83 c7 01             	add    $0x1,%edi
  801b16:	eb ac                	jmp    801ac4 <devpipe_write+0x1c>
	return i;
  801b18:	89 f8                	mov    %edi,%eax
  801b1a:	eb 05                	jmp    801b21 <devpipe_write+0x79>
				return 0;
  801b1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b24:	5b                   	pop    %ebx
  801b25:	5e                   	pop    %esi
  801b26:	5f                   	pop    %edi
  801b27:	5d                   	pop    %ebp
  801b28:	c3                   	ret    

00801b29 <devpipe_read>:
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	57                   	push   %edi
  801b2d:	56                   	push   %esi
  801b2e:	53                   	push   %ebx
  801b2f:	83 ec 18             	sub    $0x18,%esp
  801b32:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b35:	57                   	push   %edi
  801b36:	e8 74 f6 ff ff       	call   8011af <fd2data>
  801b3b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b3d:	83 c4 10             	add    $0x10,%esp
  801b40:	be 00 00 00 00       	mov    $0x0,%esi
  801b45:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b48:	74 47                	je     801b91 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b4a:	8b 03                	mov    (%ebx),%eax
  801b4c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b4f:	75 22                	jne    801b73 <devpipe_read+0x4a>
			if (i > 0)
  801b51:	85 f6                	test   %esi,%esi
  801b53:	75 14                	jne    801b69 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b55:	89 da                	mov    %ebx,%edx
  801b57:	89 f8                	mov    %edi,%eax
  801b59:	e8 e5 fe ff ff       	call   801a43 <_pipeisclosed>
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	75 33                	jne    801b95 <devpipe_read+0x6c>
			sys_yield();
  801b62:	e8 88 f1 ff ff       	call   800cef <sys_yield>
  801b67:	eb e1                	jmp    801b4a <devpipe_read+0x21>
				return i;
  801b69:	89 f0                	mov    %esi,%eax
}
  801b6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b6e:	5b                   	pop    %ebx
  801b6f:	5e                   	pop    %esi
  801b70:	5f                   	pop    %edi
  801b71:	5d                   	pop    %ebp
  801b72:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b73:	99                   	cltd   
  801b74:	c1 ea 1b             	shr    $0x1b,%edx
  801b77:	01 d0                	add    %edx,%eax
  801b79:	83 e0 1f             	and    $0x1f,%eax
  801b7c:	29 d0                	sub    %edx,%eax
  801b7e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b86:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b89:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b8c:	83 c6 01             	add    $0x1,%esi
  801b8f:	eb b4                	jmp    801b45 <devpipe_read+0x1c>
	return i;
  801b91:	89 f0                	mov    %esi,%eax
  801b93:	eb d6                	jmp    801b6b <devpipe_read+0x42>
				return 0;
  801b95:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9a:	eb cf                	jmp    801b6b <devpipe_read+0x42>

00801b9c <pipe>:
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	56                   	push   %esi
  801ba0:	53                   	push   %ebx
  801ba1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ba4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba7:	50                   	push   %eax
  801ba8:	e8 19 f6 ff ff       	call   8011c6 <fd_alloc>
  801bad:	89 c3                	mov    %eax,%ebx
  801baf:	83 c4 10             	add    $0x10,%esp
  801bb2:	85 c0                	test   %eax,%eax
  801bb4:	78 5b                	js     801c11 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bb6:	83 ec 04             	sub    $0x4,%esp
  801bb9:	68 07 04 00 00       	push   $0x407
  801bbe:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc1:	6a 00                	push   $0x0
  801bc3:	e8 46 f1 ff ff       	call   800d0e <sys_page_alloc>
  801bc8:	89 c3                	mov    %eax,%ebx
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	78 40                	js     801c11 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801bd1:	83 ec 0c             	sub    $0xc,%esp
  801bd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bd7:	50                   	push   %eax
  801bd8:	e8 e9 f5 ff ff       	call   8011c6 <fd_alloc>
  801bdd:	89 c3                	mov    %eax,%ebx
  801bdf:	83 c4 10             	add    $0x10,%esp
  801be2:	85 c0                	test   %eax,%eax
  801be4:	78 1b                	js     801c01 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be6:	83 ec 04             	sub    $0x4,%esp
  801be9:	68 07 04 00 00       	push   $0x407
  801bee:	ff 75 f0             	pushl  -0x10(%ebp)
  801bf1:	6a 00                	push   $0x0
  801bf3:	e8 16 f1 ff ff       	call   800d0e <sys_page_alloc>
  801bf8:	89 c3                	mov    %eax,%ebx
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	79 19                	jns    801c1a <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c01:	83 ec 08             	sub    $0x8,%esp
  801c04:	ff 75 f4             	pushl  -0xc(%ebp)
  801c07:	6a 00                	push   $0x0
  801c09:	e8 85 f1 ff ff       	call   800d93 <sys_page_unmap>
  801c0e:	83 c4 10             	add    $0x10,%esp
}
  801c11:	89 d8                	mov    %ebx,%eax
  801c13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5e                   	pop    %esi
  801c18:	5d                   	pop    %ebp
  801c19:	c3                   	ret    
	va = fd2data(fd0);
  801c1a:	83 ec 0c             	sub    $0xc,%esp
  801c1d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c20:	e8 8a f5 ff ff       	call   8011af <fd2data>
  801c25:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c27:	83 c4 0c             	add    $0xc,%esp
  801c2a:	68 07 04 00 00       	push   $0x407
  801c2f:	50                   	push   %eax
  801c30:	6a 00                	push   $0x0
  801c32:	e8 d7 f0 ff ff       	call   800d0e <sys_page_alloc>
  801c37:	89 c3                	mov    %eax,%ebx
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	0f 88 8c 00 00 00    	js     801cd0 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c44:	83 ec 0c             	sub    $0xc,%esp
  801c47:	ff 75 f0             	pushl  -0x10(%ebp)
  801c4a:	e8 60 f5 ff ff       	call   8011af <fd2data>
  801c4f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c56:	50                   	push   %eax
  801c57:	6a 00                	push   $0x0
  801c59:	56                   	push   %esi
  801c5a:	6a 00                	push   $0x0
  801c5c:	e8 f0 f0 ff ff       	call   800d51 <sys_page_map>
  801c61:	89 c3                	mov    %eax,%ebx
  801c63:	83 c4 20             	add    $0x20,%esp
  801c66:	85 c0                	test   %eax,%eax
  801c68:	78 58                	js     801cc2 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c73:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c78:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c82:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c88:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c94:	83 ec 0c             	sub    $0xc,%esp
  801c97:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9a:	e8 00 f5 ff ff       	call   80119f <fd2num>
  801c9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ca4:	83 c4 04             	add    $0x4,%esp
  801ca7:	ff 75 f0             	pushl  -0x10(%ebp)
  801caa:	e8 f0 f4 ff ff       	call   80119f <fd2num>
  801caf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cb5:	83 c4 10             	add    $0x10,%esp
  801cb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cbd:	e9 4f ff ff ff       	jmp    801c11 <pipe+0x75>
	sys_page_unmap(0, va);
  801cc2:	83 ec 08             	sub    $0x8,%esp
  801cc5:	56                   	push   %esi
  801cc6:	6a 00                	push   $0x0
  801cc8:	e8 c6 f0 ff ff       	call   800d93 <sys_page_unmap>
  801ccd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cd0:	83 ec 08             	sub    $0x8,%esp
  801cd3:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd6:	6a 00                	push   $0x0
  801cd8:	e8 b6 f0 ff ff       	call   800d93 <sys_page_unmap>
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	e9 1c ff ff ff       	jmp    801c01 <pipe+0x65>

00801ce5 <pipeisclosed>:
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ceb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cee:	50                   	push   %eax
  801cef:	ff 75 08             	pushl  0x8(%ebp)
  801cf2:	e8 1e f5 ff ff       	call   801215 <fd_lookup>
  801cf7:	83 c4 10             	add    $0x10,%esp
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	78 18                	js     801d16 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801cfe:	83 ec 0c             	sub    $0xc,%esp
  801d01:	ff 75 f4             	pushl  -0xc(%ebp)
  801d04:	e8 a6 f4 ff ff       	call   8011af <fd2data>
	return _pipeisclosed(fd, p);
  801d09:	89 c2                	mov    %eax,%edx
  801d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0e:	e8 30 fd ff ff       	call   801a43 <_pipeisclosed>
  801d13:	83 c4 10             	add    $0x10,%esp
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d20:	5d                   	pop    %ebp
  801d21:	c3                   	ret    

00801d22 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d28:	68 a2 27 80 00       	push   $0x8027a2
  801d2d:	ff 75 0c             	pushl  0xc(%ebp)
  801d30:	e8 e0 eb ff ff       	call   800915 <strcpy>
	return 0;
}
  801d35:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <devcons_write>:
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	57                   	push   %edi
  801d40:	56                   	push   %esi
  801d41:	53                   	push   %ebx
  801d42:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d48:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d4d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d53:	eb 2f                	jmp    801d84 <devcons_write+0x48>
		m = n - tot;
  801d55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d58:	29 f3                	sub    %esi,%ebx
  801d5a:	83 fb 7f             	cmp    $0x7f,%ebx
  801d5d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d62:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d65:	83 ec 04             	sub    $0x4,%esp
  801d68:	53                   	push   %ebx
  801d69:	89 f0                	mov    %esi,%eax
  801d6b:	03 45 0c             	add    0xc(%ebp),%eax
  801d6e:	50                   	push   %eax
  801d6f:	57                   	push   %edi
  801d70:	e8 2e ed ff ff       	call   800aa3 <memmove>
		sys_cputs(buf, m);
  801d75:	83 c4 08             	add    $0x8,%esp
  801d78:	53                   	push   %ebx
  801d79:	57                   	push   %edi
  801d7a:	e8 d3 ee ff ff       	call   800c52 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d7f:	01 de                	add    %ebx,%esi
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d87:	72 cc                	jb     801d55 <devcons_write+0x19>
}
  801d89:	89 f0                	mov    %esi,%eax
  801d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d8e:	5b                   	pop    %ebx
  801d8f:	5e                   	pop    %esi
  801d90:	5f                   	pop    %edi
  801d91:	5d                   	pop    %ebp
  801d92:	c3                   	ret    

00801d93 <devcons_read>:
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 08             	sub    $0x8,%esp
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801da2:	75 07                	jne    801dab <devcons_read+0x18>
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    
		sys_yield();
  801da6:	e8 44 ef ff ff       	call   800cef <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801dab:	e8 c0 ee ff ff       	call   800c70 <sys_cgetc>
  801db0:	85 c0                	test   %eax,%eax
  801db2:	74 f2                	je     801da6 <devcons_read+0x13>
	if (c < 0)
  801db4:	85 c0                	test   %eax,%eax
  801db6:	78 ec                	js     801da4 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801db8:	83 f8 04             	cmp    $0x4,%eax
  801dbb:	74 0c                	je     801dc9 <devcons_read+0x36>
	*(char*)vbuf = c;
  801dbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc0:	88 02                	mov    %al,(%edx)
	return 1;
  801dc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc7:	eb db                	jmp    801da4 <devcons_read+0x11>
		return 0;
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dce:	eb d4                	jmp    801da4 <devcons_read+0x11>

00801dd0 <cputchar>:
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ddc:	6a 01                	push   $0x1
  801dde:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801de1:	50                   	push   %eax
  801de2:	e8 6b ee ff ff       	call   800c52 <sys_cputs>
}
  801de7:	83 c4 10             	add    $0x10,%esp
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <getchar>:
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801df2:	6a 01                	push   $0x1
  801df4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801df7:	50                   	push   %eax
  801df8:	6a 00                	push   $0x0
  801dfa:	e8 87 f6 ff ff       	call   801486 <read>
	if (r < 0)
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	85 c0                	test   %eax,%eax
  801e04:	78 08                	js     801e0e <getchar+0x22>
	if (r < 1)
  801e06:	85 c0                	test   %eax,%eax
  801e08:	7e 06                	jle    801e10 <getchar+0x24>
	return c;
  801e0a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    
		return -E_EOF;
  801e10:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e15:	eb f7                	jmp    801e0e <getchar+0x22>

00801e17 <iscons>:
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e20:	50                   	push   %eax
  801e21:	ff 75 08             	pushl  0x8(%ebp)
  801e24:	e8 ec f3 ff ff       	call   801215 <fd_lookup>
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	78 11                	js     801e41 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e39:	39 10                	cmp    %edx,(%eax)
  801e3b:	0f 94 c0             	sete   %al
  801e3e:	0f b6 c0             	movzbl %al,%eax
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <opencons>:
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e4c:	50                   	push   %eax
  801e4d:	e8 74 f3 ff ff       	call   8011c6 <fd_alloc>
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	85 c0                	test   %eax,%eax
  801e57:	78 3a                	js     801e93 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e59:	83 ec 04             	sub    $0x4,%esp
  801e5c:	68 07 04 00 00       	push   $0x407
  801e61:	ff 75 f4             	pushl  -0xc(%ebp)
  801e64:	6a 00                	push   $0x0
  801e66:	e8 a3 ee ff ff       	call   800d0e <sys_page_alloc>
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	78 21                	js     801e93 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e75:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e7b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e80:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	50                   	push   %eax
  801e8b:	e8 0f f3 ff ff       	call   80119f <fd2num>
  801e90:	83 c4 10             	add    $0x10,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	53                   	push   %ebx
  801e99:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801e9c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801ea3:	74 0d                	je     801eb2 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801ead:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801eb2:	e8 19 ee ff ff       	call   800cd0 <sys_getenvid>
  801eb7:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801eb9:	83 ec 04             	sub    $0x4,%esp
  801ebc:	6a 07                	push   $0x7
  801ebe:	68 00 f0 bf ee       	push   $0xeebff000
  801ec3:	50                   	push   %eax
  801ec4:	e8 45 ee ff ff       	call   800d0e <sys_page_alloc>
        	if (r < 0) {
  801ec9:	83 c4 10             	add    $0x10,%esp
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	78 27                	js     801ef7 <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801ed0:	83 ec 08             	sub    $0x8,%esp
  801ed3:	68 09 1f 80 00       	push   $0x801f09
  801ed8:	53                   	push   %ebx
  801ed9:	e8 7b ef ff ff       	call   800e59 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801ede:	83 c4 10             	add    $0x10,%esp
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	79 c0                	jns    801ea5 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801ee5:	50                   	push   %eax
  801ee6:	68 ae 27 80 00       	push   $0x8027ae
  801eeb:	6a 28                	push   $0x28
  801eed:	68 c2 27 80 00       	push   $0x8027c2
  801ef2:	e8 59 e3 ff ff       	call   800250 <_panic>
            		panic("pgfault_handler: %e", r);
  801ef7:	50                   	push   %eax
  801ef8:	68 ae 27 80 00       	push   $0x8027ae
  801efd:	6a 24                	push   $0x24
  801eff:	68 c2 27 80 00       	push   $0x8027c2
  801f04:	e8 47 e3 ff ff       	call   800250 <_panic>

00801f09 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f09:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f0a:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801f0f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f11:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801f14:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801f18:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801f1b:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801f1f:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801f23:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801f26:	83 c4 08             	add    $0x8,%esp
	popal
  801f29:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801f2a:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801f2d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801f2e:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801f2f:	c3                   	ret    

00801f30 <__udivdi3>:
  801f30:	55                   	push   %ebp
  801f31:	57                   	push   %edi
  801f32:	56                   	push   %esi
  801f33:	53                   	push   %ebx
  801f34:	83 ec 1c             	sub    $0x1c,%esp
  801f37:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f3b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f43:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f47:	85 d2                	test   %edx,%edx
  801f49:	75 35                	jne    801f80 <__udivdi3+0x50>
  801f4b:	39 f3                	cmp    %esi,%ebx
  801f4d:	0f 87 bd 00 00 00    	ja     802010 <__udivdi3+0xe0>
  801f53:	85 db                	test   %ebx,%ebx
  801f55:	89 d9                	mov    %ebx,%ecx
  801f57:	75 0b                	jne    801f64 <__udivdi3+0x34>
  801f59:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5e:	31 d2                	xor    %edx,%edx
  801f60:	f7 f3                	div    %ebx
  801f62:	89 c1                	mov    %eax,%ecx
  801f64:	31 d2                	xor    %edx,%edx
  801f66:	89 f0                	mov    %esi,%eax
  801f68:	f7 f1                	div    %ecx
  801f6a:	89 c6                	mov    %eax,%esi
  801f6c:	89 e8                	mov    %ebp,%eax
  801f6e:	89 f7                	mov    %esi,%edi
  801f70:	f7 f1                	div    %ecx
  801f72:	89 fa                	mov    %edi,%edx
  801f74:	83 c4 1c             	add    $0x1c,%esp
  801f77:	5b                   	pop    %ebx
  801f78:	5e                   	pop    %esi
  801f79:	5f                   	pop    %edi
  801f7a:	5d                   	pop    %ebp
  801f7b:	c3                   	ret    
  801f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f80:	39 f2                	cmp    %esi,%edx
  801f82:	77 7c                	ja     802000 <__udivdi3+0xd0>
  801f84:	0f bd fa             	bsr    %edx,%edi
  801f87:	83 f7 1f             	xor    $0x1f,%edi
  801f8a:	0f 84 98 00 00 00    	je     802028 <__udivdi3+0xf8>
  801f90:	89 f9                	mov    %edi,%ecx
  801f92:	b8 20 00 00 00       	mov    $0x20,%eax
  801f97:	29 f8                	sub    %edi,%eax
  801f99:	d3 e2                	shl    %cl,%edx
  801f9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f9f:	89 c1                	mov    %eax,%ecx
  801fa1:	89 da                	mov    %ebx,%edx
  801fa3:	d3 ea                	shr    %cl,%edx
  801fa5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801fa9:	09 d1                	or     %edx,%ecx
  801fab:	89 f2                	mov    %esi,%edx
  801fad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fb1:	89 f9                	mov    %edi,%ecx
  801fb3:	d3 e3                	shl    %cl,%ebx
  801fb5:	89 c1                	mov    %eax,%ecx
  801fb7:	d3 ea                	shr    %cl,%edx
  801fb9:	89 f9                	mov    %edi,%ecx
  801fbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801fbf:	d3 e6                	shl    %cl,%esi
  801fc1:	89 eb                	mov    %ebp,%ebx
  801fc3:	89 c1                	mov    %eax,%ecx
  801fc5:	d3 eb                	shr    %cl,%ebx
  801fc7:	09 de                	or     %ebx,%esi
  801fc9:	89 f0                	mov    %esi,%eax
  801fcb:	f7 74 24 08          	divl   0x8(%esp)
  801fcf:	89 d6                	mov    %edx,%esi
  801fd1:	89 c3                	mov    %eax,%ebx
  801fd3:	f7 64 24 0c          	mull   0xc(%esp)
  801fd7:	39 d6                	cmp    %edx,%esi
  801fd9:	72 0c                	jb     801fe7 <__udivdi3+0xb7>
  801fdb:	89 f9                	mov    %edi,%ecx
  801fdd:	d3 e5                	shl    %cl,%ebp
  801fdf:	39 c5                	cmp    %eax,%ebp
  801fe1:	73 5d                	jae    802040 <__udivdi3+0x110>
  801fe3:	39 d6                	cmp    %edx,%esi
  801fe5:	75 59                	jne    802040 <__udivdi3+0x110>
  801fe7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fea:	31 ff                	xor    %edi,%edi
  801fec:	89 fa                	mov    %edi,%edx
  801fee:	83 c4 1c             	add    $0x1c,%esp
  801ff1:	5b                   	pop    %ebx
  801ff2:	5e                   	pop    %esi
  801ff3:	5f                   	pop    %edi
  801ff4:	5d                   	pop    %ebp
  801ff5:	c3                   	ret    
  801ff6:	8d 76 00             	lea    0x0(%esi),%esi
  801ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802000:	31 ff                	xor    %edi,%edi
  802002:	31 c0                	xor    %eax,%eax
  802004:	89 fa                	mov    %edi,%edx
  802006:	83 c4 1c             	add    $0x1c,%esp
  802009:	5b                   	pop    %ebx
  80200a:	5e                   	pop    %esi
  80200b:	5f                   	pop    %edi
  80200c:	5d                   	pop    %ebp
  80200d:	c3                   	ret    
  80200e:	66 90                	xchg   %ax,%ax
  802010:	31 ff                	xor    %edi,%edi
  802012:	89 e8                	mov    %ebp,%eax
  802014:	89 f2                	mov    %esi,%edx
  802016:	f7 f3                	div    %ebx
  802018:	89 fa                	mov    %edi,%edx
  80201a:	83 c4 1c             	add    $0x1c,%esp
  80201d:	5b                   	pop    %ebx
  80201e:	5e                   	pop    %esi
  80201f:	5f                   	pop    %edi
  802020:	5d                   	pop    %ebp
  802021:	c3                   	ret    
  802022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802028:	39 f2                	cmp    %esi,%edx
  80202a:	72 06                	jb     802032 <__udivdi3+0x102>
  80202c:	31 c0                	xor    %eax,%eax
  80202e:	39 eb                	cmp    %ebp,%ebx
  802030:	77 d2                	ja     802004 <__udivdi3+0xd4>
  802032:	b8 01 00 00 00       	mov    $0x1,%eax
  802037:	eb cb                	jmp    802004 <__udivdi3+0xd4>
  802039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802040:	89 d8                	mov    %ebx,%eax
  802042:	31 ff                	xor    %edi,%edi
  802044:	eb be                	jmp    802004 <__udivdi3+0xd4>
  802046:	66 90                	xchg   %ax,%ax
  802048:	66 90                	xchg   %ax,%ax
  80204a:	66 90                	xchg   %ax,%ax
  80204c:	66 90                	xchg   %ax,%ax
  80204e:	66 90                	xchg   %ax,%ax

00802050 <__umoddi3>:
  802050:	55                   	push   %ebp
  802051:	57                   	push   %edi
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
  802054:	83 ec 1c             	sub    $0x1c,%esp
  802057:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80205b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80205f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802063:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802067:	85 ed                	test   %ebp,%ebp
  802069:	89 f0                	mov    %esi,%eax
  80206b:	89 da                	mov    %ebx,%edx
  80206d:	75 19                	jne    802088 <__umoddi3+0x38>
  80206f:	39 df                	cmp    %ebx,%edi
  802071:	0f 86 b1 00 00 00    	jbe    802128 <__umoddi3+0xd8>
  802077:	f7 f7                	div    %edi
  802079:	89 d0                	mov    %edx,%eax
  80207b:	31 d2                	xor    %edx,%edx
  80207d:	83 c4 1c             	add    $0x1c,%esp
  802080:	5b                   	pop    %ebx
  802081:	5e                   	pop    %esi
  802082:	5f                   	pop    %edi
  802083:	5d                   	pop    %ebp
  802084:	c3                   	ret    
  802085:	8d 76 00             	lea    0x0(%esi),%esi
  802088:	39 dd                	cmp    %ebx,%ebp
  80208a:	77 f1                	ja     80207d <__umoddi3+0x2d>
  80208c:	0f bd cd             	bsr    %ebp,%ecx
  80208f:	83 f1 1f             	xor    $0x1f,%ecx
  802092:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802096:	0f 84 b4 00 00 00    	je     802150 <__umoddi3+0x100>
  80209c:	b8 20 00 00 00       	mov    $0x20,%eax
  8020a1:	89 c2                	mov    %eax,%edx
  8020a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020a7:	29 c2                	sub    %eax,%edx
  8020a9:	89 c1                	mov    %eax,%ecx
  8020ab:	89 f8                	mov    %edi,%eax
  8020ad:	d3 e5                	shl    %cl,%ebp
  8020af:	89 d1                	mov    %edx,%ecx
  8020b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8020b5:	d3 e8                	shr    %cl,%eax
  8020b7:	09 c5                	or     %eax,%ebp
  8020b9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020bd:	89 c1                	mov    %eax,%ecx
  8020bf:	d3 e7                	shl    %cl,%edi
  8020c1:	89 d1                	mov    %edx,%ecx
  8020c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8020c7:	89 df                	mov    %ebx,%edi
  8020c9:	d3 ef                	shr    %cl,%edi
  8020cb:	89 c1                	mov    %eax,%ecx
  8020cd:	89 f0                	mov    %esi,%eax
  8020cf:	d3 e3                	shl    %cl,%ebx
  8020d1:	89 d1                	mov    %edx,%ecx
  8020d3:	89 fa                	mov    %edi,%edx
  8020d5:	d3 e8                	shr    %cl,%eax
  8020d7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020dc:	09 d8                	or     %ebx,%eax
  8020de:	f7 f5                	div    %ebp
  8020e0:	d3 e6                	shl    %cl,%esi
  8020e2:	89 d1                	mov    %edx,%ecx
  8020e4:	f7 64 24 08          	mull   0x8(%esp)
  8020e8:	39 d1                	cmp    %edx,%ecx
  8020ea:	89 c3                	mov    %eax,%ebx
  8020ec:	89 d7                	mov    %edx,%edi
  8020ee:	72 06                	jb     8020f6 <__umoddi3+0xa6>
  8020f0:	75 0e                	jne    802100 <__umoddi3+0xb0>
  8020f2:	39 c6                	cmp    %eax,%esi
  8020f4:	73 0a                	jae    802100 <__umoddi3+0xb0>
  8020f6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8020fa:	19 ea                	sbb    %ebp,%edx
  8020fc:	89 d7                	mov    %edx,%edi
  8020fe:	89 c3                	mov    %eax,%ebx
  802100:	89 ca                	mov    %ecx,%edx
  802102:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802107:	29 de                	sub    %ebx,%esi
  802109:	19 fa                	sbb    %edi,%edx
  80210b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80210f:	89 d0                	mov    %edx,%eax
  802111:	d3 e0                	shl    %cl,%eax
  802113:	89 d9                	mov    %ebx,%ecx
  802115:	d3 ee                	shr    %cl,%esi
  802117:	d3 ea                	shr    %cl,%edx
  802119:	09 f0                	or     %esi,%eax
  80211b:	83 c4 1c             	add    $0x1c,%esp
  80211e:	5b                   	pop    %ebx
  80211f:	5e                   	pop    %esi
  802120:	5f                   	pop    %edi
  802121:	5d                   	pop    %ebp
  802122:	c3                   	ret    
  802123:	90                   	nop
  802124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802128:	85 ff                	test   %edi,%edi
  80212a:	89 f9                	mov    %edi,%ecx
  80212c:	75 0b                	jne    802139 <__umoddi3+0xe9>
  80212e:	b8 01 00 00 00       	mov    $0x1,%eax
  802133:	31 d2                	xor    %edx,%edx
  802135:	f7 f7                	div    %edi
  802137:	89 c1                	mov    %eax,%ecx
  802139:	89 d8                	mov    %ebx,%eax
  80213b:	31 d2                	xor    %edx,%edx
  80213d:	f7 f1                	div    %ecx
  80213f:	89 f0                	mov    %esi,%eax
  802141:	f7 f1                	div    %ecx
  802143:	e9 31 ff ff ff       	jmp    802079 <__umoddi3+0x29>
  802148:	90                   	nop
  802149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802150:	39 dd                	cmp    %ebx,%ebp
  802152:	72 08                	jb     80215c <__umoddi3+0x10c>
  802154:	39 f7                	cmp    %esi,%edi
  802156:	0f 87 21 ff ff ff    	ja     80207d <__umoddi3+0x2d>
  80215c:	89 da                	mov    %ebx,%edx
  80215e:	89 f0                	mov    %esi,%eax
  802160:	29 f8                	sub    %edi,%eax
  802162:	19 ea                	sbb    %ebp,%edx
  802164:	e9 14 ff ff ff       	jmp    80207d <__umoddi3+0x2d>
