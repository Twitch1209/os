
obj/user/ls.debug：     文件格式 elf32-i386


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
  80002c:	e8 97 02 00 00       	call   8002c8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80003e:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800045:	74 20                	je     800067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800047:	89 f0                	mov    %esi,%eax
  800049:	3c 01                	cmp    $0x1,%al
  80004b:	19 c0                	sbb    %eax,%eax
  80004d:	83 e0 c9             	and    $0xffffffc9,%eax
  800050:	83 c0 64             	add    $0x64,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	ff 75 10             	pushl  0x10(%ebp)
  80005a:	68 e2 21 80 00       	push   $0x8021e2
  80005f:	e8 b7 19 00 00       	call   801a1b <printf>
  800064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  800067:	85 db                	test   %ebx,%ebx
  800069:	74 1c                	je     800087 <ls1+0x54>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006b:	b8 48 22 80 00       	mov    $0x802248,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800070:	80 3b 00             	cmpb   $0x0,(%ebx)
  800073:	75 4b                	jne    8000c0 <ls1+0x8d>
		printf("%s%s", prefix, sep);
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	50                   	push   %eax
  800079:	53                   	push   %ebx
  80007a:	68 eb 21 80 00       	push   $0x8021eb
  80007f:	e8 97 19 00 00       	call   801a1b <printf>
  800084:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	ff 75 14             	pushl  0x14(%ebp)
  80008d:	68 75 26 80 00       	push   $0x802675
  800092:	e8 84 19 00 00       	call   801a1b <printf>
	if(flag['F'] && isdir)
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a1:	74 06                	je     8000a9 <ls1+0x76>
  8000a3:	89 f0                	mov    %esi,%eax
  8000a5:	84 c0                	test   %al,%al
  8000a7:	75 37                	jne    8000e0 <ls1+0xad>
		printf("/");
	printf("\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 47 22 80 00       	push   $0x802247
  8000b1:	e8 65 19 00 00       	call   801a1b <printf>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5e                   	pop    %esi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	53                   	push   %ebx
  8000c4:	e8 ed 08 00 00       	call   8009b6 <strlen>
  8000c9:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000cc:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d1:	b8 e0 21 80 00       	mov    $0x8021e0,%eax
  8000d6:	ba 48 22 80 00       	mov    $0x802248,%edx
  8000db:	0f 44 c2             	cmove  %edx,%eax
  8000de:	eb 95                	jmp    800075 <ls1+0x42>
		printf("/");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 e0 21 80 00       	push   $0x8021e0
  8000e8:	e8 2e 19 00 00       	call   801a1b <printf>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb b7                	jmp    8000a9 <ls1+0x76>

008000f2 <lsdir>:
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	81 ec 14 01 00 00    	sub    $0x114,%esp
  8000fe:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800101:	6a 00                	push   $0x0
  800103:	57                   	push   %edi
  800104:	e8 6e 17 00 00       	call   801877 <open>
  800109:	89 c3                	mov    %eax,%ebx
  80010b:	83 c4 10             	add    $0x10,%esp
  80010e:	85 c0                	test   %eax,%eax
  800110:	78 4a                	js     80015c <lsdir+0x6a>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  800112:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	68 00 01 00 00       	push   $0x100
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	e8 72 13 00 00       	call   801499 <readn>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80012f:	75 41                	jne    800172 <lsdir+0x80>
		if (f.f_name[0])
  800131:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800138:	74 de                	je     800118 <lsdir+0x26>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  80013a:	56                   	push   %esi
  80013b:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800141:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800148:	0f 94 c0             	sete   %al
  80014b:	0f b6 c0             	movzbl %al,%eax
  80014e:	50                   	push   %eax
  80014f:	ff 75 0c             	pushl  0xc(%ebp)
  800152:	e8 dc fe ff ff       	call   800033 <ls1>
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	eb bc                	jmp    800118 <lsdir+0x26>
		panic("open %s: %e", path, fd);
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	50                   	push   %eax
  800160:	57                   	push   %edi
  800161:	68 f0 21 80 00       	push   $0x8021f0
  800166:	6a 1d                	push   $0x1d
  800168:	68 fc 21 80 00       	push   $0x8021fc
  80016d:	e8 b6 01 00 00       	call   800328 <_panic>
	if (n > 0)
  800172:	85 c0                	test   %eax,%eax
  800174:	7f 0c                	jg     800182 <lsdir+0x90>
	if (n < 0)
  800176:	85 c0                	test   %eax,%eax
  800178:	78 1a                	js     800194 <lsdir+0xa2>
}
  80017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017d:	5b                   	pop    %ebx
  80017e:	5e                   	pop    %esi
  80017f:	5f                   	pop    %edi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    
		panic("short read in directory %s", path);
  800182:	57                   	push   %edi
  800183:	68 06 22 80 00       	push   $0x802206
  800188:	6a 22                	push   $0x22
  80018a:	68 fc 21 80 00       	push   $0x8021fc
  80018f:	e8 94 01 00 00       	call   800328 <_panic>
		panic("error reading directory %s: %e", path, n);
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	50                   	push   %eax
  800198:	57                   	push   %edi
  800199:	68 4c 22 80 00       	push   $0x80224c
  80019e:	6a 24                	push   $0x24
  8001a0:	68 fc 21 80 00       	push   $0x8021fc
  8001a5:	e8 7e 01 00 00       	call   800328 <_panic>

008001aa <ls>:
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	53                   	push   %ebx
  8001ae:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001b7:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001bd:	50                   	push   %eax
  8001be:	53                   	push   %ebx
  8001bf:	e8 ba 14 00 00       	call   80167e <stat>
  8001c4:	83 c4 10             	add    $0x10,%esp
  8001c7:	85 c0                	test   %eax,%eax
  8001c9:	78 2c                	js     8001f7 <ls+0x4d>
	if (st.st_isdir && !flag['d'])
  8001cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	74 09                	je     8001db <ls+0x31>
  8001d2:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  8001d9:	74 32                	je     80020d <ls+0x63>
		ls1(0, st.st_isdir, st.st_size, path);
  8001db:	53                   	push   %ebx
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	85 c0                	test   %eax,%eax
  8001e1:	0f 95 c0             	setne  %al
  8001e4:	0f b6 c0             	movzbl %al,%eax
  8001e7:	50                   	push   %eax
  8001e8:	6a 00                	push   $0x0
  8001ea:	e8 44 fe ff ff       	call   800033 <ls1>
  8001ef:	83 c4 10             	add    $0x10,%esp
}
  8001f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    
		panic("stat %s: %e", path, r);
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	50                   	push   %eax
  8001fb:	53                   	push   %ebx
  8001fc:	68 21 22 80 00       	push   $0x802221
  800201:	6a 0f                	push   $0xf
  800203:	68 fc 21 80 00       	push   $0x8021fc
  800208:	e8 1b 01 00 00       	call   800328 <_panic>
		lsdir(path, prefix);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	53                   	push   %ebx
  800214:	e8 d9 fe ff ff       	call   8000f2 <lsdir>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	eb d4                	jmp    8001f2 <ls+0x48>

0080021e <usage>:

void
usage(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800224:	68 2d 22 80 00       	push   $0x80222d
  800229:	e8 ed 17 00 00       	call   801a1b <printf>
	exit();
  80022e:	e8 db 00 00 00       	call   80030e <exit>
}
  800233:	83 c4 10             	add    $0x10,%esp
  800236:	c9                   	leave  
  800237:	c3                   	ret    

00800238 <umain>:

void
umain(int argc, char **argv)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 14             	sub    $0x14,%esp
  800240:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800243:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800246:	50                   	push   %eax
  800247:	56                   	push   %esi
  800248:	8d 45 08             	lea    0x8(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	e8 86 0d 00 00       	call   800fd7 <argstart>
	while ((i = argnext(&args)) >= 0)
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800257:	eb 08                	jmp    800261 <umain+0x29>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800259:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  800260:	01 
	while ((i = argnext(&args)) >= 0)
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	53                   	push   %ebx
  800265:	e8 9d 0d 00 00       	call   801007 <argnext>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	85 c0                	test   %eax,%eax
  80026f:	78 16                	js     800287 <umain+0x4f>
		switch (i) {
  800271:	83 f8 64             	cmp    $0x64,%eax
  800274:	74 e3                	je     800259 <umain+0x21>
  800276:	83 f8 6c             	cmp    $0x6c,%eax
  800279:	74 de                	je     800259 <umain+0x21>
  80027b:	83 f8 46             	cmp    $0x46,%eax
  80027e:	74 d9                	je     800259 <umain+0x21>
			break;
		default:
			usage();
  800280:	e8 99 ff ff ff       	call   80021e <usage>
  800285:	eb da                	jmp    800261 <umain+0x29>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800287:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80028c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800290:	75 2a                	jne    8002bc <umain+0x84>
		ls("/", "");
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	68 48 22 80 00       	push   $0x802248
  80029a:	68 e0 21 80 00       	push   $0x8021e0
  80029f:	e8 06 ff ff ff       	call   8001aa <ls>
  8002a4:	83 c4 10             	add    $0x10,%esp
  8002a7:	eb 18                	jmp    8002c1 <umain+0x89>
			ls(argv[i], argv[i]);
  8002a9:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	50                   	push   %eax
  8002b0:	50                   	push   %eax
  8002b1:	e8 f4 fe ff ff       	call   8001aa <ls>
		for (i = 1; i < argc; i++)
  8002b6:	83 c3 01             	add    $0x1,%ebx
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002bf:	7f e8                	jg     8002a9 <umain+0x71>
	}
}
  8002c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c4:	5b                   	pop    %ebx
  8002c5:	5e                   	pop    %esi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    

008002c8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	56                   	push   %esi
  8002cc:	53                   	push   %ebx
  8002cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002d0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002d3:	e8 d0 0a 00 00       	call   800da8 <sys_getenvid>
  8002d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ea:	85 db                	test   %ebx,%ebx
  8002ec:	7e 07                	jle    8002f5 <libmain+0x2d>
		binaryname = argv[0];
  8002ee:	8b 06                	mov    (%esi),%eax
  8002f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	56                   	push   %esi
  8002f9:	53                   	push   %ebx
  8002fa:	e8 39 ff ff ff       	call   800238 <umain>

	// exit gracefully
	exit();
  8002ff:	e8 0a 00 00 00       	call   80030e <exit>
}
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800314:	e8 e8 0f 00 00       	call   801301 <close_all>
	sys_env_destroy(0);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	6a 00                	push   $0x0
  80031e:	e8 44 0a 00 00       	call   800d67 <sys_env_destroy>
}
  800323:	83 c4 10             	add    $0x10,%esp
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	56                   	push   %esi
  80032c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80032d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800330:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800336:	e8 6d 0a 00 00       	call   800da8 <sys_getenvid>
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	ff 75 0c             	pushl  0xc(%ebp)
  800341:	ff 75 08             	pushl  0x8(%ebp)
  800344:	56                   	push   %esi
  800345:	50                   	push   %eax
  800346:	68 78 22 80 00       	push   $0x802278
  80034b:	e8 b3 00 00 00       	call   800403 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800350:	83 c4 18             	add    $0x18,%esp
  800353:	53                   	push   %ebx
  800354:	ff 75 10             	pushl  0x10(%ebp)
  800357:	e8 56 00 00 00       	call   8003b2 <vcprintf>
	cprintf("\n");
  80035c:	c7 04 24 47 22 80 00 	movl   $0x802247,(%esp)
  800363:	e8 9b 00 00 00       	call   800403 <cprintf>
  800368:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80036b:	cc                   	int3   
  80036c:	eb fd                	jmp    80036b <_panic+0x43>

0080036e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	53                   	push   %ebx
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800378:	8b 13                	mov    (%ebx),%edx
  80037a:	8d 42 01             	lea    0x1(%edx),%eax
  80037d:	89 03                	mov    %eax,(%ebx)
  80037f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800382:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800386:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038b:	74 09                	je     800396 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80038d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800394:	c9                   	leave  
  800395:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800396:	83 ec 08             	sub    $0x8,%esp
  800399:	68 ff 00 00 00       	push   $0xff
  80039e:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a1:	50                   	push   %eax
  8003a2:	e8 83 09 00 00       	call   800d2a <sys_cputs>
		b->idx = 0;
  8003a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003ad:	83 c4 10             	add    $0x10,%esp
  8003b0:	eb db                	jmp    80038d <putch+0x1f>

008003b2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003bb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c2:	00 00 00 
	b.cnt = 0;
  8003c5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003cc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	ff 75 08             	pushl  0x8(%ebp)
  8003d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003db:	50                   	push   %eax
  8003dc:	68 6e 03 80 00       	push   $0x80036e
  8003e1:	e8 1a 01 00 00       	call   800500 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e6:	83 c4 08             	add    $0x8,%esp
  8003e9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003ef:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003f5:	50                   	push   %eax
  8003f6:	e8 2f 09 00 00       	call   800d2a <sys_cputs>

	return b.cnt;
}
  8003fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800401:	c9                   	leave  
  800402:	c3                   	ret    

00800403 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800409:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80040c:	50                   	push   %eax
  80040d:	ff 75 08             	pushl  0x8(%ebp)
  800410:	e8 9d ff ff ff       	call   8003b2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800415:	c9                   	leave  
  800416:	c3                   	ret    

00800417 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	57                   	push   %edi
  80041b:	56                   	push   %esi
  80041c:	53                   	push   %ebx
  80041d:	83 ec 1c             	sub    $0x1c,%esp
  800420:	89 c7                	mov    %eax,%edi
  800422:	89 d6                	mov    %edx,%esi
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80042a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800430:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800433:	bb 00 00 00 00       	mov    $0x0,%ebx
  800438:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80043b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80043e:	39 d3                	cmp    %edx,%ebx
  800440:	72 05                	jb     800447 <printnum+0x30>
  800442:	39 45 10             	cmp    %eax,0x10(%ebp)
  800445:	77 7a                	ja     8004c1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	ff 75 18             	pushl  0x18(%ebp)
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800453:	53                   	push   %ebx
  800454:	ff 75 10             	pushl  0x10(%ebp)
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80045d:	ff 75 e0             	pushl  -0x20(%ebp)
  800460:	ff 75 dc             	pushl  -0x24(%ebp)
  800463:	ff 75 d8             	pushl  -0x28(%ebp)
  800466:	e8 35 1b 00 00       	call   801fa0 <__udivdi3>
  80046b:	83 c4 18             	add    $0x18,%esp
  80046e:	52                   	push   %edx
  80046f:	50                   	push   %eax
  800470:	89 f2                	mov    %esi,%edx
  800472:	89 f8                	mov    %edi,%eax
  800474:	e8 9e ff ff ff       	call   800417 <printnum>
  800479:	83 c4 20             	add    $0x20,%esp
  80047c:	eb 13                	jmp    800491 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	56                   	push   %esi
  800482:	ff 75 18             	pushl  0x18(%ebp)
  800485:	ff d7                	call   *%edi
  800487:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80048a:	83 eb 01             	sub    $0x1,%ebx
  80048d:	85 db                	test   %ebx,%ebx
  80048f:	7f ed                	jg     80047e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	56                   	push   %esi
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049b:	ff 75 e0             	pushl  -0x20(%ebp)
  80049e:	ff 75 dc             	pushl  -0x24(%ebp)
  8004a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a4:	e8 17 1c 00 00       	call   8020c0 <__umoddi3>
  8004a9:	83 c4 14             	add    $0x14,%esp
  8004ac:	0f be 80 9b 22 80 00 	movsbl 0x80229b(%eax),%eax
  8004b3:	50                   	push   %eax
  8004b4:	ff d7                	call   *%edi
}
  8004b6:	83 c4 10             	add    $0x10,%esp
  8004b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bc:	5b                   	pop    %ebx
  8004bd:	5e                   	pop    %esi
  8004be:	5f                   	pop    %edi
  8004bf:	5d                   	pop    %ebp
  8004c0:	c3                   	ret    
  8004c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004c4:	eb c4                	jmp    80048a <printnum+0x73>

008004c6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004cc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d0:	8b 10                	mov    (%eax),%edx
  8004d2:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d5:	73 0a                	jae    8004e1 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004da:	89 08                	mov    %ecx,(%eax)
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	88 02                	mov    %al,(%edx)
}
  8004e1:	5d                   	pop    %ebp
  8004e2:	c3                   	ret    

008004e3 <printfmt>:
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004e9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ec:	50                   	push   %eax
  8004ed:	ff 75 10             	pushl  0x10(%ebp)
  8004f0:	ff 75 0c             	pushl  0xc(%ebp)
  8004f3:	ff 75 08             	pushl  0x8(%ebp)
  8004f6:	e8 05 00 00 00       	call   800500 <vprintfmt>
}
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <vprintfmt>:
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	57                   	push   %edi
  800504:	56                   	push   %esi
  800505:	53                   	push   %ebx
  800506:	83 ec 2c             	sub    $0x2c,%esp
  800509:	8b 75 08             	mov    0x8(%ebp),%esi
  80050c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800512:	e9 8c 03 00 00       	jmp    8008a3 <vprintfmt+0x3a3>
		padc = ' ';
  800517:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80051b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800522:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800529:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800530:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800535:	8d 47 01             	lea    0x1(%edi),%eax
  800538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053b:	0f b6 17             	movzbl (%edi),%edx
  80053e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800541:	3c 55                	cmp    $0x55,%al
  800543:	0f 87 dd 03 00 00    	ja     800926 <vprintfmt+0x426>
  800549:	0f b6 c0             	movzbl %al,%eax
  80054c:	ff 24 85 e0 23 80 00 	jmp    *0x8023e0(,%eax,4)
  800553:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800556:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80055a:	eb d9                	jmp    800535 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80055c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80055f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800563:	eb d0                	jmp    800535 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800565:	0f b6 d2             	movzbl %dl,%edx
  800568:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80056b:	b8 00 00 00 00       	mov    $0x0,%eax
  800570:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800573:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800576:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80057a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80057d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800580:	83 f9 09             	cmp    $0x9,%ecx
  800583:	77 55                	ja     8005da <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800585:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800588:	eb e9                	jmp    800573 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80059e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a2:	79 91                	jns    800535 <vprintfmt+0x35>
				width = precision, precision = -1;
  8005a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005aa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005b1:	eb 82                	jmp    800535 <vprintfmt+0x35>
  8005b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b6:	85 c0                	test   %eax,%eax
  8005b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bd:	0f 49 d0             	cmovns %eax,%edx
  8005c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8005c6:	e9 6a ff ff ff       	jmp    800535 <vprintfmt+0x35>
  8005cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005ce:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8005d5:	e9 5b ff ff ff       	jmp    800535 <vprintfmt+0x35>
  8005da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e0:	eb bc                	jmp    80059e <vprintfmt+0x9e>
			lflag++;
  8005e2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005e8:	e9 48 ff ff ff       	jmp    800535 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8d 78 04             	lea    0x4(%eax),%edi
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	ff 30                	pushl  (%eax)
  8005f9:	ff d6                	call   *%esi
			break;
  8005fb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005fe:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800601:	e9 9a 02 00 00       	jmp    8008a0 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8d 78 04             	lea    0x4(%eax),%edi
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	99                   	cltd   
  80060f:	31 d0                	xor    %edx,%eax
  800611:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800613:	83 f8 0f             	cmp    $0xf,%eax
  800616:	7f 23                	jg     80063b <vprintfmt+0x13b>
  800618:	8b 14 85 40 25 80 00 	mov    0x802540(,%eax,4),%edx
  80061f:	85 d2                	test   %edx,%edx
  800621:	74 18                	je     80063b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800623:	52                   	push   %edx
  800624:	68 75 26 80 00       	push   $0x802675
  800629:	53                   	push   %ebx
  80062a:	56                   	push   %esi
  80062b:	e8 b3 fe ff ff       	call   8004e3 <printfmt>
  800630:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800633:	89 7d 14             	mov    %edi,0x14(%ebp)
  800636:	e9 65 02 00 00       	jmp    8008a0 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80063b:	50                   	push   %eax
  80063c:	68 b3 22 80 00       	push   $0x8022b3
  800641:	53                   	push   %ebx
  800642:	56                   	push   %esi
  800643:	e8 9b fe ff ff       	call   8004e3 <printfmt>
  800648:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80064b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80064e:	e9 4d 02 00 00       	jmp    8008a0 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	83 c0 04             	add    $0x4,%eax
  800659:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800661:	85 ff                	test   %edi,%edi
  800663:	b8 ac 22 80 00       	mov    $0x8022ac,%eax
  800668:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80066b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066f:	0f 8e bd 00 00 00    	jle    800732 <vprintfmt+0x232>
  800675:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800679:	75 0e                	jne    800689 <vprintfmt+0x189>
  80067b:	89 75 08             	mov    %esi,0x8(%ebp)
  80067e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800681:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800684:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800687:	eb 6d                	jmp    8006f6 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800689:	83 ec 08             	sub    $0x8,%esp
  80068c:	ff 75 d0             	pushl  -0x30(%ebp)
  80068f:	57                   	push   %edi
  800690:	e8 39 03 00 00       	call   8009ce <strnlen>
  800695:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800698:	29 c1                	sub    %eax,%ecx
  80069a:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80069d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8006a0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8006a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8006aa:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ac:	eb 0f                	jmp    8006bd <vprintfmt+0x1bd>
					putch(padc, putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	53                   	push   %ebx
  8006b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b7:	83 ef 01             	sub    $0x1,%edi
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	85 ff                	test   %edi,%edi
  8006bf:	7f ed                	jg     8006ae <vprintfmt+0x1ae>
  8006c1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8006c4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8006c7:	85 c9                	test   %ecx,%ecx
  8006c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ce:	0f 49 c1             	cmovns %ecx,%eax
  8006d1:	29 c1                	sub    %eax,%ecx
  8006d3:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8006dc:	89 cb                	mov    %ecx,%ebx
  8006de:	eb 16                	jmp    8006f6 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006e4:	75 31                	jne    800717 <vprintfmt+0x217>
					putch(ch, putdat);
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	ff 55 08             	call   *0x8(%ebp)
  8006f0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f3:	83 eb 01             	sub    $0x1,%ebx
  8006f6:	83 c7 01             	add    $0x1,%edi
  8006f9:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8006fd:	0f be c2             	movsbl %dl,%eax
  800700:	85 c0                	test   %eax,%eax
  800702:	74 59                	je     80075d <vprintfmt+0x25d>
  800704:	85 f6                	test   %esi,%esi
  800706:	78 d8                	js     8006e0 <vprintfmt+0x1e0>
  800708:	83 ee 01             	sub    $0x1,%esi
  80070b:	79 d3                	jns    8006e0 <vprintfmt+0x1e0>
  80070d:	89 df                	mov    %ebx,%edi
  80070f:	8b 75 08             	mov    0x8(%ebp),%esi
  800712:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800715:	eb 37                	jmp    80074e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800717:	0f be d2             	movsbl %dl,%edx
  80071a:	83 ea 20             	sub    $0x20,%edx
  80071d:	83 fa 5e             	cmp    $0x5e,%edx
  800720:	76 c4                	jbe    8006e6 <vprintfmt+0x1e6>
					putch('?', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	6a 3f                	push   $0x3f
  80072a:	ff 55 08             	call   *0x8(%ebp)
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	eb c1                	jmp    8006f3 <vprintfmt+0x1f3>
  800732:	89 75 08             	mov    %esi,0x8(%ebp)
  800735:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800738:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80073b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80073e:	eb b6                	jmp    8006f6 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 20                	push   $0x20
  800746:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800748:	83 ef 01             	sub    $0x1,%edi
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	85 ff                	test   %edi,%edi
  800750:	7f ee                	jg     800740 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800752:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
  800758:	e9 43 01 00 00       	jmp    8008a0 <vprintfmt+0x3a0>
  80075d:	89 df                	mov    %ebx,%edi
  80075f:	8b 75 08             	mov    0x8(%ebp),%esi
  800762:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800765:	eb e7                	jmp    80074e <vprintfmt+0x24e>
	if (lflag >= 2)
  800767:	83 f9 01             	cmp    $0x1,%ecx
  80076a:	7e 3f                	jle    8007ab <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 50 04             	mov    0x4(%eax),%edx
  800772:	8b 00                	mov    (%eax),%eax
  800774:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800777:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8d 40 08             	lea    0x8(%eax),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800783:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800787:	79 5c                	jns    8007e5 <vprintfmt+0x2e5>
				putch('-', putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	6a 2d                	push   $0x2d
  80078f:	ff d6                	call   *%esi
				num = -(long long) num;
  800791:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800794:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800797:	f7 da                	neg    %edx
  800799:	83 d1 00             	adc    $0x0,%ecx
  80079c:	f7 d9                	neg    %ecx
  80079e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a6:	e9 db 00 00 00       	jmp    800886 <vprintfmt+0x386>
	else if (lflag)
  8007ab:	85 c9                	test   %ecx,%ecx
  8007ad:	75 1b                	jne    8007ca <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b7:	89 c1                	mov    %eax,%ecx
  8007b9:	c1 f9 1f             	sar    $0x1f,%ecx
  8007bc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 40 04             	lea    0x4(%eax),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c8:	eb b9                	jmp    800783 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 c1                	mov    %eax,%ecx
  8007d4:	c1 f9 1f             	sar    $0x1f,%ecx
  8007d7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007e3:	eb 9e                	jmp    800783 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8007e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f0:	e9 91 00 00 00       	jmp    800886 <vprintfmt+0x386>
	if (lflag >= 2)
  8007f5:	83 f9 01             	cmp    $0x1,%ecx
  8007f8:	7e 15                	jle    80080f <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8b 10                	mov    (%eax),%edx
  8007ff:	8b 48 04             	mov    0x4(%eax),%ecx
  800802:	8d 40 08             	lea    0x8(%eax),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800808:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080d:	eb 77                	jmp    800886 <vprintfmt+0x386>
	else if (lflag)
  80080f:	85 c9                	test   %ecx,%ecx
  800811:	75 17                	jne    80082a <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8b 10                	mov    (%eax),%edx
  800818:	b9 00 00 00 00       	mov    $0x0,%ecx
  80081d:	8d 40 04             	lea    0x4(%eax),%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800823:	b8 0a 00 00 00       	mov    $0xa,%eax
  800828:	eb 5c                	jmp    800886 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80082a:	8b 45 14             	mov    0x14(%ebp),%eax
  80082d:	8b 10                	mov    (%eax),%edx
  80082f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800834:	8d 40 04             	lea    0x4(%eax),%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80083a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083f:	eb 45                	jmp    800886 <vprintfmt+0x386>
			putch('X', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	53                   	push   %ebx
  800845:	6a 58                	push   $0x58
  800847:	ff d6                	call   *%esi
			putch('X', putdat);
  800849:	83 c4 08             	add    $0x8,%esp
  80084c:	53                   	push   %ebx
  80084d:	6a 58                	push   $0x58
  80084f:	ff d6                	call   *%esi
			putch('X', putdat);
  800851:	83 c4 08             	add    $0x8,%esp
  800854:	53                   	push   %ebx
  800855:	6a 58                	push   $0x58
  800857:	ff d6                	call   *%esi
			break;
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	eb 42                	jmp    8008a0 <vprintfmt+0x3a0>
			putch('0', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	53                   	push   %ebx
  800862:	6a 30                	push   $0x30
  800864:	ff d6                	call   *%esi
			putch('x', putdat);
  800866:	83 c4 08             	add    $0x8,%esp
  800869:	53                   	push   %ebx
  80086a:	6a 78                	push   $0x78
  80086c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	8b 10                	mov    (%eax),%edx
  800873:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800878:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80087b:	8d 40 04             	lea    0x4(%eax),%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800881:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800886:	83 ec 0c             	sub    $0xc,%esp
  800889:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80088d:	57                   	push   %edi
  80088e:	ff 75 e0             	pushl  -0x20(%ebp)
  800891:	50                   	push   %eax
  800892:	51                   	push   %ecx
  800893:	52                   	push   %edx
  800894:	89 da                	mov    %ebx,%edx
  800896:	89 f0                	mov    %esi,%eax
  800898:	e8 7a fb ff ff       	call   800417 <printnum>
			break;
  80089d:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8008a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a3:	83 c7 01             	add    $0x1,%edi
  8008a6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008aa:	83 f8 25             	cmp    $0x25,%eax
  8008ad:	0f 84 64 fc ff ff    	je     800517 <vprintfmt+0x17>
			if (ch == '\0')
  8008b3:	85 c0                	test   %eax,%eax
  8008b5:	0f 84 8b 00 00 00    	je     800946 <vprintfmt+0x446>
			putch(ch, putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	53                   	push   %ebx
  8008bf:	50                   	push   %eax
  8008c0:	ff d6                	call   *%esi
  8008c2:	83 c4 10             	add    $0x10,%esp
  8008c5:	eb dc                	jmp    8008a3 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8008c7:	83 f9 01             	cmp    $0x1,%ecx
  8008ca:	7e 15                	jle    8008e1 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	8b 10                	mov    (%eax),%edx
  8008d1:	8b 48 04             	mov    0x4(%eax),%ecx
  8008d4:	8d 40 08             	lea    0x8(%eax),%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008da:	b8 10 00 00 00       	mov    $0x10,%eax
  8008df:	eb a5                	jmp    800886 <vprintfmt+0x386>
	else if (lflag)
  8008e1:	85 c9                	test   %ecx,%ecx
  8008e3:	75 17                	jne    8008fc <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8008e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e8:	8b 10                	mov    (%eax),%edx
  8008ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008ef:	8d 40 04             	lea    0x4(%eax),%eax
  8008f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f5:	b8 10 00 00 00       	mov    $0x10,%eax
  8008fa:	eb 8a                	jmp    800886 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8008fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ff:	8b 10                	mov    (%eax),%edx
  800901:	b9 00 00 00 00       	mov    $0x0,%ecx
  800906:	8d 40 04             	lea    0x4(%eax),%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090c:	b8 10 00 00 00       	mov    $0x10,%eax
  800911:	e9 70 ff ff ff       	jmp    800886 <vprintfmt+0x386>
			putch(ch, putdat);
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	53                   	push   %ebx
  80091a:	6a 25                	push   $0x25
  80091c:	ff d6                	call   *%esi
			break;
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	e9 7a ff ff ff       	jmp    8008a0 <vprintfmt+0x3a0>
			putch('%', putdat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	53                   	push   %ebx
  80092a:	6a 25                	push   $0x25
  80092c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80092e:	83 c4 10             	add    $0x10,%esp
  800931:	89 f8                	mov    %edi,%eax
  800933:	eb 03                	jmp    800938 <vprintfmt+0x438>
  800935:	83 e8 01             	sub    $0x1,%eax
  800938:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80093c:	75 f7                	jne    800935 <vprintfmt+0x435>
  80093e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800941:	e9 5a ff ff ff       	jmp    8008a0 <vprintfmt+0x3a0>
}
  800946:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800949:	5b                   	pop    %ebx
  80094a:	5e                   	pop    %esi
  80094b:	5f                   	pop    %edi
  80094c:	5d                   	pop    %ebp
  80094d:	c3                   	ret    

0080094e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	83 ec 18             	sub    $0x18,%esp
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80095a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80095d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800961:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800964:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80096b:	85 c0                	test   %eax,%eax
  80096d:	74 26                	je     800995 <vsnprintf+0x47>
  80096f:	85 d2                	test   %edx,%edx
  800971:	7e 22                	jle    800995 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800973:	ff 75 14             	pushl  0x14(%ebp)
  800976:	ff 75 10             	pushl  0x10(%ebp)
  800979:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80097c:	50                   	push   %eax
  80097d:	68 c6 04 80 00       	push   $0x8004c6
  800982:	e8 79 fb ff ff       	call   800500 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80098a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80098d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800990:	83 c4 10             	add    $0x10,%esp
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    
		return -E_INVAL;
  800995:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80099a:	eb f7                	jmp    800993 <vsnprintf+0x45>

0080099c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 10             	pushl  0x10(%ebp)
  8009a9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ac:	ff 75 08             	pushl  0x8(%ebp)
  8009af:	e8 9a ff ff ff       	call   80094e <vsnprintf>
	va_end(ap);

	return rc;
}
  8009b4:	c9                   	leave  
  8009b5:	c3                   	ret    

008009b6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c1:	eb 03                	jmp    8009c6 <strlen+0x10>
		n++;
  8009c3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8009c6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ca:	75 f7                	jne    8009c3 <strlen+0xd>
	return n;
}
  8009cc:	5d                   	pop    %ebp
  8009cd:	c3                   	ret    

008009ce <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009ce:	55                   	push   %ebp
  8009cf:	89 e5                	mov    %esp,%ebp
  8009d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009dc:	eb 03                	jmp    8009e1 <strnlen+0x13>
		n++;
  8009de:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e1:	39 d0                	cmp    %edx,%eax
  8009e3:	74 06                	je     8009eb <strnlen+0x1d>
  8009e5:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009e9:	75 f3                	jne    8009de <strnlen+0x10>
	return n;
}
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    

008009ed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	53                   	push   %ebx
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009f7:	89 c2                	mov    %eax,%edx
  8009f9:	83 c1 01             	add    $0x1,%ecx
  8009fc:	83 c2 01             	add    $0x1,%edx
  8009ff:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a03:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a06:	84 db                	test   %bl,%bl
  800a08:	75 ef                	jne    8009f9 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a0a:	5b                   	pop    %ebx
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	53                   	push   %ebx
  800a11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a14:	53                   	push   %ebx
  800a15:	e8 9c ff ff ff       	call   8009b6 <strlen>
  800a1a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	01 d8                	add    %ebx,%eax
  800a22:	50                   	push   %eax
  800a23:	e8 c5 ff ff ff       	call   8009ed <strcpy>
	return dst;
}
  800a28:	89 d8                	mov    %ebx,%eax
  800a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	56                   	push   %esi
  800a33:	53                   	push   %ebx
  800a34:	8b 75 08             	mov    0x8(%ebp),%esi
  800a37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a3a:	89 f3                	mov    %esi,%ebx
  800a3c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a3f:	89 f2                	mov    %esi,%edx
  800a41:	eb 0f                	jmp    800a52 <strncpy+0x23>
		*dst++ = *src;
  800a43:	83 c2 01             	add    $0x1,%edx
  800a46:	0f b6 01             	movzbl (%ecx),%eax
  800a49:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a4c:	80 39 01             	cmpb   $0x1,(%ecx)
  800a4f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800a52:	39 da                	cmp    %ebx,%edx
  800a54:	75 ed                	jne    800a43 <strncpy+0x14>
	}
	return ret;
}
  800a56:	89 f0                	mov    %esi,%eax
  800a58:	5b                   	pop    %ebx
  800a59:	5e                   	pop    %esi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	56                   	push   %esi
  800a60:	53                   	push   %ebx
  800a61:	8b 75 08             	mov    0x8(%ebp),%esi
  800a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a67:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a6a:	89 f0                	mov    %esi,%eax
  800a6c:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a70:	85 c9                	test   %ecx,%ecx
  800a72:	75 0b                	jne    800a7f <strlcpy+0x23>
  800a74:	eb 17                	jmp    800a8d <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a76:	83 c2 01             	add    $0x1,%edx
  800a79:	83 c0 01             	add    $0x1,%eax
  800a7c:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a7f:	39 d8                	cmp    %ebx,%eax
  800a81:	74 07                	je     800a8a <strlcpy+0x2e>
  800a83:	0f b6 0a             	movzbl (%edx),%ecx
  800a86:	84 c9                	test   %cl,%cl
  800a88:	75 ec                	jne    800a76 <strlcpy+0x1a>
		*dst = '\0';
  800a8a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a8d:	29 f0                	sub    %esi,%eax
}
  800a8f:	5b                   	pop    %ebx
  800a90:	5e                   	pop    %esi
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a9c:	eb 06                	jmp    800aa4 <strcmp+0x11>
		p++, q++;
  800a9e:	83 c1 01             	add    $0x1,%ecx
  800aa1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800aa4:	0f b6 01             	movzbl (%ecx),%eax
  800aa7:	84 c0                	test   %al,%al
  800aa9:	74 04                	je     800aaf <strcmp+0x1c>
  800aab:	3a 02                	cmp    (%edx),%al
  800aad:	74 ef                	je     800a9e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aaf:	0f b6 c0             	movzbl %al,%eax
  800ab2:	0f b6 12             	movzbl (%edx),%edx
  800ab5:	29 d0                	sub    %edx,%eax
}
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	53                   	push   %ebx
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac3:	89 c3                	mov    %eax,%ebx
  800ac5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ac8:	eb 06                	jmp    800ad0 <strncmp+0x17>
		n--, p++, q++;
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ad0:	39 d8                	cmp    %ebx,%eax
  800ad2:	74 16                	je     800aea <strncmp+0x31>
  800ad4:	0f b6 08             	movzbl (%eax),%ecx
  800ad7:	84 c9                	test   %cl,%cl
  800ad9:	74 04                	je     800adf <strncmp+0x26>
  800adb:	3a 0a                	cmp    (%edx),%cl
  800add:	74 eb                	je     800aca <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800adf:	0f b6 00             	movzbl (%eax),%eax
  800ae2:	0f b6 12             	movzbl (%edx),%edx
  800ae5:	29 d0                	sub    %edx,%eax
}
  800ae7:	5b                   	pop    %ebx
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    
		return 0;
  800aea:	b8 00 00 00 00       	mov    $0x0,%eax
  800aef:	eb f6                	jmp    800ae7 <strncmp+0x2e>

00800af1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800afb:	0f b6 10             	movzbl (%eax),%edx
  800afe:	84 d2                	test   %dl,%dl
  800b00:	74 09                	je     800b0b <strchr+0x1a>
		if (*s == c)
  800b02:	38 ca                	cmp    %cl,%dl
  800b04:	74 0a                	je     800b10 <strchr+0x1f>
	for (; *s; s++)
  800b06:	83 c0 01             	add    $0x1,%eax
  800b09:	eb f0                	jmp    800afb <strchr+0xa>
			return (char *) s;
	return 0;
  800b0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b1c:	eb 03                	jmp    800b21 <strfind+0xf>
  800b1e:	83 c0 01             	add    $0x1,%eax
  800b21:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b24:	38 ca                	cmp    %cl,%dl
  800b26:	74 04                	je     800b2c <strfind+0x1a>
  800b28:	84 d2                	test   %dl,%dl
  800b2a:	75 f2                	jne    800b1e <strfind+0xc>
			break;
	return (char *) s;
}
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    

00800b2e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	57                   	push   %edi
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b37:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b3a:	85 c9                	test   %ecx,%ecx
  800b3c:	74 13                	je     800b51 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b3e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b44:	75 05                	jne    800b4b <memset+0x1d>
  800b46:	f6 c1 03             	test   $0x3,%cl
  800b49:	74 0d                	je     800b58 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	fc                   	cld    
  800b4f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b51:	89 f8                	mov    %edi,%eax
  800b53:	5b                   	pop    %ebx
  800b54:	5e                   	pop    %esi
  800b55:	5f                   	pop    %edi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    
		c &= 0xFF;
  800b58:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b5c:	89 d3                	mov    %edx,%ebx
  800b5e:	c1 e3 08             	shl    $0x8,%ebx
  800b61:	89 d0                	mov    %edx,%eax
  800b63:	c1 e0 18             	shl    $0x18,%eax
  800b66:	89 d6                	mov    %edx,%esi
  800b68:	c1 e6 10             	shl    $0x10,%esi
  800b6b:	09 f0                	or     %esi,%eax
  800b6d:	09 c2                	or     %eax,%edx
  800b6f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800b71:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b74:	89 d0                	mov    %edx,%eax
  800b76:	fc                   	cld    
  800b77:	f3 ab                	rep stos %eax,%es:(%edi)
  800b79:	eb d6                	jmp    800b51 <memset+0x23>

00800b7b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	57                   	push   %edi
  800b7f:	56                   	push   %esi
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b86:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b89:	39 c6                	cmp    %eax,%esi
  800b8b:	73 35                	jae    800bc2 <memmove+0x47>
  800b8d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b90:	39 c2                	cmp    %eax,%edx
  800b92:	76 2e                	jbe    800bc2 <memmove+0x47>
		s += n;
		d += n;
  800b94:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b97:	89 d6                	mov    %edx,%esi
  800b99:	09 fe                	or     %edi,%esi
  800b9b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ba1:	74 0c                	je     800baf <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ba3:	83 ef 01             	sub    $0x1,%edi
  800ba6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ba9:	fd                   	std    
  800baa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bac:	fc                   	cld    
  800bad:	eb 21                	jmp    800bd0 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800baf:	f6 c1 03             	test   $0x3,%cl
  800bb2:	75 ef                	jne    800ba3 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bb4:	83 ef 04             	sub    $0x4,%edi
  800bb7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bba:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bbd:	fd                   	std    
  800bbe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc0:	eb ea                	jmp    800bac <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc2:	89 f2                	mov    %esi,%edx
  800bc4:	09 c2                	or     %eax,%edx
  800bc6:	f6 c2 03             	test   $0x3,%dl
  800bc9:	74 09                	je     800bd4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bcb:	89 c7                	mov    %eax,%edi
  800bcd:	fc                   	cld    
  800bce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd4:	f6 c1 03             	test   $0x3,%cl
  800bd7:	75 f2                	jne    800bcb <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bd9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bdc:	89 c7                	mov    %eax,%edi
  800bde:	fc                   	cld    
  800bdf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800be1:	eb ed                	jmp    800bd0 <memmove+0x55>

00800be3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800be6:	ff 75 10             	pushl  0x10(%ebp)
  800be9:	ff 75 0c             	pushl  0xc(%ebp)
  800bec:	ff 75 08             	pushl  0x8(%ebp)
  800bef:	e8 87 ff ff ff       	call   800b7b <memmove>
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	56                   	push   %esi
  800bfa:	53                   	push   %ebx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c01:	89 c6                	mov    %eax,%esi
  800c03:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c06:	39 f0                	cmp    %esi,%eax
  800c08:	74 1c                	je     800c26 <memcmp+0x30>
		if (*s1 != *s2)
  800c0a:	0f b6 08             	movzbl (%eax),%ecx
  800c0d:	0f b6 1a             	movzbl (%edx),%ebx
  800c10:	38 d9                	cmp    %bl,%cl
  800c12:	75 08                	jne    800c1c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c14:	83 c0 01             	add    $0x1,%eax
  800c17:	83 c2 01             	add    $0x1,%edx
  800c1a:	eb ea                	jmp    800c06 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c1c:	0f b6 c1             	movzbl %cl,%eax
  800c1f:	0f b6 db             	movzbl %bl,%ebx
  800c22:	29 d8                	sub    %ebx,%eax
  800c24:	eb 05                	jmp    800c2b <memcmp+0x35>
	}

	return 0;
  800c26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c2b:	5b                   	pop    %ebx
  800c2c:	5e                   	pop    %esi
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c38:	89 c2                	mov    %eax,%edx
  800c3a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c3d:	39 d0                	cmp    %edx,%eax
  800c3f:	73 09                	jae    800c4a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c41:	38 08                	cmp    %cl,(%eax)
  800c43:	74 05                	je     800c4a <memfind+0x1b>
	for (; s < ends; s++)
  800c45:	83 c0 01             	add    $0x1,%eax
  800c48:	eb f3                	jmp    800c3d <memfind+0xe>
			break;
	return (void *) s;
}
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	57                   	push   %edi
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c58:	eb 03                	jmp    800c5d <strtol+0x11>
		s++;
  800c5a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c5d:	0f b6 01             	movzbl (%ecx),%eax
  800c60:	3c 20                	cmp    $0x20,%al
  800c62:	74 f6                	je     800c5a <strtol+0xe>
  800c64:	3c 09                	cmp    $0x9,%al
  800c66:	74 f2                	je     800c5a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c68:	3c 2b                	cmp    $0x2b,%al
  800c6a:	74 2e                	je     800c9a <strtol+0x4e>
	int neg = 0;
  800c6c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c71:	3c 2d                	cmp    $0x2d,%al
  800c73:	74 2f                	je     800ca4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c75:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c7b:	75 05                	jne    800c82 <strtol+0x36>
  800c7d:	80 39 30             	cmpb   $0x30,(%ecx)
  800c80:	74 2c                	je     800cae <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c82:	85 db                	test   %ebx,%ebx
  800c84:	75 0a                	jne    800c90 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c86:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800c8b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c8e:	74 28                	je     800cb8 <strtol+0x6c>
		base = 10;
  800c90:	b8 00 00 00 00       	mov    $0x0,%eax
  800c95:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c98:	eb 50                	jmp    800cea <strtol+0x9e>
		s++;
  800c9a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c9d:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca2:	eb d1                	jmp    800c75 <strtol+0x29>
		s++, neg = 1;
  800ca4:	83 c1 01             	add    $0x1,%ecx
  800ca7:	bf 01 00 00 00       	mov    $0x1,%edi
  800cac:	eb c7                	jmp    800c75 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cae:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cb2:	74 0e                	je     800cc2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800cb4:	85 db                	test   %ebx,%ebx
  800cb6:	75 d8                	jne    800c90 <strtol+0x44>
		s++, base = 8;
  800cb8:	83 c1 01             	add    $0x1,%ecx
  800cbb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cc0:	eb ce                	jmp    800c90 <strtol+0x44>
		s += 2, base = 16;
  800cc2:	83 c1 02             	add    $0x2,%ecx
  800cc5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cca:	eb c4                	jmp    800c90 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ccc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ccf:	89 f3                	mov    %esi,%ebx
  800cd1:	80 fb 19             	cmp    $0x19,%bl
  800cd4:	77 29                	ja     800cff <strtol+0xb3>
			dig = *s - 'a' + 10;
  800cd6:	0f be d2             	movsbl %dl,%edx
  800cd9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cdc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cdf:	7d 30                	jge    800d11 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ce1:	83 c1 01             	add    $0x1,%ecx
  800ce4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ce8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cea:	0f b6 11             	movzbl (%ecx),%edx
  800ced:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cf0:	89 f3                	mov    %esi,%ebx
  800cf2:	80 fb 09             	cmp    $0x9,%bl
  800cf5:	77 d5                	ja     800ccc <strtol+0x80>
			dig = *s - '0';
  800cf7:	0f be d2             	movsbl %dl,%edx
  800cfa:	83 ea 30             	sub    $0x30,%edx
  800cfd:	eb dd                	jmp    800cdc <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800cff:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d02:	89 f3                	mov    %esi,%ebx
  800d04:	80 fb 19             	cmp    $0x19,%bl
  800d07:	77 08                	ja     800d11 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d09:	0f be d2             	movsbl %dl,%edx
  800d0c:	83 ea 37             	sub    $0x37,%edx
  800d0f:	eb cb                	jmp    800cdc <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d15:	74 05                	je     800d1c <strtol+0xd0>
		*endptr = (char *) s;
  800d17:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d1a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d1c:	89 c2                	mov    %eax,%edx
  800d1e:	f7 da                	neg    %edx
  800d20:	85 ff                	test   %edi,%edi
  800d22:	0f 45 c2             	cmovne %edx,%eax
}
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d30:	b8 00 00 00 00       	mov    $0x0,%eax
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	89 c3                	mov    %eax,%ebx
  800d3d:	89 c7                	mov    %eax,%edi
  800d3f:	89 c6                	mov    %eax,%esi
  800d41:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d53:	b8 01 00 00 00       	mov    $0x1,%eax
  800d58:	89 d1                	mov    %edx,%ecx
  800d5a:	89 d3                	mov    %edx,%ebx
  800d5c:	89 d7                	mov    %edx,%edi
  800d5e:	89 d6                	mov    %edx,%esi
  800d60:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	57                   	push   %edi
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
  800d6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d70:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d75:	8b 55 08             	mov    0x8(%ebp),%edx
  800d78:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7d:	89 cb                	mov    %ecx,%ebx
  800d7f:	89 cf                	mov    %ecx,%edi
  800d81:	89 ce                	mov    %ecx,%esi
  800d83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d85:	85 c0                	test   %eax,%eax
  800d87:	7f 08                	jg     800d91 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8c:	5b                   	pop    %ebx
  800d8d:	5e                   	pop    %esi
  800d8e:	5f                   	pop    %edi
  800d8f:	5d                   	pop    %ebp
  800d90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d91:	83 ec 0c             	sub    $0xc,%esp
  800d94:	50                   	push   %eax
  800d95:	6a 03                	push   $0x3
  800d97:	68 9f 25 80 00       	push   $0x80259f
  800d9c:	6a 23                	push   $0x23
  800d9e:	68 bc 25 80 00       	push   $0x8025bc
  800da3:	e8 80 f5 ff ff       	call   800328 <_panic>

00800da8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	57                   	push   %edi
  800dac:	56                   	push   %esi
  800dad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dae:	ba 00 00 00 00       	mov    $0x0,%edx
  800db3:	b8 02 00 00 00       	mov    $0x2,%eax
  800db8:	89 d1                	mov    %edx,%ecx
  800dba:	89 d3                	mov    %edx,%ebx
  800dbc:	89 d7                	mov    %edx,%edi
  800dbe:	89 d6                	mov    %edx,%esi
  800dc0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dc2:	5b                   	pop    %ebx
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <sys_yield>:

void
sys_yield(void)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dd7:	89 d1                	mov    %edx,%ecx
  800dd9:	89 d3                	mov    %edx,%ebx
  800ddb:	89 d7                	mov    %edx,%edi
  800ddd:	89 d6                	mov    %edx,%esi
  800ddf:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
  800dec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800def:	be 00 00 00 00       	mov    $0x0,%esi
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfa:	b8 04 00 00 00       	mov    $0x4,%eax
  800dff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e02:	89 f7                	mov    %esi,%edi
  800e04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	7f 08                	jg     800e12 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0d:	5b                   	pop    %ebx
  800e0e:	5e                   	pop    %esi
  800e0f:	5f                   	pop    %edi
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e12:	83 ec 0c             	sub    $0xc,%esp
  800e15:	50                   	push   %eax
  800e16:	6a 04                	push   $0x4
  800e18:	68 9f 25 80 00       	push   $0x80259f
  800e1d:	6a 23                	push   $0x23
  800e1f:	68 bc 25 80 00       	push   $0x8025bc
  800e24:	e8 ff f4 ff ff       	call   800328 <_panic>

00800e29 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e38:	b8 05 00 00 00       	mov    $0x5,%eax
  800e3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e40:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e43:	8b 75 18             	mov    0x18(%ebp),%esi
  800e46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e48:	85 c0                	test   %eax,%eax
  800e4a:	7f 08                	jg     800e54 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4f:	5b                   	pop    %ebx
  800e50:	5e                   	pop    %esi
  800e51:	5f                   	pop    %edi
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	50                   	push   %eax
  800e58:	6a 05                	push   $0x5
  800e5a:	68 9f 25 80 00       	push   $0x80259f
  800e5f:	6a 23                	push   $0x23
  800e61:	68 bc 25 80 00       	push   $0x8025bc
  800e66:	e8 bd f4 ff ff       	call   800328 <_panic>

00800e6b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	57                   	push   %edi
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
  800e71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7f:	b8 06 00 00 00       	mov    $0x6,%eax
  800e84:	89 df                	mov    %ebx,%edi
  800e86:	89 de                	mov    %ebx,%esi
  800e88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8a:	85 c0                	test   %eax,%eax
  800e8c:	7f 08                	jg     800e96 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e96:	83 ec 0c             	sub    $0xc,%esp
  800e99:	50                   	push   %eax
  800e9a:	6a 06                	push   $0x6
  800e9c:	68 9f 25 80 00       	push   $0x80259f
  800ea1:	6a 23                	push   $0x23
  800ea3:	68 bc 25 80 00       	push   $0x8025bc
  800ea8:	e8 7b f4 ff ff       	call   800328 <_panic>

00800ead <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec6:	89 df                	mov    %ebx,%edi
  800ec8:	89 de                	mov    %ebx,%esi
  800eca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	7f 08                	jg     800ed8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5f                   	pop    %edi
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	50                   	push   %eax
  800edc:	6a 08                	push   $0x8
  800ede:	68 9f 25 80 00       	push   $0x80259f
  800ee3:	6a 23                	push   $0x23
  800ee5:	68 bc 25 80 00       	push   $0x8025bc
  800eea:	e8 39 f4 ff ff       	call   800328 <_panic>

00800eef <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
  800ef5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f03:	b8 09 00 00 00       	mov    $0x9,%eax
  800f08:	89 df                	mov    %ebx,%edi
  800f0a:	89 de                	mov    %ebx,%esi
  800f0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	7f 08                	jg     800f1a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1a:	83 ec 0c             	sub    $0xc,%esp
  800f1d:	50                   	push   %eax
  800f1e:	6a 09                	push   $0x9
  800f20:	68 9f 25 80 00       	push   $0x80259f
  800f25:	6a 23                	push   $0x23
  800f27:	68 bc 25 80 00       	push   $0x8025bc
  800f2c:	e8 f7 f3 ff ff       	call   800328 <_panic>

00800f31 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	57                   	push   %edi
  800f35:	56                   	push   %esi
  800f36:	53                   	push   %ebx
  800f37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f45:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f4a:	89 df                	mov    %ebx,%edi
  800f4c:	89 de                	mov    %ebx,%esi
  800f4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f50:	85 c0                	test   %eax,%eax
  800f52:	7f 08                	jg     800f5c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5c:	83 ec 0c             	sub    $0xc,%esp
  800f5f:	50                   	push   %eax
  800f60:	6a 0a                	push   $0xa
  800f62:	68 9f 25 80 00       	push   $0x80259f
  800f67:	6a 23                	push   $0x23
  800f69:	68 bc 25 80 00       	push   $0x8025bc
  800f6e:	e8 b5 f3 ff ff       	call   800328 <_panic>

00800f73 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	57                   	push   %edi
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f84:	be 00 00 00 00       	mov    $0x0,%esi
  800f89:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f8f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	57                   	push   %edi
  800f9a:	56                   	push   %esi
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fac:	89 cb                	mov    %ecx,%ebx
  800fae:	89 cf                	mov    %ecx,%edi
  800fb0:	89 ce                	mov    %ecx,%esi
  800fb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	7f 08                	jg     800fc0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc0:	83 ec 0c             	sub    $0xc,%esp
  800fc3:	50                   	push   %eax
  800fc4:	6a 0d                	push   $0xd
  800fc6:	68 9f 25 80 00       	push   $0x80259f
  800fcb:	6a 23                	push   $0x23
  800fcd:	68 bc 25 80 00       	push   $0x8025bc
  800fd2:	e8 51 f3 ff ff       	call   800328 <_panic>

00800fd7 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe0:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800fe3:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800fe5:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800fe8:	83 3a 01             	cmpl   $0x1,(%edx)
  800feb:	7e 09                	jle    800ff6 <argstart+0x1f>
  800fed:	ba 48 22 80 00       	mov    $0x802248,%edx
  800ff2:	85 c9                	test   %ecx,%ecx
  800ff4:	75 05                	jne    800ffb <argstart+0x24>
  800ff6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ffb:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800ffe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <argnext>:

int
argnext(struct Argstate *args)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	53                   	push   %ebx
  80100b:	83 ec 04             	sub    $0x4,%esp
  80100e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801011:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801018:	8b 43 08             	mov    0x8(%ebx),%eax
  80101b:	85 c0                	test   %eax,%eax
  80101d:	74 72                	je     801091 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  80101f:	80 38 00             	cmpb   $0x0,(%eax)
  801022:	75 48                	jne    80106c <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801024:	8b 0b                	mov    (%ebx),%ecx
  801026:	83 39 01             	cmpl   $0x1,(%ecx)
  801029:	74 58                	je     801083 <argnext+0x7c>
		    || args->argv[1][0] != '-'
  80102b:	8b 53 04             	mov    0x4(%ebx),%edx
  80102e:	8b 42 04             	mov    0x4(%edx),%eax
  801031:	80 38 2d             	cmpb   $0x2d,(%eax)
  801034:	75 4d                	jne    801083 <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801036:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80103a:	74 47                	je     801083 <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80103c:	83 c0 01             	add    $0x1,%eax
  80103f:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801042:	83 ec 04             	sub    $0x4,%esp
  801045:	8b 01                	mov    (%ecx),%eax
  801047:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  80104e:	50                   	push   %eax
  80104f:	8d 42 08             	lea    0x8(%edx),%eax
  801052:	50                   	push   %eax
  801053:	83 c2 04             	add    $0x4,%edx
  801056:	52                   	push   %edx
  801057:	e8 1f fb ff ff       	call   800b7b <memmove>
		(*args->argc)--;
  80105c:	8b 03                	mov    (%ebx),%eax
  80105e:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801061:	8b 43 08             	mov    0x8(%ebx),%eax
  801064:	83 c4 10             	add    $0x10,%esp
  801067:	80 38 2d             	cmpb   $0x2d,(%eax)
  80106a:	74 11                	je     80107d <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80106c:	8b 53 08             	mov    0x8(%ebx),%edx
  80106f:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801072:	83 c2 01             	add    $0x1,%edx
  801075:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801078:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80107d:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801081:	75 e9                	jne    80106c <argnext+0x65>
	args->curarg = 0;
  801083:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  80108a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80108f:	eb e7                	jmp    801078 <argnext+0x71>
		return -1;
  801091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801096:	eb e0                	jmp    801078 <argnext+0x71>

00801098 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	53                   	push   %ebx
  80109c:	83 ec 04             	sub    $0x4,%esp
  80109f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8010a2:	8b 43 08             	mov    0x8(%ebx),%eax
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	74 5b                	je     801104 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  8010a9:	80 38 00             	cmpb   $0x0,(%eax)
  8010ac:	74 12                	je     8010c0 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  8010ae:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8010b1:	c7 43 08 48 22 80 00 	movl   $0x802248,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  8010b8:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  8010bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010be:	c9                   	leave  
  8010bf:	c3                   	ret    
	} else if (*args->argc > 1) {
  8010c0:	8b 13                	mov    (%ebx),%edx
  8010c2:	83 3a 01             	cmpl   $0x1,(%edx)
  8010c5:	7f 10                	jg     8010d7 <argnextvalue+0x3f>
		args->argvalue = 0;
  8010c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8010ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8010d5:	eb e1                	jmp    8010b8 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  8010d7:	8b 43 04             	mov    0x4(%ebx),%eax
  8010da:	8b 48 04             	mov    0x4(%eax),%ecx
  8010dd:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8010e0:	83 ec 04             	sub    $0x4,%esp
  8010e3:	8b 12                	mov    (%edx),%edx
  8010e5:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8010ec:	52                   	push   %edx
  8010ed:	8d 50 08             	lea    0x8(%eax),%edx
  8010f0:	52                   	push   %edx
  8010f1:	83 c0 04             	add    $0x4,%eax
  8010f4:	50                   	push   %eax
  8010f5:	e8 81 fa ff ff       	call   800b7b <memmove>
		(*args->argc)--;
  8010fa:	8b 03                	mov    (%ebx),%eax
  8010fc:	83 28 01             	subl   $0x1,(%eax)
  8010ff:	83 c4 10             	add    $0x10,%esp
  801102:	eb b4                	jmp    8010b8 <argnextvalue+0x20>
		return 0;
  801104:	b8 00 00 00 00       	mov    $0x0,%eax
  801109:	eb b0                	jmp    8010bb <argnextvalue+0x23>

0080110b <argvalue>:
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801114:	8b 42 0c             	mov    0xc(%edx),%eax
  801117:	85 c0                	test   %eax,%eax
  801119:	74 02                	je     80111d <argvalue+0x12>
}
  80111b:	c9                   	leave  
  80111c:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80111d:	83 ec 0c             	sub    $0xc,%esp
  801120:	52                   	push   %edx
  801121:	e8 72 ff ff ff       	call   801098 <argnextvalue>
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	eb f0                	jmp    80111b <argvalue+0x10>

0080112b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	05 00 00 00 30       	add    $0x30000000,%eax
  801136:	c1 e8 0c             	shr    $0xc,%eax
}
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    

0080113b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801146:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80114b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801150:	5d                   	pop    %ebp
  801151:	c3                   	ret    

00801152 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801158:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80115d:	89 c2                	mov    %eax,%edx
  80115f:	c1 ea 16             	shr    $0x16,%edx
  801162:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801169:	f6 c2 01             	test   $0x1,%dl
  80116c:	74 2a                	je     801198 <fd_alloc+0x46>
  80116e:	89 c2                	mov    %eax,%edx
  801170:	c1 ea 0c             	shr    $0xc,%edx
  801173:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80117a:	f6 c2 01             	test   $0x1,%dl
  80117d:	74 19                	je     801198 <fd_alloc+0x46>
  80117f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801184:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801189:	75 d2                	jne    80115d <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80118b:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801191:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801196:	eb 07                	jmp    80119f <fd_alloc+0x4d>
			*fd_store = fd;
  801198:	89 01                	mov    %eax,(%ecx)
			return 0;
  80119a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119f:	5d                   	pop    %ebp
  8011a0:	c3                   	ret    

008011a1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011a7:	83 f8 1f             	cmp    $0x1f,%eax
  8011aa:	77 36                	ja     8011e2 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011ac:	c1 e0 0c             	shl    $0xc,%eax
  8011af:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011b4:	89 c2                	mov    %eax,%edx
  8011b6:	c1 ea 16             	shr    $0x16,%edx
  8011b9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c0:	f6 c2 01             	test   $0x1,%dl
  8011c3:	74 24                	je     8011e9 <fd_lookup+0x48>
  8011c5:	89 c2                	mov    %eax,%edx
  8011c7:	c1 ea 0c             	shr    $0xc,%edx
  8011ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d1:	f6 c2 01             	test   $0x1,%dl
  8011d4:	74 1a                	je     8011f0 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d9:	89 02                	mov    %eax,(%edx)
	return 0;
  8011db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e0:	5d                   	pop    %ebp
  8011e1:	c3                   	ret    
		return -E_INVAL;
  8011e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e7:	eb f7                	jmp    8011e0 <fd_lookup+0x3f>
		return -E_INVAL;
  8011e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ee:	eb f0                	jmp    8011e0 <fd_lookup+0x3f>
  8011f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f5:	eb e9                	jmp    8011e0 <fd_lookup+0x3f>

008011f7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801200:	ba 4c 26 80 00       	mov    $0x80264c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801205:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80120a:	39 08                	cmp    %ecx,(%eax)
  80120c:	74 33                	je     801241 <dev_lookup+0x4a>
  80120e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801211:	8b 02                	mov    (%edx),%eax
  801213:	85 c0                	test   %eax,%eax
  801215:	75 f3                	jne    80120a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801217:	a1 20 44 80 00       	mov    0x804420,%eax
  80121c:	8b 40 48             	mov    0x48(%eax),%eax
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	51                   	push   %ecx
  801223:	50                   	push   %eax
  801224:	68 cc 25 80 00       	push   $0x8025cc
  801229:	e8 d5 f1 ff ff       	call   800403 <cprintf>
	*dev = 0;
  80122e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80123f:	c9                   	leave  
  801240:	c3                   	ret    
			*dev = devtab[i];
  801241:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801244:	89 01                	mov    %eax,(%ecx)
			return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb f2                	jmp    80123f <dev_lookup+0x48>

0080124d <fd_close>:
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	57                   	push   %edi
  801251:	56                   	push   %esi
  801252:	53                   	push   %ebx
  801253:	83 ec 1c             	sub    $0x1c,%esp
  801256:	8b 75 08             	mov    0x8(%ebp),%esi
  801259:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80125c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80125f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801260:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801266:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801269:	50                   	push   %eax
  80126a:	e8 32 ff ff ff       	call   8011a1 <fd_lookup>
  80126f:	89 c3                	mov    %eax,%ebx
  801271:	83 c4 08             	add    $0x8,%esp
  801274:	85 c0                	test   %eax,%eax
  801276:	78 05                	js     80127d <fd_close+0x30>
	    || fd != fd2)
  801278:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80127b:	74 16                	je     801293 <fd_close+0x46>
		return (must_exist ? r : 0);
  80127d:	89 f8                	mov    %edi,%eax
  80127f:	84 c0                	test   %al,%al
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
  801286:	0f 44 d8             	cmove  %eax,%ebx
}
  801289:	89 d8                	mov    %ebx,%eax
  80128b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5f                   	pop    %edi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801299:	50                   	push   %eax
  80129a:	ff 36                	pushl  (%esi)
  80129c:	e8 56 ff ff ff       	call   8011f7 <dev_lookup>
  8012a1:	89 c3                	mov    %eax,%ebx
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	78 15                	js     8012bf <fd_close+0x72>
		if (dev->dev_close)
  8012aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ad:	8b 40 10             	mov    0x10(%eax),%eax
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	74 1b                	je     8012cf <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8012b4:	83 ec 0c             	sub    $0xc,%esp
  8012b7:	56                   	push   %esi
  8012b8:	ff d0                	call   *%eax
  8012ba:	89 c3                	mov    %eax,%ebx
  8012bc:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012bf:	83 ec 08             	sub    $0x8,%esp
  8012c2:	56                   	push   %esi
  8012c3:	6a 00                	push   $0x0
  8012c5:	e8 a1 fb ff ff       	call   800e6b <sys_page_unmap>
	return r;
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	eb ba                	jmp    801289 <fd_close+0x3c>
			r = 0;
  8012cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d4:	eb e9                	jmp    8012bf <fd_close+0x72>

008012d6 <close>:

int
close(int fdnum)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012df:	50                   	push   %eax
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	e8 b9 fe ff ff       	call   8011a1 <fd_lookup>
  8012e8:	83 c4 08             	add    $0x8,%esp
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	78 10                	js     8012ff <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8012ef:	83 ec 08             	sub    $0x8,%esp
  8012f2:	6a 01                	push   $0x1
  8012f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8012f7:	e8 51 ff ff ff       	call   80124d <fd_close>
  8012fc:	83 c4 10             	add    $0x10,%esp
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <close_all>:

void
close_all(void)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	53                   	push   %ebx
  801305:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801308:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80130d:	83 ec 0c             	sub    $0xc,%esp
  801310:	53                   	push   %ebx
  801311:	e8 c0 ff ff ff       	call   8012d6 <close>
	for (i = 0; i < MAXFD; i++)
  801316:	83 c3 01             	add    $0x1,%ebx
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	83 fb 20             	cmp    $0x20,%ebx
  80131f:	75 ec                	jne    80130d <close_all+0xc>
}
  801321:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	57                   	push   %edi
  80132a:	56                   	push   %esi
  80132b:	53                   	push   %ebx
  80132c:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80132f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801332:	50                   	push   %eax
  801333:	ff 75 08             	pushl  0x8(%ebp)
  801336:	e8 66 fe ff ff       	call   8011a1 <fd_lookup>
  80133b:	89 c3                	mov    %eax,%ebx
  80133d:	83 c4 08             	add    $0x8,%esp
  801340:	85 c0                	test   %eax,%eax
  801342:	0f 88 81 00 00 00    	js     8013c9 <dup+0xa3>
		return r;
	close(newfdnum);
  801348:	83 ec 0c             	sub    $0xc,%esp
  80134b:	ff 75 0c             	pushl  0xc(%ebp)
  80134e:	e8 83 ff ff ff       	call   8012d6 <close>

	newfd = INDEX2FD(newfdnum);
  801353:	8b 75 0c             	mov    0xc(%ebp),%esi
  801356:	c1 e6 0c             	shl    $0xc,%esi
  801359:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80135f:	83 c4 04             	add    $0x4,%esp
  801362:	ff 75 e4             	pushl  -0x1c(%ebp)
  801365:	e8 d1 fd ff ff       	call   80113b <fd2data>
  80136a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80136c:	89 34 24             	mov    %esi,(%esp)
  80136f:	e8 c7 fd ff ff       	call   80113b <fd2data>
  801374:	83 c4 10             	add    $0x10,%esp
  801377:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801379:	89 d8                	mov    %ebx,%eax
  80137b:	c1 e8 16             	shr    $0x16,%eax
  80137e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801385:	a8 01                	test   $0x1,%al
  801387:	74 11                	je     80139a <dup+0x74>
  801389:	89 d8                	mov    %ebx,%eax
  80138b:	c1 e8 0c             	shr    $0xc,%eax
  80138e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801395:	f6 c2 01             	test   $0x1,%dl
  801398:	75 39                	jne    8013d3 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80139a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80139d:	89 d0                	mov    %edx,%eax
  80139f:	c1 e8 0c             	shr    $0xc,%eax
  8013a2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	25 07 0e 00 00       	and    $0xe07,%eax
  8013b1:	50                   	push   %eax
  8013b2:	56                   	push   %esi
  8013b3:	6a 00                	push   $0x0
  8013b5:	52                   	push   %edx
  8013b6:	6a 00                	push   $0x0
  8013b8:	e8 6c fa ff ff       	call   800e29 <sys_page_map>
  8013bd:	89 c3                	mov    %eax,%ebx
  8013bf:	83 c4 20             	add    $0x20,%esp
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	78 31                	js     8013f7 <dup+0xd1>
		goto err;

	return newfdnum;
  8013c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013c9:	89 d8                	mov    %ebx,%eax
  8013cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ce:	5b                   	pop    %ebx
  8013cf:	5e                   	pop    %esi
  8013d0:	5f                   	pop    %edi
  8013d1:	5d                   	pop    %ebp
  8013d2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013d3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013da:	83 ec 0c             	sub    $0xc,%esp
  8013dd:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e2:	50                   	push   %eax
  8013e3:	57                   	push   %edi
  8013e4:	6a 00                	push   $0x0
  8013e6:	53                   	push   %ebx
  8013e7:	6a 00                	push   $0x0
  8013e9:	e8 3b fa ff ff       	call   800e29 <sys_page_map>
  8013ee:	89 c3                	mov    %eax,%ebx
  8013f0:	83 c4 20             	add    $0x20,%esp
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	79 a3                	jns    80139a <dup+0x74>
	sys_page_unmap(0, newfd);
  8013f7:	83 ec 08             	sub    $0x8,%esp
  8013fa:	56                   	push   %esi
  8013fb:	6a 00                	push   $0x0
  8013fd:	e8 69 fa ff ff       	call   800e6b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801402:	83 c4 08             	add    $0x8,%esp
  801405:	57                   	push   %edi
  801406:	6a 00                	push   $0x0
  801408:	e8 5e fa ff ff       	call   800e6b <sys_page_unmap>
	return r;
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	eb b7                	jmp    8013c9 <dup+0xa3>

00801412 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	53                   	push   %ebx
  801416:	83 ec 14             	sub    $0x14,%esp
  801419:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80141c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	53                   	push   %ebx
  801421:	e8 7b fd ff ff       	call   8011a1 <fd_lookup>
  801426:	83 c4 08             	add    $0x8,%esp
  801429:	85 c0                	test   %eax,%eax
  80142b:	78 3f                	js     80146c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80142d:	83 ec 08             	sub    $0x8,%esp
  801430:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801433:	50                   	push   %eax
  801434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801437:	ff 30                	pushl  (%eax)
  801439:	e8 b9 fd ff ff       	call   8011f7 <dev_lookup>
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	78 27                	js     80146c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801445:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801448:	8b 42 08             	mov    0x8(%edx),%eax
  80144b:	83 e0 03             	and    $0x3,%eax
  80144e:	83 f8 01             	cmp    $0x1,%eax
  801451:	74 1e                	je     801471 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801456:	8b 40 08             	mov    0x8(%eax),%eax
  801459:	85 c0                	test   %eax,%eax
  80145b:	74 35                	je     801492 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	ff 75 10             	pushl  0x10(%ebp)
  801463:	ff 75 0c             	pushl  0xc(%ebp)
  801466:	52                   	push   %edx
  801467:	ff d0                	call   *%eax
  801469:	83 c4 10             	add    $0x10,%esp
}
  80146c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146f:	c9                   	leave  
  801470:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801471:	a1 20 44 80 00       	mov    0x804420,%eax
  801476:	8b 40 48             	mov    0x48(%eax),%eax
  801479:	83 ec 04             	sub    $0x4,%esp
  80147c:	53                   	push   %ebx
  80147d:	50                   	push   %eax
  80147e:	68 10 26 80 00       	push   $0x802610
  801483:	e8 7b ef ff ff       	call   800403 <cprintf>
		return -E_INVAL;
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801490:	eb da                	jmp    80146c <read+0x5a>
		return -E_NOT_SUPP;
  801492:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801497:	eb d3                	jmp    80146c <read+0x5a>

00801499 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	57                   	push   %edi
  80149d:	56                   	push   %esi
  80149e:	53                   	push   %ebx
  80149f:	83 ec 0c             	sub    $0xc,%esp
  8014a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014a5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ad:	39 f3                	cmp    %esi,%ebx
  8014af:	73 25                	jae    8014d6 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	89 f0                	mov    %esi,%eax
  8014b6:	29 d8                	sub    %ebx,%eax
  8014b8:	50                   	push   %eax
  8014b9:	89 d8                	mov    %ebx,%eax
  8014bb:	03 45 0c             	add    0xc(%ebp),%eax
  8014be:	50                   	push   %eax
  8014bf:	57                   	push   %edi
  8014c0:	e8 4d ff ff ff       	call   801412 <read>
		if (m < 0)
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	78 08                	js     8014d4 <readn+0x3b>
			return m;
		if (m == 0)
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	74 06                	je     8014d6 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8014d0:	01 c3                	add    %eax,%ebx
  8014d2:	eb d9                	jmp    8014ad <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014d4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014d6:	89 d8                	mov    %ebx,%eax
  8014d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014db:	5b                   	pop    %ebx
  8014dc:	5e                   	pop    %esi
  8014dd:	5f                   	pop    %edi
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    

008014e0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	53                   	push   %ebx
  8014e4:	83 ec 14             	sub    $0x14,%esp
  8014e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ed:	50                   	push   %eax
  8014ee:	53                   	push   %ebx
  8014ef:	e8 ad fc ff ff       	call   8011a1 <fd_lookup>
  8014f4:	83 c4 08             	add    $0x8,%esp
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	78 3a                	js     801535 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014fb:	83 ec 08             	sub    $0x8,%esp
  8014fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801501:	50                   	push   %eax
  801502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801505:	ff 30                	pushl  (%eax)
  801507:	e8 eb fc ff ff       	call   8011f7 <dev_lookup>
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	78 22                	js     801535 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801516:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80151a:	74 1e                	je     80153a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80151c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151f:	8b 52 0c             	mov    0xc(%edx),%edx
  801522:	85 d2                	test   %edx,%edx
  801524:	74 35                	je     80155b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801526:	83 ec 04             	sub    $0x4,%esp
  801529:	ff 75 10             	pushl  0x10(%ebp)
  80152c:	ff 75 0c             	pushl  0xc(%ebp)
  80152f:	50                   	push   %eax
  801530:	ff d2                	call   *%edx
  801532:	83 c4 10             	add    $0x10,%esp
}
  801535:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801538:	c9                   	leave  
  801539:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80153a:	a1 20 44 80 00       	mov    0x804420,%eax
  80153f:	8b 40 48             	mov    0x48(%eax),%eax
  801542:	83 ec 04             	sub    $0x4,%esp
  801545:	53                   	push   %ebx
  801546:	50                   	push   %eax
  801547:	68 2c 26 80 00       	push   $0x80262c
  80154c:	e8 b2 ee ff ff       	call   800403 <cprintf>
		return -E_INVAL;
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801559:	eb da                	jmp    801535 <write+0x55>
		return -E_NOT_SUPP;
  80155b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801560:	eb d3                	jmp    801535 <write+0x55>

00801562 <seek>:

int
seek(int fdnum, off_t offset)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801568:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80156b:	50                   	push   %eax
  80156c:	ff 75 08             	pushl  0x8(%ebp)
  80156f:	e8 2d fc ff ff       	call   8011a1 <fd_lookup>
  801574:	83 c4 08             	add    $0x8,%esp
  801577:	85 c0                	test   %eax,%eax
  801579:	78 0e                	js     801589 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801581:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801584:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	53                   	push   %ebx
  80158f:	83 ec 14             	sub    $0x14,%esp
  801592:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801595:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801598:	50                   	push   %eax
  801599:	53                   	push   %ebx
  80159a:	e8 02 fc ff ff       	call   8011a1 <fd_lookup>
  80159f:	83 c4 08             	add    $0x8,%esp
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	78 37                	js     8015dd <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ac:	50                   	push   %eax
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b0:	ff 30                	pushl  (%eax)
  8015b2:	e8 40 fc ff ff       	call   8011f7 <dev_lookup>
  8015b7:	83 c4 10             	add    $0x10,%esp
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	78 1f                	js     8015dd <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015c5:	74 1b                	je     8015e2 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ca:	8b 52 18             	mov    0x18(%edx),%edx
  8015cd:	85 d2                	test   %edx,%edx
  8015cf:	74 32                	je     801603 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015d1:	83 ec 08             	sub    $0x8,%esp
  8015d4:	ff 75 0c             	pushl  0xc(%ebp)
  8015d7:	50                   	push   %eax
  8015d8:	ff d2                	call   *%edx
  8015da:	83 c4 10             	add    $0x10,%esp
}
  8015dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015e2:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015e7:	8b 40 48             	mov    0x48(%eax),%eax
  8015ea:	83 ec 04             	sub    $0x4,%esp
  8015ed:	53                   	push   %ebx
  8015ee:	50                   	push   %eax
  8015ef:	68 ec 25 80 00       	push   $0x8025ec
  8015f4:	e8 0a ee ff ff       	call   800403 <cprintf>
		return -E_INVAL;
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801601:	eb da                	jmp    8015dd <ftruncate+0x52>
		return -E_NOT_SUPP;
  801603:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801608:	eb d3                	jmp    8015dd <ftruncate+0x52>

0080160a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	53                   	push   %ebx
  80160e:	83 ec 14             	sub    $0x14,%esp
  801611:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801614:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801617:	50                   	push   %eax
  801618:	ff 75 08             	pushl  0x8(%ebp)
  80161b:	e8 81 fb ff ff       	call   8011a1 <fd_lookup>
  801620:	83 c4 08             	add    $0x8,%esp
  801623:	85 c0                	test   %eax,%eax
  801625:	78 4b                	js     801672 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162d:	50                   	push   %eax
  80162e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801631:	ff 30                	pushl  (%eax)
  801633:	e8 bf fb ff ff       	call   8011f7 <dev_lookup>
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	85 c0                	test   %eax,%eax
  80163d:	78 33                	js     801672 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80163f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801642:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801646:	74 2f                	je     801677 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801648:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80164b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801652:	00 00 00 
	stat->st_isdir = 0;
  801655:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80165c:	00 00 00 
	stat->st_dev = dev;
  80165f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801665:	83 ec 08             	sub    $0x8,%esp
  801668:	53                   	push   %ebx
  801669:	ff 75 f0             	pushl  -0x10(%ebp)
  80166c:	ff 50 14             	call   *0x14(%eax)
  80166f:	83 c4 10             	add    $0x10,%esp
}
  801672:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801675:	c9                   	leave  
  801676:	c3                   	ret    
		return -E_NOT_SUPP;
  801677:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80167c:	eb f4                	jmp    801672 <fstat+0x68>

0080167e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	56                   	push   %esi
  801682:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801683:	83 ec 08             	sub    $0x8,%esp
  801686:	6a 00                	push   $0x0
  801688:	ff 75 08             	pushl  0x8(%ebp)
  80168b:	e8 e7 01 00 00       	call   801877 <open>
  801690:	89 c3                	mov    %eax,%ebx
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	85 c0                	test   %eax,%eax
  801697:	78 1b                	js     8016b4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	ff 75 0c             	pushl  0xc(%ebp)
  80169f:	50                   	push   %eax
  8016a0:	e8 65 ff ff ff       	call   80160a <fstat>
  8016a5:	89 c6                	mov    %eax,%esi
	close(fd);
  8016a7:	89 1c 24             	mov    %ebx,(%esp)
  8016aa:	e8 27 fc ff ff       	call   8012d6 <close>
	return r;
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	89 f3                	mov    %esi,%ebx
}
  8016b4:	89 d8                	mov    %ebx,%eax
  8016b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b9:	5b                   	pop    %ebx
  8016ba:	5e                   	pop    %esi
  8016bb:	5d                   	pop    %ebp
  8016bc:	c3                   	ret    

008016bd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	56                   	push   %esi
  8016c1:	53                   	push   %ebx
  8016c2:	89 c6                	mov    %eax,%esi
  8016c4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016c6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016cd:	74 27                	je     8016f6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016cf:	6a 07                	push   $0x7
  8016d1:	68 00 50 80 00       	push   $0x805000
  8016d6:	56                   	push   %esi
  8016d7:	ff 35 00 40 80 00    	pushl  0x804000
  8016dd:	e8 30 08 00 00       	call   801f12 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016e2:	83 c4 0c             	add    $0xc,%esp
  8016e5:	6a 00                	push   $0x0
  8016e7:	53                   	push   %ebx
  8016e8:	6a 00                	push   $0x0
  8016ea:	e8 0c 08 00 00       	call   801efb <ipc_recv>
}
  8016ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016f6:	83 ec 0c             	sub    $0xc,%esp
  8016f9:	6a 01                	push   $0x1
  8016fb:	e8 29 08 00 00       	call   801f29 <ipc_find_env>
  801700:	a3 00 40 80 00       	mov    %eax,0x804000
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	eb c5                	jmp    8016cf <fsipc+0x12>

0080170a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	8b 40 0c             	mov    0xc(%eax),%eax
  801716:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80171b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801723:	ba 00 00 00 00       	mov    $0x0,%edx
  801728:	b8 02 00 00 00       	mov    $0x2,%eax
  80172d:	e8 8b ff ff ff       	call   8016bd <fsipc>
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <devfile_flush>:
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8b 40 0c             	mov    0xc(%eax),%eax
  801740:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801745:	ba 00 00 00 00       	mov    $0x0,%edx
  80174a:	b8 06 00 00 00       	mov    $0x6,%eax
  80174f:	e8 69 ff ff ff       	call   8016bd <fsipc>
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <devfile_stat>:
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	53                   	push   %ebx
  80175a:	83 ec 04             	sub    $0x4,%esp
  80175d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8b 40 0c             	mov    0xc(%eax),%eax
  801766:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80176b:	ba 00 00 00 00       	mov    $0x0,%edx
  801770:	b8 05 00 00 00       	mov    $0x5,%eax
  801775:	e8 43 ff ff ff       	call   8016bd <fsipc>
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 2c                	js     8017aa <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	68 00 50 80 00       	push   $0x805000
  801786:	53                   	push   %ebx
  801787:	e8 61 f2 ff ff       	call   8009ed <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80178c:	a1 80 50 80 00       	mov    0x805080,%eax
  801791:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801797:	a1 84 50 80 00       	mov    0x805084,%eax
  80179c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <devfile_write>:
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b8:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8017bd:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8017c2:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c8:	8b 52 0c             	mov    0xc(%edx),%edx
  8017cb:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8017d1:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8017d6:	50                   	push   %eax
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	68 08 50 80 00       	push   $0x805008
  8017df:	e8 97 f3 ff ff       	call   800b7b <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e9:	b8 04 00 00 00       	mov    $0x4,%eax
  8017ee:	e8 ca fe ff ff       	call   8016bd <fsipc>
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <devfile_read>:
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	56                   	push   %esi
  8017f9:	53                   	push   %ebx
  8017fa:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8b 40 0c             	mov    0xc(%eax),%eax
  801803:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801808:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80180e:	ba 00 00 00 00       	mov    $0x0,%edx
  801813:	b8 03 00 00 00       	mov    $0x3,%eax
  801818:	e8 a0 fe ff ff       	call   8016bd <fsipc>
  80181d:	89 c3                	mov    %eax,%ebx
  80181f:	85 c0                	test   %eax,%eax
  801821:	78 1f                	js     801842 <devfile_read+0x4d>
	assert(r <= n);
  801823:	39 f0                	cmp    %esi,%eax
  801825:	77 24                	ja     80184b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801827:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80182c:	7f 33                	jg     801861 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80182e:	83 ec 04             	sub    $0x4,%esp
  801831:	50                   	push   %eax
  801832:	68 00 50 80 00       	push   $0x805000
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	e8 3c f3 ff ff       	call   800b7b <memmove>
	return r;
  80183f:	83 c4 10             	add    $0x10,%esp
}
  801842:	89 d8                	mov    %ebx,%eax
  801844:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801847:	5b                   	pop    %ebx
  801848:	5e                   	pop    %esi
  801849:	5d                   	pop    %ebp
  80184a:	c3                   	ret    
	assert(r <= n);
  80184b:	68 5c 26 80 00       	push   $0x80265c
  801850:	68 63 26 80 00       	push   $0x802663
  801855:	6a 7c                	push   $0x7c
  801857:	68 78 26 80 00       	push   $0x802678
  80185c:	e8 c7 ea ff ff       	call   800328 <_panic>
	assert(r <= PGSIZE);
  801861:	68 83 26 80 00       	push   $0x802683
  801866:	68 63 26 80 00       	push   $0x802663
  80186b:	6a 7d                	push   $0x7d
  80186d:	68 78 26 80 00       	push   $0x802678
  801872:	e8 b1 ea ff ff       	call   800328 <_panic>

00801877 <open>:
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	56                   	push   %esi
  80187b:	53                   	push   %ebx
  80187c:	83 ec 1c             	sub    $0x1c,%esp
  80187f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801882:	56                   	push   %esi
  801883:	e8 2e f1 ff ff       	call   8009b6 <strlen>
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801890:	7f 6c                	jg     8018fe <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801898:	50                   	push   %eax
  801899:	e8 b4 f8 ff ff       	call   801152 <fd_alloc>
  80189e:	89 c3                	mov    %eax,%ebx
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 3c                	js     8018e3 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018a7:	83 ec 08             	sub    $0x8,%esp
  8018aa:	56                   	push   %esi
  8018ab:	68 00 50 80 00       	push   $0x805000
  8018b0:	e8 38 f1 ff ff       	call   8009ed <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b8:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8018c5:	e8 f3 fd ff ff       	call   8016bd <fsipc>
  8018ca:	89 c3                	mov    %eax,%ebx
  8018cc:	83 c4 10             	add    $0x10,%esp
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	78 19                	js     8018ec <open+0x75>
	return fd2num(fd);
  8018d3:	83 ec 0c             	sub    $0xc,%esp
  8018d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d9:	e8 4d f8 ff ff       	call   80112b <fd2num>
  8018de:	89 c3                	mov    %eax,%ebx
  8018e0:	83 c4 10             	add    $0x10,%esp
}
  8018e3:	89 d8                	mov    %ebx,%eax
  8018e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e8:	5b                   	pop    %ebx
  8018e9:	5e                   	pop    %esi
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    
		fd_close(fd, 0);
  8018ec:	83 ec 08             	sub    $0x8,%esp
  8018ef:	6a 00                	push   $0x0
  8018f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f4:	e8 54 f9 ff ff       	call   80124d <fd_close>
		return r;
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	eb e5                	jmp    8018e3 <open+0x6c>
		return -E_BAD_PATH;
  8018fe:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801903:	eb de                	jmp    8018e3 <open+0x6c>

00801905 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80190b:	ba 00 00 00 00       	mov    $0x0,%edx
  801910:	b8 08 00 00 00       	mov    $0x8,%eax
  801915:	e8 a3 fd ff ff       	call   8016bd <fsipc>
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80191c:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801920:	7e 38                	jle    80195a <writebuf+0x3e>
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	53                   	push   %ebx
  801926:	83 ec 08             	sub    $0x8,%esp
  801929:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80192b:	ff 70 04             	pushl  0x4(%eax)
  80192e:	8d 40 10             	lea    0x10(%eax),%eax
  801931:	50                   	push   %eax
  801932:	ff 33                	pushl  (%ebx)
  801934:	e8 a7 fb ff ff       	call   8014e0 <write>
		if (result > 0)
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	85 c0                	test   %eax,%eax
  80193e:	7e 03                	jle    801943 <writebuf+0x27>
			b->result += result;
  801940:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801943:	39 43 04             	cmp    %eax,0x4(%ebx)
  801946:	74 0d                	je     801955 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  801948:	85 c0                	test   %eax,%eax
  80194a:	ba 00 00 00 00       	mov    $0x0,%edx
  80194f:	0f 4f c2             	cmovg  %edx,%eax
  801952:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801958:	c9                   	leave  
  801959:	c3                   	ret    
  80195a:	f3 c3                	repz ret 

0080195c <putch>:

static void
putch(int ch, void *thunk)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	53                   	push   %ebx
  801960:	83 ec 04             	sub    $0x4,%esp
  801963:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801966:	8b 53 04             	mov    0x4(%ebx),%edx
  801969:	8d 42 01             	lea    0x1(%edx),%eax
  80196c:	89 43 04             	mov    %eax,0x4(%ebx)
  80196f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801972:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801976:	3d 00 01 00 00       	cmp    $0x100,%eax
  80197b:	74 06                	je     801983 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  80197d:	83 c4 04             	add    $0x4,%esp
  801980:	5b                   	pop    %ebx
  801981:	5d                   	pop    %ebp
  801982:	c3                   	ret    
		writebuf(b);
  801983:	89 d8                	mov    %ebx,%eax
  801985:	e8 92 ff ff ff       	call   80191c <writebuf>
		b->idx = 0;
  80198a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801991:	eb ea                	jmp    80197d <putch+0x21>

00801993 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019a5:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019ac:	00 00 00 
	b.result = 0;
  8019af:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019b6:	00 00 00 
	b.error = 1;
  8019b9:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8019c0:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8019c3:	ff 75 10             	pushl  0x10(%ebp)
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019cf:	50                   	push   %eax
  8019d0:	68 5c 19 80 00       	push   $0x80195c
  8019d5:	e8 26 eb ff ff       	call   800500 <vprintfmt>
	if (b.idx > 0)
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8019e4:	7f 11                	jg     8019f7 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8019e6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    
		writebuf(&b);
  8019f7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019fd:	e8 1a ff ff ff       	call   80191c <writebuf>
  801a02:	eb e2                	jmp    8019e6 <vfprintf+0x53>

00801a04 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a0a:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a0d:	50                   	push   %eax
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	e8 7a ff ff ff       	call   801993 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <printf>:

int
printf(const char *fmt, ...)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a21:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a24:	50                   	push   %eax
  801a25:	ff 75 08             	pushl  0x8(%ebp)
  801a28:	6a 01                	push   $0x1
  801a2a:	e8 64 ff ff ff       	call   801993 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	56                   	push   %esi
  801a35:	53                   	push   %ebx
  801a36:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a39:	83 ec 0c             	sub    $0xc,%esp
  801a3c:	ff 75 08             	pushl  0x8(%ebp)
  801a3f:	e8 f7 f6 ff ff       	call   80113b <fd2data>
  801a44:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a46:	83 c4 08             	add    $0x8,%esp
  801a49:	68 8f 26 80 00       	push   $0x80268f
  801a4e:	53                   	push   %ebx
  801a4f:	e8 99 ef ff ff       	call   8009ed <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a54:	8b 46 04             	mov    0x4(%esi),%eax
  801a57:	2b 06                	sub    (%esi),%eax
  801a59:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a5f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a66:	00 00 00 
	stat->st_dev = &devpipe;
  801a69:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801a70:	30 80 00 
	return 0;
}
  801a73:	b8 00 00 00 00       	mov    $0x0,%eax
  801a78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7b:	5b                   	pop    %ebx
  801a7c:	5e                   	pop    %esi
  801a7d:	5d                   	pop    %ebp
  801a7e:	c3                   	ret    

00801a7f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	53                   	push   %ebx
  801a83:	83 ec 0c             	sub    $0xc,%esp
  801a86:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a89:	53                   	push   %ebx
  801a8a:	6a 00                	push   $0x0
  801a8c:	e8 da f3 ff ff       	call   800e6b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a91:	89 1c 24             	mov    %ebx,(%esp)
  801a94:	e8 a2 f6 ff ff       	call   80113b <fd2data>
  801a99:	83 c4 08             	add    $0x8,%esp
  801a9c:	50                   	push   %eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	e8 c7 f3 ff ff       	call   800e6b <sys_page_unmap>
}
  801aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <_pipeisclosed>:
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	57                   	push   %edi
  801aad:	56                   	push   %esi
  801aae:	53                   	push   %ebx
  801aaf:	83 ec 1c             	sub    $0x1c,%esp
  801ab2:	89 c7                	mov    %eax,%edi
  801ab4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ab6:	a1 20 44 80 00       	mov    0x804420,%eax
  801abb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801abe:	83 ec 0c             	sub    $0xc,%esp
  801ac1:	57                   	push   %edi
  801ac2:	e8 9b 04 00 00       	call   801f62 <pageref>
  801ac7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801aca:	89 34 24             	mov    %esi,(%esp)
  801acd:	e8 90 04 00 00       	call   801f62 <pageref>
		nn = thisenv->env_runs;
  801ad2:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801ad8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	39 cb                	cmp    %ecx,%ebx
  801ae0:	74 1b                	je     801afd <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ae2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ae5:	75 cf                	jne    801ab6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ae7:	8b 42 58             	mov    0x58(%edx),%eax
  801aea:	6a 01                	push   $0x1
  801aec:	50                   	push   %eax
  801aed:	53                   	push   %ebx
  801aee:	68 96 26 80 00       	push   $0x802696
  801af3:	e8 0b e9 ff ff       	call   800403 <cprintf>
  801af8:	83 c4 10             	add    $0x10,%esp
  801afb:	eb b9                	jmp    801ab6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801afd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b00:	0f 94 c0             	sete   %al
  801b03:	0f b6 c0             	movzbl %al,%eax
}
  801b06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b09:	5b                   	pop    %ebx
  801b0a:	5e                   	pop    %esi
  801b0b:	5f                   	pop    %edi
  801b0c:	5d                   	pop    %ebp
  801b0d:	c3                   	ret    

00801b0e <devpipe_write>:
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	57                   	push   %edi
  801b12:	56                   	push   %esi
  801b13:	53                   	push   %ebx
  801b14:	83 ec 28             	sub    $0x28,%esp
  801b17:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b1a:	56                   	push   %esi
  801b1b:	e8 1b f6 ff ff       	call   80113b <fd2data>
  801b20:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b22:	83 c4 10             	add    $0x10,%esp
  801b25:	bf 00 00 00 00       	mov    $0x0,%edi
  801b2a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b2d:	74 4f                	je     801b7e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b2f:	8b 43 04             	mov    0x4(%ebx),%eax
  801b32:	8b 0b                	mov    (%ebx),%ecx
  801b34:	8d 51 20             	lea    0x20(%ecx),%edx
  801b37:	39 d0                	cmp    %edx,%eax
  801b39:	72 14                	jb     801b4f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b3b:	89 da                	mov    %ebx,%edx
  801b3d:	89 f0                	mov    %esi,%eax
  801b3f:	e8 65 ff ff ff       	call   801aa9 <_pipeisclosed>
  801b44:	85 c0                	test   %eax,%eax
  801b46:	75 3a                	jne    801b82 <devpipe_write+0x74>
			sys_yield();
  801b48:	e8 7a f2 ff ff       	call   800dc7 <sys_yield>
  801b4d:	eb e0                	jmp    801b2f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b52:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b56:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b59:	89 c2                	mov    %eax,%edx
  801b5b:	c1 fa 1f             	sar    $0x1f,%edx
  801b5e:	89 d1                	mov    %edx,%ecx
  801b60:	c1 e9 1b             	shr    $0x1b,%ecx
  801b63:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b66:	83 e2 1f             	and    $0x1f,%edx
  801b69:	29 ca                	sub    %ecx,%edx
  801b6b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b6f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b73:	83 c0 01             	add    $0x1,%eax
  801b76:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b79:	83 c7 01             	add    $0x1,%edi
  801b7c:	eb ac                	jmp    801b2a <devpipe_write+0x1c>
	return i;
  801b7e:	89 f8                	mov    %edi,%eax
  801b80:	eb 05                	jmp    801b87 <devpipe_write+0x79>
				return 0;
  801b82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b8a:	5b                   	pop    %ebx
  801b8b:	5e                   	pop    %esi
  801b8c:	5f                   	pop    %edi
  801b8d:	5d                   	pop    %ebp
  801b8e:	c3                   	ret    

00801b8f <devpipe_read>:
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	57                   	push   %edi
  801b93:	56                   	push   %esi
  801b94:	53                   	push   %ebx
  801b95:	83 ec 18             	sub    $0x18,%esp
  801b98:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b9b:	57                   	push   %edi
  801b9c:	e8 9a f5 ff ff       	call   80113b <fd2data>
  801ba1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ba3:	83 c4 10             	add    $0x10,%esp
  801ba6:	be 00 00 00 00       	mov    $0x0,%esi
  801bab:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bae:	74 47                	je     801bf7 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801bb0:	8b 03                	mov    (%ebx),%eax
  801bb2:	3b 43 04             	cmp    0x4(%ebx),%eax
  801bb5:	75 22                	jne    801bd9 <devpipe_read+0x4a>
			if (i > 0)
  801bb7:	85 f6                	test   %esi,%esi
  801bb9:	75 14                	jne    801bcf <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801bbb:	89 da                	mov    %ebx,%edx
  801bbd:	89 f8                	mov    %edi,%eax
  801bbf:	e8 e5 fe ff ff       	call   801aa9 <_pipeisclosed>
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	75 33                	jne    801bfb <devpipe_read+0x6c>
			sys_yield();
  801bc8:	e8 fa f1 ff ff       	call   800dc7 <sys_yield>
  801bcd:	eb e1                	jmp    801bb0 <devpipe_read+0x21>
				return i;
  801bcf:	89 f0                	mov    %esi,%eax
}
  801bd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd4:	5b                   	pop    %ebx
  801bd5:	5e                   	pop    %esi
  801bd6:	5f                   	pop    %edi
  801bd7:	5d                   	pop    %ebp
  801bd8:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801bd9:	99                   	cltd   
  801bda:	c1 ea 1b             	shr    $0x1b,%edx
  801bdd:	01 d0                	add    %edx,%eax
  801bdf:	83 e0 1f             	and    $0x1f,%eax
  801be2:	29 d0                	sub    %edx,%eax
  801be4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801be9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bec:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801bef:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801bf2:	83 c6 01             	add    $0x1,%esi
  801bf5:	eb b4                	jmp    801bab <devpipe_read+0x1c>
	return i;
  801bf7:	89 f0                	mov    %esi,%eax
  801bf9:	eb d6                	jmp    801bd1 <devpipe_read+0x42>
				return 0;
  801bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801c00:	eb cf                	jmp    801bd1 <devpipe_read+0x42>

00801c02 <pipe>:
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	56                   	push   %esi
  801c06:	53                   	push   %ebx
  801c07:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c0d:	50                   	push   %eax
  801c0e:	e8 3f f5 ff ff       	call   801152 <fd_alloc>
  801c13:	89 c3                	mov    %eax,%ebx
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	78 5b                	js     801c77 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c1c:	83 ec 04             	sub    $0x4,%esp
  801c1f:	68 07 04 00 00       	push   $0x407
  801c24:	ff 75 f4             	pushl  -0xc(%ebp)
  801c27:	6a 00                	push   $0x0
  801c29:	e8 b8 f1 ff ff       	call   800de6 <sys_page_alloc>
  801c2e:	89 c3                	mov    %eax,%ebx
  801c30:	83 c4 10             	add    $0x10,%esp
  801c33:	85 c0                	test   %eax,%eax
  801c35:	78 40                	js     801c77 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801c37:	83 ec 0c             	sub    $0xc,%esp
  801c3a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c3d:	50                   	push   %eax
  801c3e:	e8 0f f5 ff ff       	call   801152 <fd_alloc>
  801c43:	89 c3                	mov    %eax,%ebx
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	78 1b                	js     801c67 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	68 07 04 00 00       	push   $0x407
  801c54:	ff 75 f0             	pushl  -0x10(%ebp)
  801c57:	6a 00                	push   $0x0
  801c59:	e8 88 f1 ff ff       	call   800de6 <sys_page_alloc>
  801c5e:	89 c3                	mov    %eax,%ebx
  801c60:	83 c4 10             	add    $0x10,%esp
  801c63:	85 c0                	test   %eax,%eax
  801c65:	79 19                	jns    801c80 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c67:	83 ec 08             	sub    $0x8,%esp
  801c6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c6d:	6a 00                	push   $0x0
  801c6f:	e8 f7 f1 ff ff       	call   800e6b <sys_page_unmap>
  801c74:	83 c4 10             	add    $0x10,%esp
}
  801c77:	89 d8                	mov    %ebx,%eax
  801c79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    
	va = fd2data(fd0);
  801c80:	83 ec 0c             	sub    $0xc,%esp
  801c83:	ff 75 f4             	pushl  -0xc(%ebp)
  801c86:	e8 b0 f4 ff ff       	call   80113b <fd2data>
  801c8b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c8d:	83 c4 0c             	add    $0xc,%esp
  801c90:	68 07 04 00 00       	push   $0x407
  801c95:	50                   	push   %eax
  801c96:	6a 00                	push   $0x0
  801c98:	e8 49 f1 ff ff       	call   800de6 <sys_page_alloc>
  801c9d:	89 c3                	mov    %eax,%ebx
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	85 c0                	test   %eax,%eax
  801ca4:	0f 88 8c 00 00 00    	js     801d36 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801caa:	83 ec 0c             	sub    $0xc,%esp
  801cad:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb0:	e8 86 f4 ff ff       	call   80113b <fd2data>
  801cb5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801cbc:	50                   	push   %eax
  801cbd:	6a 00                	push   $0x0
  801cbf:	56                   	push   %esi
  801cc0:	6a 00                	push   $0x0
  801cc2:	e8 62 f1 ff ff       	call   800e29 <sys_page_map>
  801cc7:	89 c3                	mov    %eax,%ebx
  801cc9:	83 c4 20             	add    $0x20,%esp
  801ccc:	85 c0                	test   %eax,%eax
  801cce:	78 58                	js     801d28 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cd9:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cde:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cee:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801cfa:	83 ec 0c             	sub    $0xc,%esp
  801cfd:	ff 75 f4             	pushl  -0xc(%ebp)
  801d00:	e8 26 f4 ff ff       	call   80112b <fd2num>
  801d05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d08:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d0a:	83 c4 04             	add    $0x4,%esp
  801d0d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d10:	e8 16 f4 ff ff       	call   80112b <fd2num>
  801d15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d18:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d23:	e9 4f ff ff ff       	jmp    801c77 <pipe+0x75>
	sys_page_unmap(0, va);
  801d28:	83 ec 08             	sub    $0x8,%esp
  801d2b:	56                   	push   %esi
  801d2c:	6a 00                	push   $0x0
  801d2e:	e8 38 f1 ff ff       	call   800e6b <sys_page_unmap>
  801d33:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d36:	83 ec 08             	sub    $0x8,%esp
  801d39:	ff 75 f0             	pushl  -0x10(%ebp)
  801d3c:	6a 00                	push   $0x0
  801d3e:	e8 28 f1 ff ff       	call   800e6b <sys_page_unmap>
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	e9 1c ff ff ff       	jmp    801c67 <pipe+0x65>

00801d4b <pipeisclosed>:
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d54:	50                   	push   %eax
  801d55:	ff 75 08             	pushl  0x8(%ebp)
  801d58:	e8 44 f4 ff ff       	call   8011a1 <fd_lookup>
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	85 c0                	test   %eax,%eax
  801d62:	78 18                	js     801d7c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d64:	83 ec 0c             	sub    $0xc,%esp
  801d67:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6a:	e8 cc f3 ff ff       	call   80113b <fd2data>
	return _pipeisclosed(fd, p);
  801d6f:	89 c2                	mov    %eax,%edx
  801d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d74:	e8 30 fd ff ff       	call   801aa9 <_pipeisclosed>
  801d79:	83 c4 10             	add    $0x10,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d81:	b8 00 00 00 00       	mov    $0x0,%eax
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    

00801d88 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d8e:	68 ae 26 80 00       	push   $0x8026ae
  801d93:	ff 75 0c             	pushl  0xc(%ebp)
  801d96:	e8 52 ec ff ff       	call   8009ed <strcpy>
	return 0;
}
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <devcons_write>:
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	57                   	push   %edi
  801da6:	56                   	push   %esi
  801da7:	53                   	push   %ebx
  801da8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801dae:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801db3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801db9:	eb 2f                	jmp    801dea <devcons_write+0x48>
		m = n - tot;
  801dbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801dbe:	29 f3                	sub    %esi,%ebx
  801dc0:	83 fb 7f             	cmp    $0x7f,%ebx
  801dc3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801dc8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801dcb:	83 ec 04             	sub    $0x4,%esp
  801dce:	53                   	push   %ebx
  801dcf:	89 f0                	mov    %esi,%eax
  801dd1:	03 45 0c             	add    0xc(%ebp),%eax
  801dd4:	50                   	push   %eax
  801dd5:	57                   	push   %edi
  801dd6:	e8 a0 ed ff ff       	call   800b7b <memmove>
		sys_cputs(buf, m);
  801ddb:	83 c4 08             	add    $0x8,%esp
  801dde:	53                   	push   %ebx
  801ddf:	57                   	push   %edi
  801de0:	e8 45 ef ff ff       	call   800d2a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801de5:	01 de                	add    %ebx,%esi
  801de7:	83 c4 10             	add    $0x10,%esp
  801dea:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ded:	72 cc                	jb     801dbb <devcons_write+0x19>
}
  801def:	89 f0                	mov    %esi,%eax
  801df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df4:	5b                   	pop    %ebx
  801df5:	5e                   	pop    %esi
  801df6:	5f                   	pop    %edi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    

00801df9 <devcons_read>:
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 08             	sub    $0x8,%esp
  801dff:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e08:	75 07                	jne    801e11 <devcons_read+0x18>
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    
		sys_yield();
  801e0c:	e8 b6 ef ff ff       	call   800dc7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e11:	e8 32 ef ff ff       	call   800d48 <sys_cgetc>
  801e16:	85 c0                	test   %eax,%eax
  801e18:	74 f2                	je     801e0c <devcons_read+0x13>
	if (c < 0)
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	78 ec                	js     801e0a <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e1e:	83 f8 04             	cmp    $0x4,%eax
  801e21:	74 0c                	je     801e2f <devcons_read+0x36>
	*(char*)vbuf = c;
  801e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e26:	88 02                	mov    %al,(%edx)
	return 1;
  801e28:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2d:	eb db                	jmp    801e0a <devcons_read+0x11>
		return 0;
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e34:	eb d4                	jmp    801e0a <devcons_read+0x11>

00801e36 <cputchar>:
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e42:	6a 01                	push   $0x1
  801e44:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e47:	50                   	push   %eax
  801e48:	e8 dd ee ff ff       	call   800d2a <sys_cputs>
}
  801e4d:	83 c4 10             	add    $0x10,%esp
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <getchar>:
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e58:	6a 01                	push   $0x1
  801e5a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e5d:	50                   	push   %eax
  801e5e:	6a 00                	push   $0x0
  801e60:	e8 ad f5 ff ff       	call   801412 <read>
	if (r < 0)
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	78 08                	js     801e74 <getchar+0x22>
	if (r < 1)
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	7e 06                	jle    801e76 <getchar+0x24>
	return c;
  801e70:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    
		return -E_EOF;
  801e76:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e7b:	eb f7                	jmp    801e74 <getchar+0x22>

00801e7d <iscons>:
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e83:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e86:	50                   	push   %eax
  801e87:	ff 75 08             	pushl  0x8(%ebp)
  801e8a:	e8 12 f3 ff ff       	call   8011a1 <fd_lookup>
  801e8f:	83 c4 10             	add    $0x10,%esp
  801e92:	85 c0                	test   %eax,%eax
  801e94:	78 11                	js     801ea7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e9f:	39 10                	cmp    %edx,(%eax)
  801ea1:	0f 94 c0             	sete   %al
  801ea4:	0f b6 c0             	movzbl %al,%eax
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <opencons>:
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801eaf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb2:	50                   	push   %eax
  801eb3:	e8 9a f2 ff ff       	call   801152 <fd_alloc>
  801eb8:	83 c4 10             	add    $0x10,%esp
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	78 3a                	js     801ef9 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ebf:	83 ec 04             	sub    $0x4,%esp
  801ec2:	68 07 04 00 00       	push   $0x407
  801ec7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eca:	6a 00                	push   $0x0
  801ecc:	e8 15 ef ff ff       	call   800de6 <sys_page_alloc>
  801ed1:	83 c4 10             	add    $0x10,%esp
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	78 21                	js     801ef9 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ee1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801eed:	83 ec 0c             	sub    $0xc,%esp
  801ef0:	50                   	push   %eax
  801ef1:	e8 35 f2 ff ff       	call   80112b <fd2num>
  801ef6:	83 c4 10             	add    $0x10,%esp
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801f01:	68 ba 26 80 00       	push   $0x8026ba
  801f06:	6a 1a                	push   $0x1a
  801f08:	68 d3 26 80 00       	push   $0x8026d3
  801f0d:	e8 16 e4 ff ff       	call   800328 <_panic>

00801f12 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801f18:	68 dd 26 80 00       	push   $0x8026dd
  801f1d:	6a 2a                	push   $0x2a
  801f1f:	68 d3 26 80 00       	push   $0x8026d3
  801f24:	e8 ff e3 ff ff       	call   800328 <_panic>

00801f29 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f2f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f34:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f37:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f3d:	8b 52 50             	mov    0x50(%edx),%edx
  801f40:	39 ca                	cmp    %ecx,%edx
  801f42:	74 11                	je     801f55 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801f44:	83 c0 01             	add    $0x1,%eax
  801f47:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f4c:	75 e6                	jne    801f34 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801f4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f53:	eb 0b                	jmp    801f60 <ipc_find_env+0x37>
			return envs[i].env_id;
  801f55:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801f58:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f5d:	8b 40 48             	mov    0x48(%eax),%eax
}
  801f60:	5d                   	pop    %ebp
  801f61:	c3                   	ret    

00801f62 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f68:	89 d0                	mov    %edx,%eax
  801f6a:	c1 e8 16             	shr    $0x16,%eax
  801f6d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801f79:	f6 c1 01             	test   $0x1,%cl
  801f7c:	74 1d                	je     801f9b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801f7e:	c1 ea 0c             	shr    $0xc,%edx
  801f81:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f88:	f6 c2 01             	test   $0x1,%dl
  801f8b:	74 0e                	je     801f9b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f8d:	c1 ea 0c             	shr    $0xc,%edx
  801f90:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f97:	ef 
  801f98:	0f b7 c0             	movzwl %ax,%eax
}
  801f9b:	5d                   	pop    %ebp
  801f9c:	c3                   	ret    
  801f9d:	66 90                	xchg   %ax,%ax
  801f9f:	90                   	nop

00801fa0 <__udivdi3>:
  801fa0:	55                   	push   %ebp
  801fa1:	57                   	push   %edi
  801fa2:	56                   	push   %esi
  801fa3:	53                   	push   %ebx
  801fa4:	83 ec 1c             	sub    $0x1c,%esp
  801fa7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801fab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801faf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fb3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801fb7:	85 d2                	test   %edx,%edx
  801fb9:	75 35                	jne    801ff0 <__udivdi3+0x50>
  801fbb:	39 f3                	cmp    %esi,%ebx
  801fbd:	0f 87 bd 00 00 00    	ja     802080 <__udivdi3+0xe0>
  801fc3:	85 db                	test   %ebx,%ebx
  801fc5:	89 d9                	mov    %ebx,%ecx
  801fc7:	75 0b                	jne    801fd4 <__udivdi3+0x34>
  801fc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fce:	31 d2                	xor    %edx,%edx
  801fd0:	f7 f3                	div    %ebx
  801fd2:	89 c1                	mov    %eax,%ecx
  801fd4:	31 d2                	xor    %edx,%edx
  801fd6:	89 f0                	mov    %esi,%eax
  801fd8:	f7 f1                	div    %ecx
  801fda:	89 c6                	mov    %eax,%esi
  801fdc:	89 e8                	mov    %ebp,%eax
  801fde:	89 f7                	mov    %esi,%edi
  801fe0:	f7 f1                	div    %ecx
  801fe2:	89 fa                	mov    %edi,%edx
  801fe4:	83 c4 1c             	add    $0x1c,%esp
  801fe7:	5b                   	pop    %ebx
  801fe8:	5e                   	pop    %esi
  801fe9:	5f                   	pop    %edi
  801fea:	5d                   	pop    %ebp
  801feb:	c3                   	ret    
  801fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ff0:	39 f2                	cmp    %esi,%edx
  801ff2:	77 7c                	ja     802070 <__udivdi3+0xd0>
  801ff4:	0f bd fa             	bsr    %edx,%edi
  801ff7:	83 f7 1f             	xor    $0x1f,%edi
  801ffa:	0f 84 98 00 00 00    	je     802098 <__udivdi3+0xf8>
  802000:	89 f9                	mov    %edi,%ecx
  802002:	b8 20 00 00 00       	mov    $0x20,%eax
  802007:	29 f8                	sub    %edi,%eax
  802009:	d3 e2                	shl    %cl,%edx
  80200b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80200f:	89 c1                	mov    %eax,%ecx
  802011:	89 da                	mov    %ebx,%edx
  802013:	d3 ea                	shr    %cl,%edx
  802015:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802019:	09 d1                	or     %edx,%ecx
  80201b:	89 f2                	mov    %esi,%edx
  80201d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802021:	89 f9                	mov    %edi,%ecx
  802023:	d3 e3                	shl    %cl,%ebx
  802025:	89 c1                	mov    %eax,%ecx
  802027:	d3 ea                	shr    %cl,%edx
  802029:	89 f9                	mov    %edi,%ecx
  80202b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80202f:	d3 e6                	shl    %cl,%esi
  802031:	89 eb                	mov    %ebp,%ebx
  802033:	89 c1                	mov    %eax,%ecx
  802035:	d3 eb                	shr    %cl,%ebx
  802037:	09 de                	or     %ebx,%esi
  802039:	89 f0                	mov    %esi,%eax
  80203b:	f7 74 24 08          	divl   0x8(%esp)
  80203f:	89 d6                	mov    %edx,%esi
  802041:	89 c3                	mov    %eax,%ebx
  802043:	f7 64 24 0c          	mull   0xc(%esp)
  802047:	39 d6                	cmp    %edx,%esi
  802049:	72 0c                	jb     802057 <__udivdi3+0xb7>
  80204b:	89 f9                	mov    %edi,%ecx
  80204d:	d3 e5                	shl    %cl,%ebp
  80204f:	39 c5                	cmp    %eax,%ebp
  802051:	73 5d                	jae    8020b0 <__udivdi3+0x110>
  802053:	39 d6                	cmp    %edx,%esi
  802055:	75 59                	jne    8020b0 <__udivdi3+0x110>
  802057:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80205a:	31 ff                	xor    %edi,%edi
  80205c:	89 fa                	mov    %edi,%edx
  80205e:	83 c4 1c             	add    $0x1c,%esp
  802061:	5b                   	pop    %ebx
  802062:	5e                   	pop    %esi
  802063:	5f                   	pop    %edi
  802064:	5d                   	pop    %ebp
  802065:	c3                   	ret    
  802066:	8d 76 00             	lea    0x0(%esi),%esi
  802069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802070:	31 ff                	xor    %edi,%edi
  802072:	31 c0                	xor    %eax,%eax
  802074:	89 fa                	mov    %edi,%edx
  802076:	83 c4 1c             	add    $0x1c,%esp
  802079:	5b                   	pop    %ebx
  80207a:	5e                   	pop    %esi
  80207b:	5f                   	pop    %edi
  80207c:	5d                   	pop    %ebp
  80207d:	c3                   	ret    
  80207e:	66 90                	xchg   %ax,%ax
  802080:	31 ff                	xor    %edi,%edi
  802082:	89 e8                	mov    %ebp,%eax
  802084:	89 f2                	mov    %esi,%edx
  802086:	f7 f3                	div    %ebx
  802088:	89 fa                	mov    %edi,%edx
  80208a:	83 c4 1c             	add    $0x1c,%esp
  80208d:	5b                   	pop    %ebx
  80208e:	5e                   	pop    %esi
  80208f:	5f                   	pop    %edi
  802090:	5d                   	pop    %ebp
  802091:	c3                   	ret    
  802092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802098:	39 f2                	cmp    %esi,%edx
  80209a:	72 06                	jb     8020a2 <__udivdi3+0x102>
  80209c:	31 c0                	xor    %eax,%eax
  80209e:	39 eb                	cmp    %ebp,%ebx
  8020a0:	77 d2                	ja     802074 <__udivdi3+0xd4>
  8020a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a7:	eb cb                	jmp    802074 <__udivdi3+0xd4>
  8020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020b0:	89 d8                	mov    %ebx,%eax
  8020b2:	31 ff                	xor    %edi,%edi
  8020b4:	eb be                	jmp    802074 <__udivdi3+0xd4>
  8020b6:	66 90                	xchg   %ax,%ax
  8020b8:	66 90                	xchg   %ax,%ax
  8020ba:	66 90                	xchg   %ax,%ax
  8020bc:	66 90                	xchg   %ax,%ax
  8020be:	66 90                	xchg   %ax,%ax

008020c0 <__umoddi3>:
  8020c0:	55                   	push   %ebp
  8020c1:	57                   	push   %edi
  8020c2:	56                   	push   %esi
  8020c3:	53                   	push   %ebx
  8020c4:	83 ec 1c             	sub    $0x1c,%esp
  8020c7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8020cb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8020cf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8020d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020d7:	85 ed                	test   %ebp,%ebp
  8020d9:	89 f0                	mov    %esi,%eax
  8020db:	89 da                	mov    %ebx,%edx
  8020dd:	75 19                	jne    8020f8 <__umoddi3+0x38>
  8020df:	39 df                	cmp    %ebx,%edi
  8020e1:	0f 86 b1 00 00 00    	jbe    802198 <__umoddi3+0xd8>
  8020e7:	f7 f7                	div    %edi
  8020e9:	89 d0                	mov    %edx,%eax
  8020eb:	31 d2                	xor    %edx,%edx
  8020ed:	83 c4 1c             	add    $0x1c,%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5e                   	pop    %esi
  8020f2:	5f                   	pop    %edi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    
  8020f5:	8d 76 00             	lea    0x0(%esi),%esi
  8020f8:	39 dd                	cmp    %ebx,%ebp
  8020fa:	77 f1                	ja     8020ed <__umoddi3+0x2d>
  8020fc:	0f bd cd             	bsr    %ebp,%ecx
  8020ff:	83 f1 1f             	xor    $0x1f,%ecx
  802102:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802106:	0f 84 b4 00 00 00    	je     8021c0 <__umoddi3+0x100>
  80210c:	b8 20 00 00 00       	mov    $0x20,%eax
  802111:	89 c2                	mov    %eax,%edx
  802113:	8b 44 24 04          	mov    0x4(%esp),%eax
  802117:	29 c2                	sub    %eax,%edx
  802119:	89 c1                	mov    %eax,%ecx
  80211b:	89 f8                	mov    %edi,%eax
  80211d:	d3 e5                	shl    %cl,%ebp
  80211f:	89 d1                	mov    %edx,%ecx
  802121:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802125:	d3 e8                	shr    %cl,%eax
  802127:	09 c5                	or     %eax,%ebp
  802129:	8b 44 24 04          	mov    0x4(%esp),%eax
  80212d:	89 c1                	mov    %eax,%ecx
  80212f:	d3 e7                	shl    %cl,%edi
  802131:	89 d1                	mov    %edx,%ecx
  802133:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802137:	89 df                	mov    %ebx,%edi
  802139:	d3 ef                	shr    %cl,%edi
  80213b:	89 c1                	mov    %eax,%ecx
  80213d:	89 f0                	mov    %esi,%eax
  80213f:	d3 e3                	shl    %cl,%ebx
  802141:	89 d1                	mov    %edx,%ecx
  802143:	89 fa                	mov    %edi,%edx
  802145:	d3 e8                	shr    %cl,%eax
  802147:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80214c:	09 d8                	or     %ebx,%eax
  80214e:	f7 f5                	div    %ebp
  802150:	d3 e6                	shl    %cl,%esi
  802152:	89 d1                	mov    %edx,%ecx
  802154:	f7 64 24 08          	mull   0x8(%esp)
  802158:	39 d1                	cmp    %edx,%ecx
  80215a:	89 c3                	mov    %eax,%ebx
  80215c:	89 d7                	mov    %edx,%edi
  80215e:	72 06                	jb     802166 <__umoddi3+0xa6>
  802160:	75 0e                	jne    802170 <__umoddi3+0xb0>
  802162:	39 c6                	cmp    %eax,%esi
  802164:	73 0a                	jae    802170 <__umoddi3+0xb0>
  802166:	2b 44 24 08          	sub    0x8(%esp),%eax
  80216a:	19 ea                	sbb    %ebp,%edx
  80216c:	89 d7                	mov    %edx,%edi
  80216e:	89 c3                	mov    %eax,%ebx
  802170:	89 ca                	mov    %ecx,%edx
  802172:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802177:	29 de                	sub    %ebx,%esi
  802179:	19 fa                	sbb    %edi,%edx
  80217b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80217f:	89 d0                	mov    %edx,%eax
  802181:	d3 e0                	shl    %cl,%eax
  802183:	89 d9                	mov    %ebx,%ecx
  802185:	d3 ee                	shr    %cl,%esi
  802187:	d3 ea                	shr    %cl,%edx
  802189:	09 f0                	or     %esi,%eax
  80218b:	83 c4 1c             	add    $0x1c,%esp
  80218e:	5b                   	pop    %ebx
  80218f:	5e                   	pop    %esi
  802190:	5f                   	pop    %edi
  802191:	5d                   	pop    %ebp
  802192:	c3                   	ret    
  802193:	90                   	nop
  802194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802198:	85 ff                	test   %edi,%edi
  80219a:	89 f9                	mov    %edi,%ecx
  80219c:	75 0b                	jne    8021a9 <__umoddi3+0xe9>
  80219e:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a3:	31 d2                	xor    %edx,%edx
  8021a5:	f7 f7                	div    %edi
  8021a7:	89 c1                	mov    %eax,%ecx
  8021a9:	89 d8                	mov    %ebx,%eax
  8021ab:	31 d2                	xor    %edx,%edx
  8021ad:	f7 f1                	div    %ecx
  8021af:	89 f0                	mov    %esi,%eax
  8021b1:	f7 f1                	div    %ecx
  8021b3:	e9 31 ff ff ff       	jmp    8020e9 <__umoddi3+0x29>
  8021b8:	90                   	nop
  8021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021c0:	39 dd                	cmp    %ebx,%ebp
  8021c2:	72 08                	jb     8021cc <__umoddi3+0x10c>
  8021c4:	39 f7                	cmp    %esi,%edi
  8021c6:	0f 87 21 ff ff ff    	ja     8020ed <__umoddi3+0x2d>
  8021cc:	89 da                	mov    %ebx,%edx
  8021ce:	89 f0                	mov    %esi,%eax
  8021d0:	29 f8                	sub    %edi,%eax
  8021d2:	19 ea                	sbb    %ebp,%edx
  8021d4:	e9 14 ff ff ff       	jmp    8020ed <__umoddi3+0x2d>
