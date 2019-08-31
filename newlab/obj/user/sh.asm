
obj/user/sh.debug：     文件格式 elf32-i386


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
  80002c:	e8 ea 09 00 00       	call   800a1b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int t;

	if (s == 0) {
  80003b:	85 db                	test   %ebx,%ebx
  80003d:	74 1d                	je     80005c <_gettoken+0x29>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  80003f:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800046:	7f 34                	jg     80007c <_gettoken+0x49>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  800048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80004b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*p2 = 0;
  800051:	8b 45 10             	mov    0x10(%ebp),%eax
  800054:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  80005a:	eb 3a                	jmp    800096 <_gettoken+0x63>
		return 0;
  80005c:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800061:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800068:	7e 59                	jle    8000c3 <_gettoken+0x90>
			cprintf("GETTOKEN NULL\n");
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	68 e0 31 80 00       	push   $0x8031e0
  800072:	e8 df 0a 00 00       	call   800b56 <cprintf>
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	eb 47                	jmp    8000c3 <_gettoken+0x90>
		cprintf("GETTOKEN: %s\n", s);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	53                   	push   %ebx
  800080:	68 ef 31 80 00       	push   $0x8031ef
  800085:	e8 cc 0a 00 00       	call   800b56 <cprintf>
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	eb b9                	jmp    800048 <_gettoken+0x15>
		*s++ = 0;
  80008f:	83 c3 01             	add    $0x1,%ebx
  800092:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
	while (strchr(WHITESPACE, *s))
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	0f be 03             	movsbl (%ebx),%eax
  80009c:	50                   	push   %eax
  80009d:	68 fd 31 80 00       	push   $0x8031fd
  8000a2:	e8 8d 12 00 00       	call   801334 <strchr>
  8000a7:	83 c4 10             	add    $0x10,%esp
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	75 e1                	jne    80008f <_gettoken+0x5c>
	if (*s == 0) {
  8000ae:	0f b6 03             	movzbl (%ebx),%eax
  8000b1:	84 c0                	test   %al,%al
  8000b3:	75 29                	jne    8000de <_gettoken+0xab>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000b5:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000ba:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  8000c1:	7f 09                	jg     8000cc <_gettoken+0x99>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000c3:	89 f0                	mov    %esi,%eax
  8000c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    
			cprintf("EOL\n");
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 02 32 80 00       	push   $0x803202
  8000d4:	e8 7d 0a 00 00       	call   800b56 <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	eb e5                	jmp    8000c3 <_gettoken+0x90>
	if (strchr(SYMBOLS, *s)) {
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	0f be c0             	movsbl %al,%eax
  8000e4:	50                   	push   %eax
  8000e5:	68 13 32 80 00       	push   $0x803213
  8000ea:	e8 45 12 00 00       	call   801334 <strchr>
  8000ef:	83 c4 10             	add    $0x10,%esp
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	74 2f                	je     800125 <_gettoken+0xf2>
		t = *s;
  8000f6:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  8000f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000fc:	89 18                	mov    %ebx,(%eax)
		*s++ = 0;
  8000fe:	c6 03 00             	movb   $0x0,(%ebx)
  800101:	83 c3 01             	add    $0x1,%ebx
  800104:	8b 45 10             	mov    0x10(%ebp),%eax
  800107:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  800109:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800110:	7e b1                	jle    8000c3 <_gettoken+0x90>
			cprintf("TOK %c\n", t);
  800112:	83 ec 08             	sub    $0x8,%esp
  800115:	56                   	push   %esi
  800116:	68 07 32 80 00       	push   $0x803207
  80011b:	e8 36 0a 00 00       	call   800b56 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	eb 9e                	jmp    8000c3 <_gettoken+0x90>
	*p1 = s;
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	89 18                	mov    %ebx,(%eax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012a:	eb 03                	jmp    80012f <_gettoken+0xfc>
		s++;
  80012c:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012f:	0f b6 03             	movzbl (%ebx),%eax
  800132:	84 c0                	test   %al,%al
  800134:	74 18                	je     80014e <_gettoken+0x11b>
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	0f be c0             	movsbl %al,%eax
  80013c:	50                   	push   %eax
  80013d:	68 0f 32 80 00       	push   $0x80320f
  800142:	e8 ed 11 00 00       	call   801334 <strchr>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	85 c0                	test   %eax,%eax
  80014c:	74 de                	je     80012c <_gettoken+0xf9>
	*p2 = s;
  80014e:	8b 45 10             	mov    0x10(%ebp),%eax
  800151:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800153:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  800158:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80015f:	0f 8e 5e ff ff ff    	jle    8000c3 <_gettoken+0x90>
		t = **p2;
  800165:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800168:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800171:	ff 30                	pushl  (%eax)
  800173:	68 1b 32 80 00       	push   $0x80321b
  800178:	e8 d9 09 00 00       	call   800b56 <cprintf>
		**p2 = t;
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	8b 00                	mov    (%eax),%eax
  800182:	89 f2                	mov    %esi,%edx
  800184:	88 10                	mov    %dl,(%eax)
  800186:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800189:	be 77 00 00 00       	mov    $0x77,%esi
  80018e:	e9 30 ff ff ff       	jmp    8000c3 <_gettoken+0x90>

00800193 <gettoken>:

int
gettoken(char *s, char **p1)
{
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  80019c:	85 c0                	test   %eax,%eax
  80019e:	74 22                	je     8001c2 <gettoken+0x2f>
		nc = _gettoken(s, &np1, &np2);
  8001a0:	83 ec 04             	sub    $0x4,%esp
  8001a3:	68 0c 50 80 00       	push   $0x80500c
  8001a8:	68 10 50 80 00       	push   $0x805010
  8001ad:	50                   	push   %eax
  8001ae:	e8 80 fe ff ff       	call   800033 <_gettoken>
  8001b3:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8001b8:	83 c4 10             	add    $0x10,%esp
  8001bb:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    
	c = nc;
  8001c2:	a1 08 50 80 00       	mov    0x805008,%eax
  8001c7:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001cc:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d5:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	68 0c 50 80 00       	push   $0x80500c
  8001df:	68 10 50 80 00       	push   $0x805010
  8001e4:	ff 35 0c 50 80 00    	pushl  0x80500c
  8001ea:	e8 44 fe ff ff       	call   800033 <_gettoken>
  8001ef:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  8001f4:	a1 04 50 80 00       	mov    0x805004,%eax
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	eb c2                	jmp    8001c0 <gettoken+0x2d>

008001fe <runcmd>:
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	57                   	push   %edi
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  80020a:	6a 00                	push   $0x0
  80020c:	ff 75 08             	pushl  0x8(%ebp)
  80020f:	e8 7f ff ff ff       	call   800193 <gettoken>
  800214:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  800217:	8d 75 a4             	lea    -0x5c(%ebp),%esi
	argc = 0;
  80021a:	bf 00 00 00 00       	mov    $0x0,%edi
		switch ((c = gettoken(0, &t))) {
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	56                   	push   %esi
  800223:	6a 00                	push   $0x0
  800225:	e8 69 ff ff ff       	call   800193 <gettoken>
  80022a:	89 c3                	mov    %eax,%ebx
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	83 f8 3e             	cmp    $0x3e,%eax
  800232:	0f 84 39 01 00 00    	je     800371 <runcmd+0x173>
  800238:	83 f8 3e             	cmp    $0x3e,%eax
  80023b:	7f 4b                	jg     800288 <runcmd+0x8a>
  80023d:	85 c0                	test   %eax,%eax
  80023f:	0f 84 1c 02 00 00    	je     800461 <runcmd+0x263>
  800245:	83 f8 3c             	cmp    $0x3c,%eax
  800248:	0f 85 78 02 00 00    	jne    8004c6 <runcmd+0x2c8>
			if (gettoken(0, &t) != 'w') {
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	56                   	push   %esi
  800252:	6a 00                	push   $0x0
  800254:	e8 3a ff ff ff       	call   800193 <gettoken>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	83 f8 77             	cmp    $0x77,%eax
  80025f:	0f 85 be 00 00 00    	jne    800323 <runcmd+0x125>
			if ((fd = open(t, O_RDONLY)) < 0) {
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	6a 00                	push   $0x0
  80026a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80026d:	e8 81 20 00 00       	call   8022f3 <open>
  800272:	89 c3                	mov    %eax,%ebx
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	85 c0                	test   %eax,%eax
  800279:	0f 88 be 00 00 00    	js     80033d <runcmd+0x13f>
                        if (fd != 0) {
  80027f:	85 c0                	test   %eax,%eax
  800281:	74 9c                	je     80021f <runcmd+0x21>
  800283:	e9 ce 00 00 00       	jmp    800356 <runcmd+0x158>
		switch ((c = gettoken(0, &t))) {
  800288:	83 f8 77             	cmp    $0x77,%eax
  80028b:	74 6b                	je     8002f8 <runcmd+0xfa>
  80028d:	83 f8 7c             	cmp    $0x7c,%eax
  800290:	0f 85 30 02 00 00    	jne    8004c6 <runcmd+0x2c8>
			if ((r = pipe(p)) < 0) {
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  80029f:	50                   	push   %eax
  8002a0:	e8 ef 29 00 00       	call   802c94 <pipe>
  8002a5:	83 c4 10             	add    $0x10,%esp
  8002a8:	85 c0                	test   %eax,%eax
  8002aa:	0f 88 43 01 00 00    	js     8003f3 <runcmd+0x1f5>
			if (debug)
  8002b0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8002b7:	0f 85 51 01 00 00    	jne    80040e <runcmd+0x210>
			if ((r = fork()) < 0) {
  8002bd:	e8 6f 15 00 00       	call   801831 <fork>
  8002c2:	89 c3                	mov    %eax,%ebx
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	0f 88 63 01 00 00    	js     80042f <runcmd+0x231>
			if (r == 0) {
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	0f 85 71 01 00 00    	jne    800445 <runcmd+0x247>
				if (p[0] != 0) {
  8002d4:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	0f 85 a5 01 00 00    	jne    800487 <runcmd+0x289>
				close(p[1]);
  8002e2:	83 ec 0c             	sub    $0xc,%esp
  8002e5:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8002eb:	e8 62 1a 00 00       	call   801d52 <close>
				goto again;
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	e9 22 ff ff ff       	jmp    80021a <runcmd+0x1c>
			if (argc == MAXARGS) {
  8002f8:	83 ff 10             	cmp    $0x10,%edi
  8002fb:	74 0f                	je     80030c <runcmd+0x10e>
			argv[argc++] = t;
  8002fd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800300:	89 44 bd a8          	mov    %eax,-0x58(%ebp,%edi,4)
  800304:	8d 7f 01             	lea    0x1(%edi),%edi
			break;
  800307:	e9 13 ff ff ff       	jmp    80021f <runcmd+0x21>
				cprintf("too many arguments\n");
  80030c:	83 ec 0c             	sub    $0xc,%esp
  80030f:	68 25 32 80 00       	push   $0x803225
  800314:	e8 3d 08 00 00       	call   800b56 <cprintf>
				exit();
  800319:	e8 43 07 00 00       	call   800a61 <exit>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	eb da                	jmp    8002fd <runcmd+0xff>
				cprintf("syntax error: < not followed by word\n");
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	68 64 33 80 00       	push   $0x803364
  80032b:	e8 26 08 00 00       	call   800b56 <cprintf>
				exit();
  800330:	e8 2c 07 00 00       	call   800a61 <exit>
  800335:	83 c4 10             	add    $0x10,%esp
  800338:	e9 28 ff ff ff       	jmp    800265 <runcmd+0x67>
                                cprintf("open %s for write: %e", t, fd);
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	50                   	push   %eax
  800341:	ff 75 a4             	pushl  -0x5c(%ebp)
  800344:	68 39 32 80 00       	push   $0x803239
  800349:	e8 08 08 00 00       	call   800b56 <cprintf>
                                exit();
  80034e:	e8 0e 07 00 00       	call   800a61 <exit>
  800353:	83 c4 10             	add    $0x10,%esp
                                dup(fd, 0);
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	6a 00                	push   $0x0
  80035b:	53                   	push   %ebx
  80035c:	e8 41 1a 00 00       	call   801da2 <dup>
                                close(fd);
  800361:	89 1c 24             	mov    %ebx,(%esp)
  800364:	e8 e9 19 00 00       	call   801d52 <close>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	e9 ae fe ff ff       	jmp    80021f <runcmd+0x21>
			if (gettoken(0, &t) != 'w') {
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	56                   	push   %esi
  800375:	6a 00                	push   $0x0
  800377:	e8 17 fe ff ff       	call   800193 <gettoken>
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	83 f8 77             	cmp    $0x77,%eax
  800382:	75 3d                	jne    8003c1 <runcmd+0x1c3>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	68 01 03 00 00       	push   $0x301
  80038c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80038f:	e8 5f 1f 00 00       	call   8022f3 <open>
  800394:	89 c3                	mov    %eax,%ebx
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	85 c0                	test   %eax,%eax
  80039b:	78 3b                	js     8003d8 <runcmd+0x1da>
			if (fd != 1) {
  80039d:	83 fb 01             	cmp    $0x1,%ebx
  8003a0:	0f 84 79 fe ff ff    	je     80021f <runcmd+0x21>
				dup(fd, 1);
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	6a 01                	push   $0x1
  8003ab:	53                   	push   %ebx
  8003ac:	e8 f1 19 00 00       	call   801da2 <dup>
				close(fd);
  8003b1:	89 1c 24             	mov    %ebx,(%esp)
  8003b4:	e8 99 19 00 00       	call   801d52 <close>
  8003b9:	83 c4 10             	add    $0x10,%esp
  8003bc:	e9 5e fe ff ff       	jmp    80021f <runcmd+0x21>
				cprintf("syntax error: > not followed by word\n");
  8003c1:	83 ec 0c             	sub    $0xc,%esp
  8003c4:	68 8c 33 80 00       	push   $0x80338c
  8003c9:	e8 88 07 00 00       	call   800b56 <cprintf>
				exit();
  8003ce:	e8 8e 06 00 00       	call   800a61 <exit>
  8003d3:	83 c4 10             	add    $0x10,%esp
  8003d6:	eb ac                	jmp    800384 <runcmd+0x186>
				cprintf("open %s for write: %e", t, fd);
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	50                   	push   %eax
  8003dc:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003df:	68 39 32 80 00       	push   $0x803239
  8003e4:	e8 6d 07 00 00       	call   800b56 <cprintf>
				exit();
  8003e9:	e8 73 06 00 00       	call   800a61 <exit>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	eb aa                	jmp    80039d <runcmd+0x19f>
				cprintf("pipe: %e", r);
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	50                   	push   %eax
  8003f7:	68 4f 32 80 00       	push   $0x80324f
  8003fc:	e8 55 07 00 00       	call   800b56 <cprintf>
				exit();
  800401:	e8 5b 06 00 00       	call   800a61 <exit>
  800406:	83 c4 10             	add    $0x10,%esp
  800409:	e9 a2 fe ff ff       	jmp    8002b0 <runcmd+0xb2>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  80040e:	83 ec 04             	sub    $0x4,%esp
  800411:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800417:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80041d:	68 58 32 80 00       	push   $0x803258
  800422:	e8 2f 07 00 00       	call   800b56 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
  80042a:	e9 8e fe ff ff       	jmp    8002bd <runcmd+0xbf>
				cprintf("fork: %e", r);
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	50                   	push   %eax
  800433:	68 65 32 80 00       	push   $0x803265
  800438:	e8 19 07 00 00       	call   800b56 <cprintf>
				exit();
  80043d:	e8 1f 06 00 00       	call   800a61 <exit>
  800442:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  800445:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80044b:	83 f8 01             	cmp    $0x1,%eax
  80044e:	75 58                	jne    8004a8 <runcmd+0x2aa>
				close(p[0]);
  800450:	83 ec 0c             	sub    $0xc,%esp
  800453:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800459:	e8 f4 18 00 00       	call   801d52 <close>
				goto runit;
  80045e:	83 c4 10             	add    $0x10,%esp
	if(argc == 0) {
  800461:	85 ff                	test   %edi,%edi
  800463:	75 73                	jne    8004d8 <runcmd+0x2da>
		if (debug)
  800465:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80046c:	0f 84 f0 00 00 00    	je     800562 <runcmd+0x364>
			cprintf("EMPTY COMMAND\n");
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	68 94 32 80 00       	push   $0x803294
  80047a:	e8 d7 06 00 00       	call   800b56 <cprintf>
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	e9 db 00 00 00       	jmp    800562 <runcmd+0x364>
					dup(p[0], 0);
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	6a 00                	push   $0x0
  80048c:	50                   	push   %eax
  80048d:	e8 10 19 00 00       	call   801da2 <dup>
					close(p[0]);
  800492:	83 c4 04             	add    $0x4,%esp
  800495:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80049b:	e8 b2 18 00 00       	call   801d52 <close>
  8004a0:	83 c4 10             	add    $0x10,%esp
  8004a3:	e9 3a fe ff ff       	jmp    8002e2 <runcmd+0xe4>
					dup(p[1], 1);
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	6a 01                	push   $0x1
  8004ad:	50                   	push   %eax
  8004ae:	e8 ef 18 00 00       	call   801da2 <dup>
					close(p[1]);
  8004b3:	83 c4 04             	add    $0x4,%esp
  8004b6:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8004bc:	e8 91 18 00 00       	call   801d52 <close>
  8004c1:	83 c4 10             	add    $0x10,%esp
  8004c4:	eb 8a                	jmp    800450 <runcmd+0x252>
			panic("bad return %d from gettoken", c);
  8004c6:	53                   	push   %ebx
  8004c7:	68 6e 32 80 00       	push   $0x80326e
  8004cc:	6a 78                	push   $0x78
  8004ce:	68 8a 32 80 00       	push   $0x80328a
  8004d3:	e8 a3 05 00 00       	call   800a7b <_panic>
	if (argv[0][0] != '/') {
  8004d8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004db:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004de:	0f 85 86 00 00 00    	jne    80056a <runcmd+0x36c>
	argv[argc] = 0;
  8004e4:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
  8004eb:	00 
	if (debug) {
  8004ec:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8004f3:	0f 85 99 00 00 00    	jne    800592 <runcmd+0x394>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	8d 45 a8             	lea    -0x58(%ebp),%eax
  8004ff:	50                   	push   %eax
  800500:	ff 75 a8             	pushl  -0x58(%ebp)
  800503:	e8 a5 1f 00 00       	call   8024ad <spawn>
  800508:	89 c6                	mov    %eax,%esi
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	85 c0                	test   %eax,%eax
  80050f:	0f 88 cb 00 00 00    	js     8005e0 <runcmd+0x3e2>
	close_all();
  800515:	e8 63 18 00 00       	call   801d7d <close_all>
		if (debug)
  80051a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800521:	0f 85 06 01 00 00    	jne    80062d <runcmd+0x42f>
		wait(r);
  800527:	83 ec 0c             	sub    $0xc,%esp
  80052a:	56                   	push   %esi
  80052b:	e8 e0 28 00 00       	call   802e10 <wait>
		if (debug)
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80053a:	0f 85 0c 01 00 00    	jne    80064c <runcmd+0x44e>
	if (pipe_child) {
  800540:	85 db                	test   %ebx,%ebx
  800542:	74 19                	je     80055d <runcmd+0x35f>
		wait(pipe_child);
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	53                   	push   %ebx
  800548:	e8 c3 28 00 00       	call   802e10 <wait>
		if (debug)
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800557:	0f 85 0a 01 00 00    	jne    800667 <runcmd+0x469>
	exit();
  80055d:	e8 ff 04 00 00       	call   800a61 <exit>
}
  800562:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800565:	5b                   	pop    %ebx
  800566:	5e                   	pop    %esi
  800567:	5f                   	pop    %edi
  800568:	5d                   	pop    %ebp
  800569:	c3                   	ret    
		argv0buf[0] = '/';
  80056a:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	50                   	push   %eax
  800575:	8d b5 a4 fb ff ff    	lea    -0x45c(%ebp),%esi
  80057b:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  800581:	50                   	push   %eax
  800582:	e8 a9 0c 00 00       	call   801230 <strcpy>
		argv[0] = argv0buf;
  800587:	89 75 a8             	mov    %esi,-0x58(%ebp)
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	e9 52 ff ff ff       	jmp    8004e4 <runcmd+0x2e6>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800592:	a1 24 54 80 00       	mov    0x805424,%eax
  800597:	8b 40 48             	mov    0x48(%eax),%eax
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	50                   	push   %eax
  80059e:	68 a3 32 80 00       	push   $0x8032a3
  8005a3:	e8 ae 05 00 00       	call   800b56 <cprintf>
  8005a8:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005ab:	83 c4 10             	add    $0x10,%esp
  8005ae:	83 c6 04             	add    $0x4,%esi
  8005b1:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005b4:	85 c0                	test   %eax,%eax
  8005b6:	74 13                	je     8005cb <runcmd+0x3cd>
			cprintf(" %s", argv[i]);
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	50                   	push   %eax
  8005bc:	68 2b 33 80 00       	push   $0x80332b
  8005c1:	e8 90 05 00 00       	call   800b56 <cprintf>
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	eb e3                	jmp    8005ae <runcmd+0x3b0>
		cprintf("\n");
  8005cb:	83 ec 0c             	sub    $0xc,%esp
  8005ce:	68 00 32 80 00       	push   $0x803200
  8005d3:	e8 7e 05 00 00       	call   800b56 <cprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	e9 19 ff ff ff       	jmp    8004f9 <runcmd+0x2fb>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005e0:	83 ec 04             	sub    $0x4,%esp
  8005e3:	50                   	push   %eax
  8005e4:	ff 75 a8             	pushl  -0x58(%ebp)
  8005e7:	68 b1 32 80 00       	push   $0x8032b1
  8005ec:	e8 65 05 00 00       	call   800b56 <cprintf>
	close_all();
  8005f1:	e8 87 17 00 00       	call   801d7d <close_all>
  8005f6:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005f9:	85 db                	test   %ebx,%ebx
  8005fb:	0f 84 5c ff ff ff    	je     80055d <runcmd+0x35f>
		if (debug)
  800601:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800608:	0f 84 36 ff ff ff    	je     800544 <runcmd+0x346>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  80060e:	a1 24 54 80 00       	mov    0x805424,%eax
  800613:	8b 40 48             	mov    0x48(%eax),%eax
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	53                   	push   %ebx
  80061a:	50                   	push   %eax
  80061b:	68 ea 32 80 00       	push   $0x8032ea
  800620:	e8 31 05 00 00       	call   800b56 <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	e9 17 ff ff ff       	jmp    800544 <runcmd+0x346>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  80062d:	a1 24 54 80 00       	mov    0x805424,%eax
  800632:	8b 40 48             	mov    0x48(%eax),%eax
  800635:	56                   	push   %esi
  800636:	ff 75 a8             	pushl  -0x58(%ebp)
  800639:	50                   	push   %eax
  80063a:	68 bf 32 80 00       	push   $0x8032bf
  80063f:	e8 12 05 00 00       	call   800b56 <cprintf>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	e9 db fe ff ff       	jmp    800527 <runcmd+0x329>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80064c:	a1 24 54 80 00       	mov    0x805424,%eax
  800651:	8b 40 48             	mov    0x48(%eax),%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	50                   	push   %eax
  800658:	68 d4 32 80 00       	push   $0x8032d4
  80065d:	e8 f4 04 00 00       	call   800b56 <cprintf>
  800662:	83 c4 10             	add    $0x10,%esp
  800665:	eb 92                	jmp    8005f9 <runcmd+0x3fb>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800667:	a1 24 54 80 00       	mov    0x805424,%eax
  80066c:	8b 40 48             	mov    0x48(%eax),%eax
  80066f:	83 ec 08             	sub    $0x8,%esp
  800672:	50                   	push   %eax
  800673:	68 d4 32 80 00       	push   $0x8032d4
  800678:	e8 d9 04 00 00       	call   800b56 <cprintf>
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	e9 d8 fe ff ff       	jmp    80055d <runcmd+0x35f>

00800685 <usage>:


void
usage(void)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  80068b:	68 b4 33 80 00       	push   $0x8033b4
  800690:	e8 c1 04 00 00       	call   800b56 <cprintf>
	exit();
  800695:	e8 c7 03 00 00       	call   800a61 <exit>
}
  80069a:	83 c4 10             	add    $0x10,%esp
  80069d:	c9                   	leave  
  80069e:	c3                   	ret    

0080069f <umain>:

void
umain(int argc, char **argv)
{
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
  8006a2:	57                   	push   %edi
  8006a3:	56                   	push   %esi
  8006a4:	53                   	push   %ebx
  8006a5:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  8006a8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8006ab:	50                   	push   %eax
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	8d 45 08             	lea    0x8(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 9b 13 00 00       	call   801a53 <argstart>
	while ((r = argnext(&args)) >= 0)
  8006b8:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  8006bb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  8006c2:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  8006c7:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006ca:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  8006cf:	eb 03                	jmp    8006d4 <umain+0x35>
			break;
		case 'x':
			echocmds = 1;
  8006d1:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006d4:	83 ec 0c             	sub    $0xc,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	e8 a6 13 00 00       	call   801a83 <argnext>
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	85 c0                	test   %eax,%eax
  8006e2:	78 23                	js     800707 <umain+0x68>
		switch (r) {
  8006e4:	83 f8 69             	cmp    $0x69,%eax
  8006e7:	74 1a                	je     800703 <umain+0x64>
  8006e9:	83 f8 78             	cmp    $0x78,%eax
  8006ec:	74 e3                	je     8006d1 <umain+0x32>
  8006ee:	83 f8 64             	cmp    $0x64,%eax
  8006f1:	74 07                	je     8006fa <umain+0x5b>
			break;
		default:
			usage();
  8006f3:	e8 8d ff ff ff       	call   800685 <usage>
  8006f8:	eb da                	jmp    8006d4 <umain+0x35>
			debug++;
  8006fa:	83 05 00 50 80 00 01 	addl   $0x1,0x805000
			break;
  800701:	eb d1                	jmp    8006d4 <umain+0x35>
			interactive = 1;
  800703:	89 f7                	mov    %esi,%edi
  800705:	eb cd                	jmp    8006d4 <umain+0x35>
		}

	if (argc > 2)
  800707:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  80070b:	7f 1f                	jg     80072c <umain+0x8d>
		usage();
	if (argc == 2) {
  80070d:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800711:	74 20                	je     800733 <umain+0x94>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  800713:	83 ff 3f             	cmp    $0x3f,%edi
  800716:	74 77                	je     80078f <umain+0xf0>
  800718:	85 ff                	test   %edi,%edi
  80071a:	bf 2f 33 80 00       	mov    $0x80332f,%edi
  80071f:	b8 00 00 00 00       	mov    $0x0,%eax
  800724:	0f 44 f8             	cmove  %eax,%edi
  800727:	e9 08 01 00 00       	jmp    800834 <umain+0x195>
		usage();
  80072c:	e8 54 ff ff ff       	call   800685 <usage>
  800731:	eb da                	jmp    80070d <umain+0x6e>
		close(0);
  800733:	83 ec 0c             	sub    $0xc,%esp
  800736:	6a 00                	push   $0x0
  800738:	e8 15 16 00 00       	call   801d52 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  80073d:	83 c4 08             	add    $0x8,%esp
  800740:	6a 00                	push   $0x0
  800742:	8b 45 0c             	mov    0xc(%ebp),%eax
  800745:	ff 70 04             	pushl  0x4(%eax)
  800748:	e8 a6 1b 00 00       	call   8022f3 <open>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	85 c0                	test   %eax,%eax
  800752:	78 1d                	js     800771 <umain+0xd2>
		assert(r == 0);
  800754:	85 c0                	test   %eax,%eax
  800756:	74 bb                	je     800713 <umain+0x74>
  800758:	68 13 33 80 00       	push   $0x803313
  80075d:	68 1a 33 80 00       	push   $0x80331a
  800762:	68 29 01 00 00       	push   $0x129
  800767:	68 8a 32 80 00       	push   $0x80328a
  80076c:	e8 0a 03 00 00       	call   800a7b <_panic>
			panic("open %s: %e", argv[1], r);
  800771:	83 ec 0c             	sub    $0xc,%esp
  800774:	50                   	push   %eax
  800775:	8b 45 0c             	mov    0xc(%ebp),%eax
  800778:	ff 70 04             	pushl  0x4(%eax)
  80077b:	68 07 33 80 00       	push   $0x803307
  800780:	68 28 01 00 00       	push   $0x128
  800785:	68 8a 32 80 00       	push   $0x80328a
  80078a:	e8 ec 02 00 00       	call   800a7b <_panic>
		interactive = iscons(0);
  80078f:	83 ec 0c             	sub    $0xc,%esp
  800792:	6a 00                	push   $0x0
  800794:	e8 04 02 00 00       	call   80099d <iscons>
  800799:	89 c7                	mov    %eax,%edi
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	e9 75 ff ff ff       	jmp    800718 <umain+0x79>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  8007a3:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8007aa:	75 0a                	jne    8007b6 <umain+0x117>
				cprintf("EXITING\n");
			exit();	// end of file
  8007ac:	e8 b0 02 00 00       	call   800a61 <exit>
  8007b1:	e9 94 00 00 00       	jmp    80084a <umain+0x1ab>
				cprintf("EXITING\n");
  8007b6:	83 ec 0c             	sub    $0xc,%esp
  8007b9:	68 32 33 80 00       	push   $0x803332
  8007be:	e8 93 03 00 00       	call   800b56 <cprintf>
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	eb e4                	jmp    8007ac <umain+0x10d>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	53                   	push   %ebx
  8007cc:	68 3b 33 80 00       	push   $0x80333b
  8007d1:	e8 80 03 00 00       	call   800b56 <cprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	eb 7c                	jmp    800857 <umain+0x1b8>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	53                   	push   %ebx
  8007df:	68 45 33 80 00       	push   $0x803345
  8007e4:	e8 ae 1c 00 00       	call   802497 <printf>
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	eb 78                	jmp    800866 <umain+0x1c7>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007ee:	83 ec 0c             	sub    $0xc,%esp
  8007f1:	68 4b 33 80 00       	push   $0x80334b
  8007f6:	e8 5b 03 00 00       	call   800b56 <cprintf>
  8007fb:	83 c4 10             	add    $0x10,%esp
  8007fe:	eb 73                	jmp    800873 <umain+0x1d4>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  800800:	50                   	push   %eax
  800801:	68 65 32 80 00       	push   $0x803265
  800806:	68 40 01 00 00       	push   $0x140
  80080b:	68 8a 32 80 00       	push   $0x80328a
  800810:	e8 66 02 00 00       	call   800a7b <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	50                   	push   %eax
  800819:	68 58 33 80 00       	push   $0x803358
  80081e:	e8 33 03 00 00       	call   800b56 <cprintf>
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	eb 5f                	jmp    800887 <umain+0x1e8>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  800828:	83 ec 0c             	sub    $0xc,%esp
  80082b:	56                   	push   %esi
  80082c:	e8 df 25 00 00       	call   802e10 <wait>
  800831:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	57                   	push   %edi
  800838:	e8 cc 08 00 00       	call   801109 <readline>
  80083d:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	85 c0                	test   %eax,%eax
  800844:	0f 84 59 ff ff ff    	je     8007a3 <umain+0x104>
		if (debug)
  80084a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800851:	0f 85 71 ff ff ff    	jne    8007c8 <umain+0x129>
		if (buf[0] == '#')
  800857:	80 3b 23             	cmpb   $0x23,(%ebx)
  80085a:	74 d8                	je     800834 <umain+0x195>
		if (echocmds)
  80085c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800860:	0f 85 75 ff ff ff    	jne    8007db <umain+0x13c>
		if (debug)
  800866:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80086d:	0f 85 7b ff ff ff    	jne    8007ee <umain+0x14f>
		if ((r = fork()) < 0)
  800873:	e8 b9 0f 00 00       	call   801831 <fork>
  800878:	89 c6                	mov    %eax,%esi
  80087a:	85 c0                	test   %eax,%eax
  80087c:	78 82                	js     800800 <umain+0x161>
		if (debug)
  80087e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800885:	75 8e                	jne    800815 <umain+0x176>
		if (r == 0) {
  800887:	85 f6                	test   %esi,%esi
  800889:	75 9d                	jne    800828 <umain+0x189>
			runcmd(buf);
  80088b:	83 ec 0c             	sub    $0xc,%esp
  80088e:	53                   	push   %ebx
  80088f:	e8 6a f9 ff ff       	call   8001fe <runcmd>
			exit();
  800894:	e8 c8 01 00 00       	call   800a61 <exit>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	eb 96                	jmp    800834 <umain+0x195>

0080089e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8008a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8008ae:	68 d5 33 80 00       	push   $0x8033d5
  8008b3:	ff 75 0c             	pushl  0xc(%ebp)
  8008b6:	e8 75 09 00 00       	call   801230 <strcpy>
	return 0;
}
  8008bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    

008008c2 <devcons_write>:
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	57                   	push   %edi
  8008c6:	56                   	push   %esi
  8008c7:	53                   	push   %ebx
  8008c8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008ce:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008d3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008d9:	eb 2f                	jmp    80090a <devcons_write+0x48>
		m = n - tot;
  8008db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008de:	29 f3                	sub    %esi,%ebx
  8008e0:	83 fb 7f             	cmp    $0x7f,%ebx
  8008e3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008e8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8008eb:	83 ec 04             	sub    $0x4,%esp
  8008ee:	53                   	push   %ebx
  8008ef:	89 f0                	mov    %esi,%eax
  8008f1:	03 45 0c             	add    0xc(%ebp),%eax
  8008f4:	50                   	push   %eax
  8008f5:	57                   	push   %edi
  8008f6:	e8 c3 0a 00 00       	call   8013be <memmove>
		sys_cputs(buf, m);
  8008fb:	83 c4 08             	add    $0x8,%esp
  8008fe:	53                   	push   %ebx
  8008ff:	57                   	push   %edi
  800900:	e8 68 0c 00 00       	call   80156d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800905:	01 de                	add    %ebx,%esi
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80090d:	72 cc                	jb     8008db <devcons_write+0x19>
}
  80090f:	89 f0                	mov    %esi,%eax
  800911:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800914:	5b                   	pop    %ebx
  800915:	5e                   	pop    %esi
  800916:	5f                   	pop    %edi
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <devcons_read>:
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800924:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800928:	75 07                	jne    800931 <devcons_read+0x18>
}
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    
		sys_yield();
  80092c:	e8 d9 0c 00 00       	call   80160a <sys_yield>
	while ((c = sys_cgetc()) == 0)
  800931:	e8 55 0c 00 00       	call   80158b <sys_cgetc>
  800936:	85 c0                	test   %eax,%eax
  800938:	74 f2                	je     80092c <devcons_read+0x13>
	if (c < 0)
  80093a:	85 c0                	test   %eax,%eax
  80093c:	78 ec                	js     80092a <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  80093e:	83 f8 04             	cmp    $0x4,%eax
  800941:	74 0c                	je     80094f <devcons_read+0x36>
	*(char*)vbuf = c;
  800943:	8b 55 0c             	mov    0xc(%ebp),%edx
  800946:	88 02                	mov    %al,(%edx)
	return 1;
  800948:	b8 01 00 00 00       	mov    $0x1,%eax
  80094d:	eb db                	jmp    80092a <devcons_read+0x11>
		return 0;
  80094f:	b8 00 00 00 00       	mov    $0x0,%eax
  800954:	eb d4                	jmp    80092a <devcons_read+0x11>

00800956 <cputchar>:
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800962:	6a 01                	push   $0x1
  800964:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800967:	50                   	push   %eax
  800968:	e8 00 0c 00 00       	call   80156d <sys_cputs>
}
  80096d:	83 c4 10             	add    $0x10,%esp
  800970:	c9                   	leave  
  800971:	c3                   	ret    

00800972 <getchar>:
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800978:	6a 01                	push   $0x1
  80097a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	6a 00                	push   $0x0
  800980:	e8 09 15 00 00       	call   801e8e <read>
	if (r < 0)
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	85 c0                	test   %eax,%eax
  80098a:	78 08                	js     800994 <getchar+0x22>
	if (r < 1)
  80098c:	85 c0                	test   %eax,%eax
  80098e:	7e 06                	jle    800996 <getchar+0x24>
	return c;
  800990:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800994:	c9                   	leave  
  800995:	c3                   	ret    
		return -E_EOF;
  800996:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80099b:	eb f7                	jmp    800994 <getchar+0x22>

0080099d <iscons>:
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009a6:	50                   	push   %eax
  8009a7:	ff 75 08             	pushl  0x8(%ebp)
  8009aa:	e8 6e 12 00 00       	call   801c1d <fd_lookup>
  8009af:	83 c4 10             	add    $0x10,%esp
  8009b2:	85 c0                	test   %eax,%eax
  8009b4:	78 11                	js     8009c7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8009b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b9:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009bf:	39 10                	cmp    %edx,(%eax)
  8009c1:	0f 94 c0             	sete   %al
  8009c4:	0f b6 c0             	movzbl %al,%eax
}
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <opencons>:
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009d2:	50                   	push   %eax
  8009d3:	e8 f6 11 00 00       	call   801bce <fd_alloc>
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	85 c0                	test   %eax,%eax
  8009dd:	78 3a                	js     800a19 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009df:	83 ec 04             	sub    $0x4,%esp
  8009e2:	68 07 04 00 00       	push   $0x407
  8009e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ea:	6a 00                	push   $0x0
  8009ec:	e8 38 0c 00 00       	call   801629 <sys_page_alloc>
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	85 c0                	test   %eax,%eax
  8009f6:	78 21                	js     800a19 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8009f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fb:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800a01:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a06:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a0d:	83 ec 0c             	sub    $0xc,%esp
  800a10:	50                   	push   %eax
  800a11:	e8 91 11 00 00       	call   801ba7 <fd2num>
  800a16:	83 c4 10             	add    $0x10,%esp
}
  800a19:	c9                   	leave  
  800a1a:	c3                   	ret    

00800a1b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	56                   	push   %esi
  800a1f:	53                   	push   %ebx
  800a20:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a23:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a26:	e8 c0 0b 00 00       	call   8015eb <sys_getenvid>
  800a2b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a30:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a33:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a38:	a3 24 54 80 00       	mov    %eax,0x805424

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a3d:	85 db                	test   %ebx,%ebx
  800a3f:	7e 07                	jle    800a48 <libmain+0x2d>
		binaryname = argv[0];
  800a41:	8b 06                	mov    (%esi),%eax
  800a43:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	56                   	push   %esi
  800a4c:	53                   	push   %ebx
  800a4d:	e8 4d fc ff ff       	call   80069f <umain>

	// exit gracefully
	exit();
  800a52:	e8 0a 00 00 00       	call   800a61 <exit>
}
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a5d:	5b                   	pop    %ebx
  800a5e:	5e                   	pop    %esi
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    

00800a61 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800a67:	e8 11 13 00 00       	call   801d7d <close_all>
	sys_env_destroy(0);
  800a6c:	83 ec 0c             	sub    $0xc,%esp
  800a6f:	6a 00                	push   $0x0
  800a71:	e8 34 0b 00 00       	call   8015aa <sys_env_destroy>
}
  800a76:	83 c4 10             	add    $0x10,%esp
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	56                   	push   %esi
  800a7f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800a80:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a83:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800a89:	e8 5d 0b 00 00       	call   8015eb <sys_getenvid>
  800a8e:	83 ec 0c             	sub    $0xc,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	ff 75 08             	pushl  0x8(%ebp)
  800a97:	56                   	push   %esi
  800a98:	50                   	push   %eax
  800a99:	68 ec 33 80 00       	push   $0x8033ec
  800a9e:	e8 b3 00 00 00       	call   800b56 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800aa3:	83 c4 18             	add    $0x18,%esp
  800aa6:	53                   	push   %ebx
  800aa7:	ff 75 10             	pushl  0x10(%ebp)
  800aaa:	e8 56 00 00 00       	call   800b05 <vcprintf>
	cprintf("\n");
  800aaf:	c7 04 24 00 32 80 00 	movl   $0x803200,(%esp)
  800ab6:	e8 9b 00 00 00       	call   800b56 <cprintf>
  800abb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800abe:	cc                   	int3   
  800abf:	eb fd                	jmp    800abe <_panic+0x43>

00800ac1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	53                   	push   %ebx
  800ac5:	83 ec 04             	sub    $0x4,%esp
  800ac8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800acb:	8b 13                	mov    (%ebx),%edx
  800acd:	8d 42 01             	lea    0x1(%edx),%eax
  800ad0:	89 03                	mov    %eax,(%ebx)
  800ad2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800ad9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ade:	74 09                	je     800ae9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800ae0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800ae4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae7:	c9                   	leave  
  800ae8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	68 ff 00 00 00       	push   $0xff
  800af1:	8d 43 08             	lea    0x8(%ebx),%eax
  800af4:	50                   	push   %eax
  800af5:	e8 73 0a 00 00       	call   80156d <sys_cputs>
		b->idx = 0;
  800afa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b00:	83 c4 10             	add    $0x10,%esp
  800b03:	eb db                	jmp    800ae0 <putch+0x1f>

00800b05 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b0e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b15:	00 00 00 
	b.cnt = 0;
  800b18:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b1f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	ff 75 08             	pushl  0x8(%ebp)
  800b28:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b2e:	50                   	push   %eax
  800b2f:	68 c1 0a 80 00       	push   $0x800ac1
  800b34:	e8 1a 01 00 00       	call   800c53 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b39:	83 c4 08             	add    $0x8,%esp
  800b3c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b42:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b48:	50                   	push   %eax
  800b49:	e8 1f 0a 00 00       	call   80156d <sys_cputs>

	return b.cnt;
}
  800b4e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b54:	c9                   	leave  
  800b55:	c3                   	ret    

00800b56 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b5c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b5f:	50                   	push   %eax
  800b60:	ff 75 08             	pushl  0x8(%ebp)
  800b63:	e8 9d ff ff ff       	call   800b05 <vcprintf>
	va_end(ap);

	return cnt;
}
  800b68:	c9                   	leave  
  800b69:	c3                   	ret    

00800b6a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	57                   	push   %edi
  800b6e:	56                   	push   %esi
  800b6f:	53                   	push   %ebx
  800b70:	83 ec 1c             	sub    $0x1c,%esp
  800b73:	89 c7                	mov    %eax,%edi
  800b75:	89 d6                	mov    %edx,%esi
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b80:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b8b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800b8e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800b91:	39 d3                	cmp    %edx,%ebx
  800b93:	72 05                	jb     800b9a <printnum+0x30>
  800b95:	39 45 10             	cmp    %eax,0x10(%ebp)
  800b98:	77 7a                	ja     800c14 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b9a:	83 ec 0c             	sub    $0xc,%esp
  800b9d:	ff 75 18             	pushl  0x18(%ebp)
  800ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ba6:	53                   	push   %ebx
  800ba7:	ff 75 10             	pushl  0x10(%ebp)
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bb0:	ff 75 e0             	pushl  -0x20(%ebp)
  800bb3:	ff 75 dc             	pushl  -0x24(%ebp)
  800bb6:	ff 75 d8             	pushl  -0x28(%ebp)
  800bb9:	e8 e2 23 00 00       	call   802fa0 <__udivdi3>
  800bbe:	83 c4 18             	add    $0x18,%esp
  800bc1:	52                   	push   %edx
  800bc2:	50                   	push   %eax
  800bc3:	89 f2                	mov    %esi,%edx
  800bc5:	89 f8                	mov    %edi,%eax
  800bc7:	e8 9e ff ff ff       	call   800b6a <printnum>
  800bcc:	83 c4 20             	add    $0x20,%esp
  800bcf:	eb 13                	jmp    800be4 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	56                   	push   %esi
  800bd5:	ff 75 18             	pushl  0x18(%ebp)
  800bd8:	ff d7                	call   *%edi
  800bda:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800bdd:	83 eb 01             	sub    $0x1,%ebx
  800be0:	85 db                	test   %ebx,%ebx
  800be2:	7f ed                	jg     800bd1 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800be4:	83 ec 08             	sub    $0x8,%esp
  800be7:	56                   	push   %esi
  800be8:	83 ec 04             	sub    $0x4,%esp
  800beb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bee:	ff 75 e0             	pushl  -0x20(%ebp)
  800bf1:	ff 75 dc             	pushl  -0x24(%ebp)
  800bf4:	ff 75 d8             	pushl  -0x28(%ebp)
  800bf7:	e8 c4 24 00 00       	call   8030c0 <__umoddi3>
  800bfc:	83 c4 14             	add    $0x14,%esp
  800bff:	0f be 80 0f 34 80 00 	movsbl 0x80340f(%eax),%eax
  800c06:	50                   	push   %eax
  800c07:	ff d7                	call   *%edi
}
  800c09:	83 c4 10             	add    $0x10,%esp
  800c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    
  800c14:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800c17:	eb c4                	jmp    800bdd <printnum+0x73>

00800c19 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c1f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c23:	8b 10                	mov    (%eax),%edx
  800c25:	3b 50 04             	cmp    0x4(%eax),%edx
  800c28:	73 0a                	jae    800c34 <sprintputch+0x1b>
		*b->buf++ = ch;
  800c2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c2d:	89 08                	mov    %ecx,(%eax)
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	88 02                	mov    %al,(%edx)
}
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <printfmt>:
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c3c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c3f:	50                   	push   %eax
  800c40:	ff 75 10             	pushl  0x10(%ebp)
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	ff 75 08             	pushl  0x8(%ebp)
  800c49:	e8 05 00 00 00       	call   800c53 <vprintfmt>
}
  800c4e:	83 c4 10             	add    $0x10,%esp
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <vprintfmt>:
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	83 ec 2c             	sub    $0x2c,%esp
  800c5c:	8b 75 08             	mov    0x8(%ebp),%esi
  800c5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c62:	8b 7d 10             	mov    0x10(%ebp),%edi
  800c65:	e9 8c 03 00 00       	jmp    800ff6 <vprintfmt+0x3a3>
		padc = ' ';
  800c6a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800c6e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800c75:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800c7c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c83:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800c88:	8d 47 01             	lea    0x1(%edi),%eax
  800c8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c8e:	0f b6 17             	movzbl (%edi),%edx
  800c91:	8d 42 dd             	lea    -0x23(%edx),%eax
  800c94:	3c 55                	cmp    $0x55,%al
  800c96:	0f 87 dd 03 00 00    	ja     801079 <vprintfmt+0x426>
  800c9c:	0f b6 c0             	movzbl %al,%eax
  800c9f:	ff 24 85 60 35 80 00 	jmp    *0x803560(,%eax,4)
  800ca6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800ca9:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800cad:	eb d9                	jmp    800c88 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800caf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800cb2:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800cb6:	eb d0                	jmp    800c88 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800cb8:	0f b6 d2             	movzbl %dl,%edx
  800cbb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800cc6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800cc9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800ccd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800cd0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800cd3:	83 f9 09             	cmp    $0x9,%ecx
  800cd6:	77 55                	ja     800d2d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800cd8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800cdb:	eb e9                	jmp    800cc6 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	8d 40 04             	lea    0x4(%eax),%eax
  800ceb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800cee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800cf1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cf5:	79 91                	jns    800c88 <vprintfmt+0x35>
				width = precision, precision = -1;
  800cf7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800cfd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800d04:	eb 82                	jmp    800c88 <vprintfmt+0x35>
  800d06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d09:	85 c0                	test   %eax,%eax
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	0f 49 d0             	cmovns %eax,%edx
  800d13:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d19:	e9 6a ff ff ff       	jmp    800c88 <vprintfmt+0x35>
  800d1e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d21:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800d28:	e9 5b ff ff ff       	jmp    800c88 <vprintfmt+0x35>
  800d2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800d30:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d33:	eb bc                	jmp    800cf1 <vprintfmt+0x9e>
			lflag++;
  800d35:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d38:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d3b:	e9 48 ff ff ff       	jmp    800c88 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	8d 78 04             	lea    0x4(%eax),%edi
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	53                   	push   %ebx
  800d4a:	ff 30                	pushl  (%eax)
  800d4c:	ff d6                	call   *%esi
			break;
  800d4e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d51:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d54:	e9 9a 02 00 00       	jmp    800ff3 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800d59:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5c:	8d 78 04             	lea    0x4(%eax),%edi
  800d5f:	8b 00                	mov    (%eax),%eax
  800d61:	99                   	cltd   
  800d62:	31 d0                	xor    %edx,%eax
  800d64:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d66:	83 f8 0f             	cmp    $0xf,%eax
  800d69:	7f 23                	jg     800d8e <vprintfmt+0x13b>
  800d6b:	8b 14 85 c0 36 80 00 	mov    0x8036c0(,%eax,4),%edx
  800d72:	85 d2                	test   %edx,%edx
  800d74:	74 18                	je     800d8e <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800d76:	52                   	push   %edx
  800d77:	68 2c 33 80 00       	push   $0x80332c
  800d7c:	53                   	push   %ebx
  800d7d:	56                   	push   %esi
  800d7e:	e8 b3 fe ff ff       	call   800c36 <printfmt>
  800d83:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d86:	89 7d 14             	mov    %edi,0x14(%ebp)
  800d89:	e9 65 02 00 00       	jmp    800ff3 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800d8e:	50                   	push   %eax
  800d8f:	68 27 34 80 00       	push   $0x803427
  800d94:	53                   	push   %ebx
  800d95:	56                   	push   %esi
  800d96:	e8 9b fe ff ff       	call   800c36 <printfmt>
  800d9b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800d9e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800da1:	e9 4d 02 00 00       	jmp    800ff3 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800da6:	8b 45 14             	mov    0x14(%ebp),%eax
  800da9:	83 c0 04             	add    $0x4,%eax
  800dac:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800daf:	8b 45 14             	mov    0x14(%ebp),%eax
  800db2:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800db4:	85 ff                	test   %edi,%edi
  800db6:	b8 20 34 80 00       	mov    $0x803420,%eax
  800dbb:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800dbe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc2:	0f 8e bd 00 00 00    	jle    800e85 <vprintfmt+0x232>
  800dc8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800dcc:	75 0e                	jne    800ddc <vprintfmt+0x189>
  800dce:	89 75 08             	mov    %esi,0x8(%ebp)
  800dd1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800dd4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800dd7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800dda:	eb 6d                	jmp    800e49 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 d0             	pushl  -0x30(%ebp)
  800de2:	57                   	push   %edi
  800de3:	e8 29 04 00 00       	call   801211 <strnlen>
  800de8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800deb:	29 c1                	sub    %eax,%ecx
  800ded:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800df0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800df3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800df7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800dfa:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800dfd:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800dff:	eb 0f                	jmp    800e10 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800e01:	83 ec 08             	sub    $0x8,%esp
  800e04:	53                   	push   %ebx
  800e05:	ff 75 e0             	pushl  -0x20(%ebp)
  800e08:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e0a:	83 ef 01             	sub    $0x1,%edi
  800e0d:	83 c4 10             	add    $0x10,%esp
  800e10:	85 ff                	test   %edi,%edi
  800e12:	7f ed                	jg     800e01 <vprintfmt+0x1ae>
  800e14:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800e17:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800e1a:	85 c9                	test   %ecx,%ecx
  800e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e21:	0f 49 c1             	cmovns %ecx,%eax
  800e24:	29 c1                	sub    %eax,%ecx
  800e26:	89 75 08             	mov    %esi,0x8(%ebp)
  800e29:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800e2c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800e2f:	89 cb                	mov    %ecx,%ebx
  800e31:	eb 16                	jmp    800e49 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800e33:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e37:	75 31                	jne    800e6a <vprintfmt+0x217>
					putch(ch, putdat);
  800e39:	83 ec 08             	sub    $0x8,%esp
  800e3c:	ff 75 0c             	pushl  0xc(%ebp)
  800e3f:	50                   	push   %eax
  800e40:	ff 55 08             	call   *0x8(%ebp)
  800e43:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e46:	83 eb 01             	sub    $0x1,%ebx
  800e49:	83 c7 01             	add    $0x1,%edi
  800e4c:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800e50:	0f be c2             	movsbl %dl,%eax
  800e53:	85 c0                	test   %eax,%eax
  800e55:	74 59                	je     800eb0 <vprintfmt+0x25d>
  800e57:	85 f6                	test   %esi,%esi
  800e59:	78 d8                	js     800e33 <vprintfmt+0x1e0>
  800e5b:	83 ee 01             	sub    $0x1,%esi
  800e5e:	79 d3                	jns    800e33 <vprintfmt+0x1e0>
  800e60:	89 df                	mov    %ebx,%edi
  800e62:	8b 75 08             	mov    0x8(%ebp),%esi
  800e65:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e68:	eb 37                	jmp    800ea1 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800e6a:	0f be d2             	movsbl %dl,%edx
  800e6d:	83 ea 20             	sub    $0x20,%edx
  800e70:	83 fa 5e             	cmp    $0x5e,%edx
  800e73:	76 c4                	jbe    800e39 <vprintfmt+0x1e6>
					putch('?', putdat);
  800e75:	83 ec 08             	sub    $0x8,%esp
  800e78:	ff 75 0c             	pushl  0xc(%ebp)
  800e7b:	6a 3f                	push   $0x3f
  800e7d:	ff 55 08             	call   *0x8(%ebp)
  800e80:	83 c4 10             	add    $0x10,%esp
  800e83:	eb c1                	jmp    800e46 <vprintfmt+0x1f3>
  800e85:	89 75 08             	mov    %esi,0x8(%ebp)
  800e88:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800e8b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800e8e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800e91:	eb b6                	jmp    800e49 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800e93:	83 ec 08             	sub    $0x8,%esp
  800e96:	53                   	push   %ebx
  800e97:	6a 20                	push   $0x20
  800e99:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800e9b:	83 ef 01             	sub    $0x1,%edi
  800e9e:	83 c4 10             	add    $0x10,%esp
  800ea1:	85 ff                	test   %edi,%edi
  800ea3:	7f ee                	jg     800e93 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800ea5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800ea8:	89 45 14             	mov    %eax,0x14(%ebp)
  800eab:	e9 43 01 00 00       	jmp    800ff3 <vprintfmt+0x3a0>
  800eb0:	89 df                	mov    %ebx,%edi
  800eb2:	8b 75 08             	mov    0x8(%ebp),%esi
  800eb5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800eb8:	eb e7                	jmp    800ea1 <vprintfmt+0x24e>
	if (lflag >= 2)
  800eba:	83 f9 01             	cmp    $0x1,%ecx
  800ebd:	7e 3f                	jle    800efe <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800ebf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec2:	8b 50 04             	mov    0x4(%eax),%edx
  800ec5:	8b 00                	mov    (%eax),%eax
  800ec7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800eca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed0:	8d 40 08             	lea    0x8(%eax),%eax
  800ed3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800ed6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800eda:	79 5c                	jns    800f38 <vprintfmt+0x2e5>
				putch('-', putdat);
  800edc:	83 ec 08             	sub    $0x8,%esp
  800edf:	53                   	push   %ebx
  800ee0:	6a 2d                	push   $0x2d
  800ee2:	ff d6                	call   *%esi
				num = -(long long) num;
  800ee4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ee7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800eea:	f7 da                	neg    %edx
  800eec:	83 d1 00             	adc    $0x0,%ecx
  800eef:	f7 d9                	neg    %ecx
  800ef1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ef4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef9:	e9 db 00 00 00       	jmp    800fd9 <vprintfmt+0x386>
	else if (lflag)
  800efe:	85 c9                	test   %ecx,%ecx
  800f00:	75 1b                	jne    800f1d <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800f02:	8b 45 14             	mov    0x14(%ebp),%eax
  800f05:	8b 00                	mov    (%eax),%eax
  800f07:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f0a:	89 c1                	mov    %eax,%ecx
  800f0c:	c1 f9 1f             	sar    $0x1f,%ecx
  800f0f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f12:	8b 45 14             	mov    0x14(%ebp),%eax
  800f15:	8d 40 04             	lea    0x4(%eax),%eax
  800f18:	89 45 14             	mov    %eax,0x14(%ebp)
  800f1b:	eb b9                	jmp    800ed6 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800f1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f20:	8b 00                	mov    (%eax),%eax
  800f22:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f25:	89 c1                	mov    %eax,%ecx
  800f27:	c1 f9 1f             	sar    $0x1f,%ecx
  800f2a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f30:	8d 40 04             	lea    0x4(%eax),%eax
  800f33:	89 45 14             	mov    %eax,0x14(%ebp)
  800f36:	eb 9e                	jmp    800ed6 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800f38:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800f3b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800f3e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f43:	e9 91 00 00 00       	jmp    800fd9 <vprintfmt+0x386>
	if (lflag >= 2)
  800f48:	83 f9 01             	cmp    $0x1,%ecx
  800f4b:	7e 15                	jle    800f62 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800f4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f50:	8b 10                	mov    (%eax),%edx
  800f52:	8b 48 04             	mov    0x4(%eax),%ecx
  800f55:	8d 40 08             	lea    0x8(%eax),%eax
  800f58:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f5b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f60:	eb 77                	jmp    800fd9 <vprintfmt+0x386>
	else if (lflag)
  800f62:	85 c9                	test   %ecx,%ecx
  800f64:	75 17                	jne    800f7d <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800f66:	8b 45 14             	mov    0x14(%ebp),%eax
  800f69:	8b 10                	mov    (%eax),%edx
  800f6b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f70:	8d 40 04             	lea    0x4(%eax),%eax
  800f73:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f76:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f7b:	eb 5c                	jmp    800fd9 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800f7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f80:	8b 10                	mov    (%eax),%edx
  800f82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f87:	8d 40 04             	lea    0x4(%eax),%eax
  800f8a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f92:	eb 45                	jmp    800fd9 <vprintfmt+0x386>
			putch('X', putdat);
  800f94:	83 ec 08             	sub    $0x8,%esp
  800f97:	53                   	push   %ebx
  800f98:	6a 58                	push   $0x58
  800f9a:	ff d6                	call   *%esi
			putch('X', putdat);
  800f9c:	83 c4 08             	add    $0x8,%esp
  800f9f:	53                   	push   %ebx
  800fa0:	6a 58                	push   $0x58
  800fa2:	ff d6                	call   *%esi
			putch('X', putdat);
  800fa4:	83 c4 08             	add    $0x8,%esp
  800fa7:	53                   	push   %ebx
  800fa8:	6a 58                	push   $0x58
  800faa:	ff d6                	call   *%esi
			break;
  800fac:	83 c4 10             	add    $0x10,%esp
  800faf:	eb 42                	jmp    800ff3 <vprintfmt+0x3a0>
			putch('0', putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	53                   	push   %ebx
  800fb5:	6a 30                	push   $0x30
  800fb7:	ff d6                	call   *%esi
			putch('x', putdat);
  800fb9:	83 c4 08             	add    $0x8,%esp
  800fbc:	53                   	push   %ebx
  800fbd:	6a 78                	push   $0x78
  800fbf:	ff d6                	call   *%esi
			num = (unsigned long long)
  800fc1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc4:	8b 10                	mov    (%eax),%edx
  800fc6:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800fcb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800fce:	8d 40 04             	lea    0x4(%eax),%eax
  800fd1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800fd4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800fd9:	83 ec 0c             	sub    $0xc,%esp
  800fdc:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800fe0:	57                   	push   %edi
  800fe1:	ff 75 e0             	pushl  -0x20(%ebp)
  800fe4:	50                   	push   %eax
  800fe5:	51                   	push   %ecx
  800fe6:	52                   	push   %edx
  800fe7:	89 da                	mov    %ebx,%edx
  800fe9:	89 f0                	mov    %esi,%eax
  800feb:	e8 7a fb ff ff       	call   800b6a <printnum>
			break;
  800ff0:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800ff3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ff6:	83 c7 01             	add    $0x1,%edi
  800ff9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ffd:	83 f8 25             	cmp    $0x25,%eax
  801000:	0f 84 64 fc ff ff    	je     800c6a <vprintfmt+0x17>
			if (ch == '\0')
  801006:	85 c0                	test   %eax,%eax
  801008:	0f 84 8b 00 00 00    	je     801099 <vprintfmt+0x446>
			putch(ch, putdat);
  80100e:	83 ec 08             	sub    $0x8,%esp
  801011:	53                   	push   %ebx
  801012:	50                   	push   %eax
  801013:	ff d6                	call   *%esi
  801015:	83 c4 10             	add    $0x10,%esp
  801018:	eb dc                	jmp    800ff6 <vprintfmt+0x3a3>
	if (lflag >= 2)
  80101a:	83 f9 01             	cmp    $0x1,%ecx
  80101d:	7e 15                	jle    801034 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  80101f:	8b 45 14             	mov    0x14(%ebp),%eax
  801022:	8b 10                	mov    (%eax),%edx
  801024:	8b 48 04             	mov    0x4(%eax),%ecx
  801027:	8d 40 08             	lea    0x8(%eax),%eax
  80102a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80102d:	b8 10 00 00 00       	mov    $0x10,%eax
  801032:	eb a5                	jmp    800fd9 <vprintfmt+0x386>
	else if (lflag)
  801034:	85 c9                	test   %ecx,%ecx
  801036:	75 17                	jne    80104f <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  801038:	8b 45 14             	mov    0x14(%ebp),%eax
  80103b:	8b 10                	mov    (%eax),%edx
  80103d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801042:	8d 40 04             	lea    0x4(%eax),%eax
  801045:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801048:	b8 10 00 00 00       	mov    $0x10,%eax
  80104d:	eb 8a                	jmp    800fd9 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80104f:	8b 45 14             	mov    0x14(%ebp),%eax
  801052:	8b 10                	mov    (%eax),%edx
  801054:	b9 00 00 00 00       	mov    $0x0,%ecx
  801059:	8d 40 04             	lea    0x4(%eax),%eax
  80105c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80105f:	b8 10 00 00 00       	mov    $0x10,%eax
  801064:	e9 70 ff ff ff       	jmp    800fd9 <vprintfmt+0x386>
			putch(ch, putdat);
  801069:	83 ec 08             	sub    $0x8,%esp
  80106c:	53                   	push   %ebx
  80106d:	6a 25                	push   $0x25
  80106f:	ff d6                	call   *%esi
			break;
  801071:	83 c4 10             	add    $0x10,%esp
  801074:	e9 7a ff ff ff       	jmp    800ff3 <vprintfmt+0x3a0>
			putch('%', putdat);
  801079:	83 ec 08             	sub    $0x8,%esp
  80107c:	53                   	push   %ebx
  80107d:	6a 25                	push   $0x25
  80107f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801081:	83 c4 10             	add    $0x10,%esp
  801084:	89 f8                	mov    %edi,%eax
  801086:	eb 03                	jmp    80108b <vprintfmt+0x438>
  801088:	83 e8 01             	sub    $0x1,%eax
  80108b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80108f:	75 f7                	jne    801088 <vprintfmt+0x435>
  801091:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801094:	e9 5a ff ff ff       	jmp    800ff3 <vprintfmt+0x3a0>
}
  801099:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    

008010a1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 18             	sub    $0x18,%esp
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010b0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010b4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	74 26                	je     8010e8 <vsnprintf+0x47>
  8010c2:	85 d2                	test   %edx,%edx
  8010c4:	7e 22                	jle    8010e8 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010c6:	ff 75 14             	pushl  0x14(%ebp)
  8010c9:	ff 75 10             	pushl  0x10(%ebp)
  8010cc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010cf:	50                   	push   %eax
  8010d0:	68 19 0c 80 00       	push   $0x800c19
  8010d5:	e8 79 fb ff ff       	call   800c53 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8010da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010dd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e3:	83 c4 10             	add    $0x10,%esp
}
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    
		return -E_INVAL;
  8010e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ed:	eb f7                	jmp    8010e6 <vsnprintf+0x45>

008010ef <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010f5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8010f8:	50                   	push   %eax
  8010f9:	ff 75 10             	pushl  0x10(%ebp)
  8010fc:	ff 75 0c             	pushl  0xc(%ebp)
  8010ff:	ff 75 08             	pushl  0x8(%ebp)
  801102:	e8 9a ff ff ff       	call   8010a1 <vsnprintf>
	va_end(ap);

	return rc;
}
  801107:	c9                   	leave  
  801108:	c3                   	ret    

00801109 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	57                   	push   %edi
  80110d:	56                   	push   %esi
  80110e:	53                   	push   %ebx
  80110f:	83 ec 0c             	sub    $0xc,%esp
  801112:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801115:	85 c0                	test   %eax,%eax
  801117:	74 13                	je     80112c <readline+0x23>
		fprintf(1, "%s", prompt);
  801119:	83 ec 04             	sub    $0x4,%esp
  80111c:	50                   	push   %eax
  80111d:	68 2c 33 80 00       	push   $0x80332c
  801122:	6a 01                	push   $0x1
  801124:	e8 57 13 00 00       	call   802480 <fprintf>
  801129:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  80112c:	83 ec 0c             	sub    $0xc,%esp
  80112f:	6a 00                	push   $0x0
  801131:	e8 67 f8 ff ff       	call   80099d <iscons>
  801136:	89 c7                	mov    %eax,%edi
  801138:	83 c4 10             	add    $0x10,%esp
	i = 0;
  80113b:	be 00 00 00 00       	mov    $0x0,%esi
  801140:	eb 4b                	jmp    80118d <readline+0x84>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  801142:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801147:	83 fb f8             	cmp    $0xfffffff8,%ebx
  80114a:	75 08                	jne    801154 <readline+0x4b>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  80114c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114f:	5b                   	pop    %ebx
  801150:	5e                   	pop    %esi
  801151:	5f                   	pop    %edi
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    
				cprintf("read error: %e\n", c);
  801154:	83 ec 08             	sub    $0x8,%esp
  801157:	53                   	push   %ebx
  801158:	68 1f 37 80 00       	push   $0x80371f
  80115d:	e8 f4 f9 ff ff       	call   800b56 <cprintf>
  801162:	83 c4 10             	add    $0x10,%esp
			return NULL;
  801165:	b8 00 00 00 00       	mov    $0x0,%eax
  80116a:	eb e0                	jmp    80114c <readline+0x43>
			if (echoing)
  80116c:	85 ff                	test   %edi,%edi
  80116e:	75 05                	jne    801175 <readline+0x6c>
			i--;
  801170:	83 ee 01             	sub    $0x1,%esi
  801173:	eb 18                	jmp    80118d <readline+0x84>
				cputchar('\b');
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	6a 08                	push   $0x8
  80117a:	e8 d7 f7 ff ff       	call   800956 <cputchar>
  80117f:	83 c4 10             	add    $0x10,%esp
  801182:	eb ec                	jmp    801170 <readline+0x67>
			buf[i++] = c;
  801184:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  80118a:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  80118d:	e8 e0 f7 ff ff       	call   800972 <getchar>
  801192:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801194:	85 c0                	test   %eax,%eax
  801196:	78 aa                	js     801142 <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801198:	83 f8 08             	cmp    $0x8,%eax
  80119b:	0f 94 c2             	sete   %dl
  80119e:	83 f8 7f             	cmp    $0x7f,%eax
  8011a1:	0f 94 c0             	sete   %al
  8011a4:	08 c2                	or     %al,%dl
  8011a6:	74 04                	je     8011ac <readline+0xa3>
  8011a8:	85 f6                	test   %esi,%esi
  8011aa:	7f c0                	jg     80116c <readline+0x63>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011ac:	83 fb 1f             	cmp    $0x1f,%ebx
  8011af:	7e 1a                	jle    8011cb <readline+0xc2>
  8011b1:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8011b7:	7f 12                	jg     8011cb <readline+0xc2>
			if (echoing)
  8011b9:	85 ff                	test   %edi,%edi
  8011bb:	74 c7                	je     801184 <readline+0x7b>
				cputchar(c);
  8011bd:	83 ec 0c             	sub    $0xc,%esp
  8011c0:	53                   	push   %ebx
  8011c1:	e8 90 f7 ff ff       	call   800956 <cputchar>
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	eb b9                	jmp    801184 <readline+0x7b>
		} else if (c == '\n' || c == '\r') {
  8011cb:	83 fb 0a             	cmp    $0xa,%ebx
  8011ce:	74 05                	je     8011d5 <readline+0xcc>
  8011d0:	83 fb 0d             	cmp    $0xd,%ebx
  8011d3:	75 b8                	jne    80118d <readline+0x84>
			if (echoing)
  8011d5:	85 ff                	test   %edi,%edi
  8011d7:	75 11                	jne    8011ea <readline+0xe1>
			buf[i] = 0;
  8011d9:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  8011e0:	b8 20 50 80 00       	mov    $0x805020,%eax
  8011e5:	e9 62 ff ff ff       	jmp    80114c <readline+0x43>
				cputchar('\n');
  8011ea:	83 ec 0c             	sub    $0xc,%esp
  8011ed:	6a 0a                	push   $0xa
  8011ef:	e8 62 f7 ff ff       	call   800956 <cputchar>
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	eb e0                	jmp    8011d9 <readline+0xd0>

008011f9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8011ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801204:	eb 03                	jmp    801209 <strlen+0x10>
		n++;
  801206:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  801209:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80120d:	75 f7                	jne    801206 <strlen+0xd>
	return n;
}
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801217:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80121a:	b8 00 00 00 00       	mov    $0x0,%eax
  80121f:	eb 03                	jmp    801224 <strnlen+0x13>
		n++;
  801221:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801224:	39 d0                	cmp    %edx,%eax
  801226:	74 06                	je     80122e <strnlen+0x1d>
  801228:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80122c:	75 f3                	jne    801221 <strnlen+0x10>
	return n;
}
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    

00801230 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	53                   	push   %ebx
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80123a:	89 c2                	mov    %eax,%edx
  80123c:	83 c1 01             	add    $0x1,%ecx
  80123f:	83 c2 01             	add    $0x1,%edx
  801242:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801246:	88 5a ff             	mov    %bl,-0x1(%edx)
  801249:	84 db                	test   %bl,%bl
  80124b:	75 ef                	jne    80123c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80124d:	5b                   	pop    %ebx
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    

00801250 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	53                   	push   %ebx
  801254:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801257:	53                   	push   %ebx
  801258:	e8 9c ff ff ff       	call   8011f9 <strlen>
  80125d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801260:	ff 75 0c             	pushl  0xc(%ebp)
  801263:	01 d8                	add    %ebx,%eax
  801265:	50                   	push   %eax
  801266:	e8 c5 ff ff ff       	call   801230 <strcpy>
	return dst;
}
  80126b:	89 d8                	mov    %ebx,%eax
  80126d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	56                   	push   %esi
  801276:	53                   	push   %ebx
  801277:	8b 75 08             	mov    0x8(%ebp),%esi
  80127a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127d:	89 f3                	mov    %esi,%ebx
  80127f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801282:	89 f2                	mov    %esi,%edx
  801284:	eb 0f                	jmp    801295 <strncpy+0x23>
		*dst++ = *src;
  801286:	83 c2 01             	add    $0x1,%edx
  801289:	0f b6 01             	movzbl (%ecx),%eax
  80128c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80128f:	80 39 01             	cmpb   $0x1,(%ecx)
  801292:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801295:	39 da                	cmp    %ebx,%edx
  801297:	75 ed                	jne    801286 <strncpy+0x14>
	}
	return ret;
}
  801299:	89 f0                	mov    %esi,%eax
  80129b:	5b                   	pop    %ebx
  80129c:	5e                   	pop    %esi
  80129d:	5d                   	pop    %ebp
  80129e:	c3                   	ret    

0080129f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	56                   	push   %esi
  8012a3:	53                   	push   %ebx
  8012a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ad:	89 f0                	mov    %esi,%eax
  8012af:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8012b3:	85 c9                	test   %ecx,%ecx
  8012b5:	75 0b                	jne    8012c2 <strlcpy+0x23>
  8012b7:	eb 17                	jmp    8012d0 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8012b9:	83 c2 01             	add    $0x1,%edx
  8012bc:	83 c0 01             	add    $0x1,%eax
  8012bf:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8012c2:	39 d8                	cmp    %ebx,%eax
  8012c4:	74 07                	je     8012cd <strlcpy+0x2e>
  8012c6:	0f b6 0a             	movzbl (%edx),%ecx
  8012c9:	84 c9                	test   %cl,%cl
  8012cb:	75 ec                	jne    8012b9 <strlcpy+0x1a>
		*dst = '\0';
  8012cd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8012d0:	29 f0                	sub    %esi,%eax
}
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5d                   	pop    %ebp
  8012d5:	c3                   	ret    

008012d6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8012df:	eb 06                	jmp    8012e7 <strcmp+0x11>
		p++, q++;
  8012e1:	83 c1 01             	add    $0x1,%ecx
  8012e4:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8012e7:	0f b6 01             	movzbl (%ecx),%eax
  8012ea:	84 c0                	test   %al,%al
  8012ec:	74 04                	je     8012f2 <strcmp+0x1c>
  8012ee:	3a 02                	cmp    (%edx),%al
  8012f0:	74 ef                	je     8012e1 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012f2:	0f b6 c0             	movzbl %al,%eax
  8012f5:	0f b6 12             	movzbl (%edx),%edx
  8012f8:	29 d0                	sub    %edx,%eax
}
  8012fa:	5d                   	pop    %ebp
  8012fb:	c3                   	ret    

008012fc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	53                   	push   %ebx
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8b 55 0c             	mov    0xc(%ebp),%edx
  801306:	89 c3                	mov    %eax,%ebx
  801308:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80130b:	eb 06                	jmp    801313 <strncmp+0x17>
		n--, p++, q++;
  80130d:	83 c0 01             	add    $0x1,%eax
  801310:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801313:	39 d8                	cmp    %ebx,%eax
  801315:	74 16                	je     80132d <strncmp+0x31>
  801317:	0f b6 08             	movzbl (%eax),%ecx
  80131a:	84 c9                	test   %cl,%cl
  80131c:	74 04                	je     801322 <strncmp+0x26>
  80131e:	3a 0a                	cmp    (%edx),%cl
  801320:	74 eb                	je     80130d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801322:	0f b6 00             	movzbl (%eax),%eax
  801325:	0f b6 12             	movzbl (%edx),%edx
  801328:	29 d0                	sub    %edx,%eax
}
  80132a:	5b                   	pop    %ebx
  80132b:	5d                   	pop    %ebp
  80132c:	c3                   	ret    
		return 0;
  80132d:	b8 00 00 00 00       	mov    $0x0,%eax
  801332:	eb f6                	jmp    80132a <strncmp+0x2e>

00801334 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80133e:	0f b6 10             	movzbl (%eax),%edx
  801341:	84 d2                	test   %dl,%dl
  801343:	74 09                	je     80134e <strchr+0x1a>
		if (*s == c)
  801345:	38 ca                	cmp    %cl,%dl
  801347:	74 0a                	je     801353 <strchr+0x1f>
	for (; *s; s++)
  801349:	83 c0 01             	add    $0x1,%eax
  80134c:	eb f0                	jmp    80133e <strchr+0xa>
			return (char *) s;
	return 0;
  80134e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801353:	5d                   	pop    %ebp
  801354:	c3                   	ret    

00801355 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80135f:	eb 03                	jmp    801364 <strfind+0xf>
  801361:	83 c0 01             	add    $0x1,%eax
  801364:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801367:	38 ca                	cmp    %cl,%dl
  801369:	74 04                	je     80136f <strfind+0x1a>
  80136b:	84 d2                	test   %dl,%dl
  80136d:	75 f2                	jne    801361 <strfind+0xc>
			break;
	return (char *) s;
}
  80136f:	5d                   	pop    %ebp
  801370:	c3                   	ret    

00801371 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	57                   	push   %edi
  801375:	56                   	push   %esi
  801376:	53                   	push   %ebx
  801377:	8b 7d 08             	mov    0x8(%ebp),%edi
  80137a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80137d:	85 c9                	test   %ecx,%ecx
  80137f:	74 13                	je     801394 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801381:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801387:	75 05                	jne    80138e <memset+0x1d>
  801389:	f6 c1 03             	test   $0x3,%cl
  80138c:	74 0d                	je     80139b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80138e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801391:	fc                   	cld    
  801392:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801394:	89 f8                	mov    %edi,%eax
  801396:	5b                   	pop    %ebx
  801397:	5e                   	pop    %esi
  801398:	5f                   	pop    %edi
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    
		c &= 0xFF;
  80139b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80139f:	89 d3                	mov    %edx,%ebx
  8013a1:	c1 e3 08             	shl    $0x8,%ebx
  8013a4:	89 d0                	mov    %edx,%eax
  8013a6:	c1 e0 18             	shl    $0x18,%eax
  8013a9:	89 d6                	mov    %edx,%esi
  8013ab:	c1 e6 10             	shl    $0x10,%esi
  8013ae:	09 f0                	or     %esi,%eax
  8013b0:	09 c2                	or     %eax,%edx
  8013b2:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8013b4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8013b7:	89 d0                	mov    %edx,%eax
  8013b9:	fc                   	cld    
  8013ba:	f3 ab                	rep stos %eax,%es:(%edi)
  8013bc:	eb d6                	jmp    801394 <memset+0x23>

008013be <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	57                   	push   %edi
  8013c2:	56                   	push   %esi
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013cc:	39 c6                	cmp    %eax,%esi
  8013ce:	73 35                	jae    801405 <memmove+0x47>
  8013d0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8013d3:	39 c2                	cmp    %eax,%edx
  8013d5:	76 2e                	jbe    801405 <memmove+0x47>
		s += n;
		d += n;
  8013d7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013da:	89 d6                	mov    %edx,%esi
  8013dc:	09 fe                	or     %edi,%esi
  8013de:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8013e4:	74 0c                	je     8013f2 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013e6:	83 ef 01             	sub    $0x1,%edi
  8013e9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8013ec:	fd                   	std    
  8013ed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013ef:	fc                   	cld    
  8013f0:	eb 21                	jmp    801413 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8013f2:	f6 c1 03             	test   $0x3,%cl
  8013f5:	75 ef                	jne    8013e6 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013f7:	83 ef 04             	sub    $0x4,%edi
  8013fa:	8d 72 fc             	lea    -0x4(%edx),%esi
  8013fd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801400:	fd                   	std    
  801401:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801403:	eb ea                	jmp    8013ef <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801405:	89 f2                	mov    %esi,%edx
  801407:	09 c2                	or     %eax,%edx
  801409:	f6 c2 03             	test   $0x3,%dl
  80140c:	74 09                	je     801417 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80140e:	89 c7                	mov    %eax,%edi
  801410:	fc                   	cld    
  801411:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801413:	5e                   	pop    %esi
  801414:	5f                   	pop    %edi
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801417:	f6 c1 03             	test   $0x3,%cl
  80141a:	75 f2                	jne    80140e <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80141c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80141f:	89 c7                	mov    %eax,%edi
  801421:	fc                   	cld    
  801422:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801424:	eb ed                	jmp    801413 <memmove+0x55>

00801426 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801429:	ff 75 10             	pushl  0x10(%ebp)
  80142c:	ff 75 0c             	pushl  0xc(%ebp)
  80142f:	ff 75 08             	pushl  0x8(%ebp)
  801432:	e8 87 ff ff ff       	call   8013be <memmove>
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	56                   	push   %esi
  80143d:	53                   	push   %ebx
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	8b 55 0c             	mov    0xc(%ebp),%edx
  801444:	89 c6                	mov    %eax,%esi
  801446:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801449:	39 f0                	cmp    %esi,%eax
  80144b:	74 1c                	je     801469 <memcmp+0x30>
		if (*s1 != *s2)
  80144d:	0f b6 08             	movzbl (%eax),%ecx
  801450:	0f b6 1a             	movzbl (%edx),%ebx
  801453:	38 d9                	cmp    %bl,%cl
  801455:	75 08                	jne    80145f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801457:	83 c0 01             	add    $0x1,%eax
  80145a:	83 c2 01             	add    $0x1,%edx
  80145d:	eb ea                	jmp    801449 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80145f:	0f b6 c1             	movzbl %cl,%eax
  801462:	0f b6 db             	movzbl %bl,%ebx
  801465:	29 d8                	sub    %ebx,%eax
  801467:	eb 05                	jmp    80146e <memcmp+0x35>
	}

	return 0;
  801469:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146e:	5b                   	pop    %ebx
  80146f:	5e                   	pop    %esi
  801470:	5d                   	pop    %ebp
  801471:	c3                   	ret    

00801472 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80147b:	89 c2                	mov    %eax,%edx
  80147d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801480:	39 d0                	cmp    %edx,%eax
  801482:	73 09                	jae    80148d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  801484:	38 08                	cmp    %cl,(%eax)
  801486:	74 05                	je     80148d <memfind+0x1b>
	for (; s < ends; s++)
  801488:	83 c0 01             	add    $0x1,%eax
  80148b:	eb f3                	jmp    801480 <memfind+0xe>
			break;
	return (void *) s;
}
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    

0080148f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	57                   	push   %edi
  801493:	56                   	push   %esi
  801494:	53                   	push   %ebx
  801495:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801498:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80149b:	eb 03                	jmp    8014a0 <strtol+0x11>
		s++;
  80149d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8014a0:	0f b6 01             	movzbl (%ecx),%eax
  8014a3:	3c 20                	cmp    $0x20,%al
  8014a5:	74 f6                	je     80149d <strtol+0xe>
  8014a7:	3c 09                	cmp    $0x9,%al
  8014a9:	74 f2                	je     80149d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8014ab:	3c 2b                	cmp    $0x2b,%al
  8014ad:	74 2e                	je     8014dd <strtol+0x4e>
	int neg = 0;
  8014af:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8014b4:	3c 2d                	cmp    $0x2d,%al
  8014b6:	74 2f                	je     8014e7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014b8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8014be:	75 05                	jne    8014c5 <strtol+0x36>
  8014c0:	80 39 30             	cmpb   $0x30,(%ecx)
  8014c3:	74 2c                	je     8014f1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8014c5:	85 db                	test   %ebx,%ebx
  8014c7:	75 0a                	jne    8014d3 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8014c9:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8014ce:	80 39 30             	cmpb   $0x30,(%ecx)
  8014d1:	74 28                	je     8014fb <strtol+0x6c>
		base = 10;
  8014d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8014db:	eb 50                	jmp    80152d <strtol+0x9e>
		s++;
  8014dd:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8014e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8014e5:	eb d1                	jmp    8014b8 <strtol+0x29>
		s++, neg = 1;
  8014e7:	83 c1 01             	add    $0x1,%ecx
  8014ea:	bf 01 00 00 00       	mov    $0x1,%edi
  8014ef:	eb c7                	jmp    8014b8 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014f1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8014f5:	74 0e                	je     801505 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8014f7:	85 db                	test   %ebx,%ebx
  8014f9:	75 d8                	jne    8014d3 <strtol+0x44>
		s++, base = 8;
  8014fb:	83 c1 01             	add    $0x1,%ecx
  8014fe:	bb 08 00 00 00       	mov    $0x8,%ebx
  801503:	eb ce                	jmp    8014d3 <strtol+0x44>
		s += 2, base = 16;
  801505:	83 c1 02             	add    $0x2,%ecx
  801508:	bb 10 00 00 00       	mov    $0x10,%ebx
  80150d:	eb c4                	jmp    8014d3 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80150f:	8d 72 9f             	lea    -0x61(%edx),%esi
  801512:	89 f3                	mov    %esi,%ebx
  801514:	80 fb 19             	cmp    $0x19,%bl
  801517:	77 29                	ja     801542 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801519:	0f be d2             	movsbl %dl,%edx
  80151c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80151f:	3b 55 10             	cmp    0x10(%ebp),%edx
  801522:	7d 30                	jge    801554 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801524:	83 c1 01             	add    $0x1,%ecx
  801527:	0f af 45 10          	imul   0x10(%ebp),%eax
  80152b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80152d:	0f b6 11             	movzbl (%ecx),%edx
  801530:	8d 72 d0             	lea    -0x30(%edx),%esi
  801533:	89 f3                	mov    %esi,%ebx
  801535:	80 fb 09             	cmp    $0x9,%bl
  801538:	77 d5                	ja     80150f <strtol+0x80>
			dig = *s - '0';
  80153a:	0f be d2             	movsbl %dl,%edx
  80153d:	83 ea 30             	sub    $0x30,%edx
  801540:	eb dd                	jmp    80151f <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801542:	8d 72 bf             	lea    -0x41(%edx),%esi
  801545:	89 f3                	mov    %esi,%ebx
  801547:	80 fb 19             	cmp    $0x19,%bl
  80154a:	77 08                	ja     801554 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80154c:	0f be d2             	movsbl %dl,%edx
  80154f:	83 ea 37             	sub    $0x37,%edx
  801552:	eb cb                	jmp    80151f <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801554:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801558:	74 05                	je     80155f <strtol+0xd0>
		*endptr = (char *) s;
  80155a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80155d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80155f:	89 c2                	mov    %eax,%edx
  801561:	f7 da                	neg    %edx
  801563:	85 ff                	test   %edi,%edi
  801565:	0f 45 c2             	cmovne %edx,%eax
}
  801568:	5b                   	pop    %ebx
  801569:	5e                   	pop    %esi
  80156a:	5f                   	pop    %edi
  80156b:	5d                   	pop    %ebp
  80156c:	c3                   	ret    

0080156d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	57                   	push   %edi
  801571:	56                   	push   %esi
  801572:	53                   	push   %ebx
	asm volatile("int %1\n"
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
  801578:	8b 55 08             	mov    0x8(%ebp),%edx
  80157b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80157e:	89 c3                	mov    %eax,%ebx
  801580:	89 c7                	mov    %eax,%edi
  801582:	89 c6                	mov    %eax,%esi
  801584:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801586:	5b                   	pop    %ebx
  801587:	5e                   	pop    %esi
  801588:	5f                   	pop    %edi
  801589:	5d                   	pop    %ebp
  80158a:	c3                   	ret    

0080158b <sys_cgetc>:

int
sys_cgetc(void)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	57                   	push   %edi
  80158f:	56                   	push   %esi
  801590:	53                   	push   %ebx
	asm volatile("int %1\n"
  801591:	ba 00 00 00 00       	mov    $0x0,%edx
  801596:	b8 01 00 00 00       	mov    $0x1,%eax
  80159b:	89 d1                	mov    %edx,%ecx
  80159d:	89 d3                	mov    %edx,%ebx
  80159f:	89 d7                	mov    %edx,%edi
  8015a1:	89 d6                	mov    %edx,%esi
  8015a3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8015a5:	5b                   	pop    %ebx
  8015a6:	5e                   	pop    %esi
  8015a7:	5f                   	pop    %edi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	57                   	push   %edi
  8015ae:	56                   	push   %esi
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bb:	b8 03 00 00 00       	mov    $0x3,%eax
  8015c0:	89 cb                	mov    %ecx,%ebx
  8015c2:	89 cf                	mov    %ecx,%edi
  8015c4:	89 ce                	mov    %ecx,%esi
  8015c6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	7f 08                	jg     8015d4 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8015cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015cf:	5b                   	pop    %ebx
  8015d0:	5e                   	pop    %esi
  8015d1:	5f                   	pop    %edi
  8015d2:	5d                   	pop    %ebp
  8015d3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8015d4:	83 ec 0c             	sub    $0xc,%esp
  8015d7:	50                   	push   %eax
  8015d8:	6a 03                	push   $0x3
  8015da:	68 2f 37 80 00       	push   $0x80372f
  8015df:	6a 23                	push   $0x23
  8015e1:	68 4c 37 80 00       	push   $0x80374c
  8015e6:	e8 90 f4 ff ff       	call   800a7b <_panic>

008015eb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	57                   	push   %edi
  8015ef:	56                   	push   %esi
  8015f0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f6:	b8 02 00 00 00       	mov    $0x2,%eax
  8015fb:	89 d1                	mov    %edx,%ecx
  8015fd:	89 d3                	mov    %edx,%ebx
  8015ff:	89 d7                	mov    %edx,%edi
  801601:	89 d6                	mov    %edx,%esi
  801603:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801605:	5b                   	pop    %ebx
  801606:	5e                   	pop    %esi
  801607:	5f                   	pop    %edi
  801608:	5d                   	pop    %ebp
  801609:	c3                   	ret    

0080160a <sys_yield>:

void
sys_yield(void)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	57                   	push   %edi
  80160e:	56                   	push   %esi
  80160f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801610:	ba 00 00 00 00       	mov    $0x0,%edx
  801615:	b8 0b 00 00 00       	mov    $0xb,%eax
  80161a:	89 d1                	mov    %edx,%ecx
  80161c:	89 d3                	mov    %edx,%ebx
  80161e:	89 d7                	mov    %edx,%edi
  801620:	89 d6                	mov    %edx,%esi
  801622:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801624:	5b                   	pop    %ebx
  801625:	5e                   	pop    %esi
  801626:	5f                   	pop    %edi
  801627:	5d                   	pop    %ebp
  801628:	c3                   	ret    

00801629 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	57                   	push   %edi
  80162d:	56                   	push   %esi
  80162e:	53                   	push   %ebx
  80162f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801632:	be 00 00 00 00       	mov    $0x0,%esi
  801637:	8b 55 08             	mov    0x8(%ebp),%edx
  80163a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80163d:	b8 04 00 00 00       	mov    $0x4,%eax
  801642:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801645:	89 f7                	mov    %esi,%edi
  801647:	cd 30                	int    $0x30
	if(check && ret > 0)
  801649:	85 c0                	test   %eax,%eax
  80164b:	7f 08                	jg     801655 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80164d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801650:	5b                   	pop    %ebx
  801651:	5e                   	pop    %esi
  801652:	5f                   	pop    %edi
  801653:	5d                   	pop    %ebp
  801654:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801655:	83 ec 0c             	sub    $0xc,%esp
  801658:	50                   	push   %eax
  801659:	6a 04                	push   $0x4
  80165b:	68 2f 37 80 00       	push   $0x80372f
  801660:	6a 23                	push   $0x23
  801662:	68 4c 37 80 00       	push   $0x80374c
  801667:	e8 0f f4 ff ff       	call   800a7b <_panic>

0080166c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	57                   	push   %edi
  801670:	56                   	push   %esi
  801671:	53                   	push   %ebx
  801672:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801675:	8b 55 08             	mov    0x8(%ebp),%edx
  801678:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80167b:	b8 05 00 00 00       	mov    $0x5,%eax
  801680:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801683:	8b 7d 14             	mov    0x14(%ebp),%edi
  801686:	8b 75 18             	mov    0x18(%ebp),%esi
  801689:	cd 30                	int    $0x30
	if(check && ret > 0)
  80168b:	85 c0                	test   %eax,%eax
  80168d:	7f 08                	jg     801697 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80168f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801692:	5b                   	pop    %ebx
  801693:	5e                   	pop    %esi
  801694:	5f                   	pop    %edi
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801697:	83 ec 0c             	sub    $0xc,%esp
  80169a:	50                   	push   %eax
  80169b:	6a 05                	push   $0x5
  80169d:	68 2f 37 80 00       	push   $0x80372f
  8016a2:	6a 23                	push   $0x23
  8016a4:	68 4c 37 80 00       	push   $0x80374c
  8016a9:	e8 cd f3 ff ff       	call   800a7b <_panic>

008016ae <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	57                   	push   %edi
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016c2:	b8 06 00 00 00       	mov    $0x6,%eax
  8016c7:	89 df                	mov    %ebx,%edi
  8016c9:	89 de                	mov    %ebx,%esi
  8016cb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	7f 08                	jg     8016d9 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8016d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d4:	5b                   	pop    %ebx
  8016d5:	5e                   	pop    %esi
  8016d6:	5f                   	pop    %edi
  8016d7:	5d                   	pop    %ebp
  8016d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016d9:	83 ec 0c             	sub    $0xc,%esp
  8016dc:	50                   	push   %eax
  8016dd:	6a 06                	push   $0x6
  8016df:	68 2f 37 80 00       	push   $0x80372f
  8016e4:	6a 23                	push   $0x23
  8016e6:	68 4c 37 80 00       	push   $0x80374c
  8016eb:	e8 8b f3 ff ff       	call   800a7b <_panic>

008016f0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	57                   	push   %edi
  8016f4:	56                   	push   %esi
  8016f5:	53                   	push   %ebx
  8016f6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801701:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801704:	b8 08 00 00 00       	mov    $0x8,%eax
  801709:	89 df                	mov    %ebx,%edi
  80170b:	89 de                	mov    %ebx,%esi
  80170d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80170f:	85 c0                	test   %eax,%eax
  801711:	7f 08                	jg     80171b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801713:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801716:	5b                   	pop    %ebx
  801717:	5e                   	pop    %esi
  801718:	5f                   	pop    %edi
  801719:	5d                   	pop    %ebp
  80171a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80171b:	83 ec 0c             	sub    $0xc,%esp
  80171e:	50                   	push   %eax
  80171f:	6a 08                	push   $0x8
  801721:	68 2f 37 80 00       	push   $0x80372f
  801726:	6a 23                	push   $0x23
  801728:	68 4c 37 80 00       	push   $0x80374c
  80172d:	e8 49 f3 ff ff       	call   800a7b <_panic>

00801732 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	57                   	push   %edi
  801736:	56                   	push   %esi
  801737:	53                   	push   %ebx
  801738:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80173b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801740:	8b 55 08             	mov    0x8(%ebp),%edx
  801743:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801746:	b8 09 00 00 00       	mov    $0x9,%eax
  80174b:	89 df                	mov    %ebx,%edi
  80174d:	89 de                	mov    %ebx,%esi
  80174f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801751:	85 c0                	test   %eax,%eax
  801753:	7f 08                	jg     80175d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801755:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801758:	5b                   	pop    %ebx
  801759:	5e                   	pop    %esi
  80175a:	5f                   	pop    %edi
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80175d:	83 ec 0c             	sub    $0xc,%esp
  801760:	50                   	push   %eax
  801761:	6a 09                	push   $0x9
  801763:	68 2f 37 80 00       	push   $0x80372f
  801768:	6a 23                	push   $0x23
  80176a:	68 4c 37 80 00       	push   $0x80374c
  80176f:	e8 07 f3 ff ff       	call   800a7b <_panic>

00801774 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	57                   	push   %edi
  801778:	56                   	push   %esi
  801779:	53                   	push   %ebx
  80177a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80177d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801782:	8b 55 08             	mov    0x8(%ebp),%edx
  801785:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801788:	b8 0a 00 00 00       	mov    $0xa,%eax
  80178d:	89 df                	mov    %ebx,%edi
  80178f:	89 de                	mov    %ebx,%esi
  801791:	cd 30                	int    $0x30
	if(check && ret > 0)
  801793:	85 c0                	test   %eax,%eax
  801795:	7f 08                	jg     80179f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801797:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179a:	5b                   	pop    %ebx
  80179b:	5e                   	pop    %esi
  80179c:	5f                   	pop    %edi
  80179d:	5d                   	pop    %ebp
  80179e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80179f:	83 ec 0c             	sub    $0xc,%esp
  8017a2:	50                   	push   %eax
  8017a3:	6a 0a                	push   $0xa
  8017a5:	68 2f 37 80 00       	push   $0x80372f
  8017aa:	6a 23                	push   $0x23
  8017ac:	68 4c 37 80 00       	push   $0x80374c
  8017b1:	e8 c5 f2 ff ff       	call   800a7b <_panic>

008017b6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	57                   	push   %edi
  8017ba:	56                   	push   %esi
  8017bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8017bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8017bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c2:	b8 0c 00 00 00       	mov    $0xc,%eax
  8017c7:	be 00 00 00 00       	mov    $0x0,%esi
  8017cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017cf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8017d2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8017d4:	5b                   	pop    %ebx
  8017d5:	5e                   	pop    %esi
  8017d6:	5f                   	pop    %edi
  8017d7:	5d                   	pop    %ebp
  8017d8:	c3                   	ret    

008017d9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	57                   	push   %edi
  8017dd:	56                   	push   %esi
  8017de:	53                   	push   %ebx
  8017df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ea:	b8 0d 00 00 00       	mov    $0xd,%eax
  8017ef:	89 cb                	mov    %ecx,%ebx
  8017f1:	89 cf                	mov    %ecx,%edi
  8017f3:	89 ce                	mov    %ecx,%esi
  8017f5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	7f 08                	jg     801803 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8017fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017fe:	5b                   	pop    %ebx
  8017ff:	5e                   	pop    %esi
  801800:	5f                   	pop    %edi
  801801:	5d                   	pop    %ebp
  801802:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801803:	83 ec 0c             	sub    $0xc,%esp
  801806:	50                   	push   %eax
  801807:	6a 0d                	push   $0xd
  801809:	68 2f 37 80 00       	push   $0x80372f
  80180e:	6a 23                	push   $0x23
  801810:	68 4c 37 80 00       	push   $0x80374c
  801815:	e8 61 f2 ff ff       	call   800a7b <_panic>

0080181a <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  801820:	68 5a 37 80 00       	push   $0x80375a
  801825:	6a 25                	push   $0x25
  801827:	68 72 37 80 00       	push   $0x803772
  80182c:	e8 4a f2 ff ff       	call   800a7b <_panic>

00801831 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	57                   	push   %edi
  801835:	56                   	push   %esi
  801836:	53                   	push   %ebx
  801837:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  80183a:	68 1a 18 80 00       	push   $0x80181a
  80183f:	e8 1b 16 00 00       	call   802e5f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801844:	b8 07 00 00 00       	mov    $0x7,%eax
  801849:	cd 30                	int    $0x30
  80184b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80184e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  801851:	83 c4 10             	add    $0x10,%esp
  801854:	85 c0                	test   %eax,%eax
  801856:	78 27                	js     80187f <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  801858:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  80185d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801861:	75 65                	jne    8018c8 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  801863:	e8 83 fd ff ff       	call   8015eb <sys_getenvid>
  801868:	25 ff 03 00 00       	and    $0x3ff,%eax
  80186d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801870:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801875:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  80187a:	e9 11 01 00 00       	jmp    801990 <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  80187f:	50                   	push   %eax
  801880:	68 65 32 80 00       	push   $0x803265
  801885:	6a 6f                	push   $0x6f
  801887:	68 72 37 80 00       	push   $0x803772
  80188c:	e8 ea f1 ff ff       	call   800a7b <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  801891:	e8 55 fd ff ff       	call   8015eb <sys_getenvid>
  801896:	83 ec 0c             	sub    $0xc,%esp
  801899:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  80189f:	56                   	push   %esi
  8018a0:	57                   	push   %edi
  8018a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018a4:	57                   	push   %edi
  8018a5:	50                   	push   %eax
  8018a6:	e8 c1 fd ff ff       	call   80166c <sys_page_map>
  8018ab:	83 c4 20             	add    $0x20,%esp
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	0f 88 84 00 00 00    	js     80193a <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  8018b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8018bc:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8018c2:	0f 84 84 00 00 00    	je     80194c <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  8018c8:	89 d8                	mov    %ebx,%eax
  8018ca:	c1 e8 16             	shr    $0x16,%eax
  8018cd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018d4:	a8 01                	test   $0x1,%al
  8018d6:	74 de                	je     8018b6 <fork+0x85>
  8018d8:	89 d8                	mov    %ebx,%eax
  8018da:	c1 e8 0c             	shr    $0xc,%eax
  8018dd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018e4:	f6 c2 01             	test   $0x1,%dl
  8018e7:	74 cd                	je     8018b6 <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  8018e9:	89 c7                	mov    %eax,%edi
  8018eb:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  8018ee:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  8018f5:	f7 c6 00 04 00 00    	test   $0x400,%esi
  8018fb:	75 94                	jne    801891 <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  8018fd:	f7 c6 02 08 00 00    	test   $0x802,%esi
  801903:	0f 85 d1 00 00 00    	jne    8019da <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  801909:	a1 24 54 80 00       	mov    0x805424,%eax
  80190e:	8b 40 48             	mov    0x48(%eax),%eax
  801911:	83 ec 0c             	sub    $0xc,%esp
  801914:	6a 05                	push   $0x5
  801916:	57                   	push   %edi
  801917:	ff 75 e4             	pushl  -0x1c(%ebp)
  80191a:	57                   	push   %edi
  80191b:	50                   	push   %eax
  80191c:	e8 4b fd ff ff       	call   80166c <sys_page_map>
  801921:	83 c4 20             	add    $0x20,%esp
  801924:	85 c0                	test   %eax,%eax
  801926:	79 8e                	jns    8018b6 <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  801928:	50                   	push   %eax
  801929:	68 cc 37 80 00       	push   $0x8037cc
  80192e:	6a 4a                	push   $0x4a
  801930:	68 72 37 80 00       	push   $0x803772
  801935:	e8 41 f1 ff ff       	call   800a7b <_panic>
                        panic("duppage: page mapping failed %e", r);
  80193a:	50                   	push   %eax
  80193b:	68 ac 37 80 00       	push   $0x8037ac
  801940:	6a 41                	push   $0x41
  801942:	68 72 37 80 00       	push   $0x803772
  801947:	e8 2f f1 ff ff       	call   800a7b <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  80194c:	83 ec 04             	sub    $0x4,%esp
  80194f:	6a 07                	push   $0x7
  801951:	68 00 f0 bf ee       	push   $0xeebff000
  801956:	ff 75 e0             	pushl  -0x20(%ebp)
  801959:	e8 cb fc ff ff       	call   801629 <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  80195e:	83 c4 10             	add    $0x10,%esp
  801961:	85 c0                	test   %eax,%eax
  801963:	78 36                	js     80199b <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801965:	83 ec 08             	sub    $0x8,%esp
  801968:	68 d3 2e 80 00       	push   $0x802ed3
  80196d:	ff 75 e0             	pushl  -0x20(%ebp)
  801970:	e8 ff fd ff ff       	call   801774 <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	85 c0                	test   %eax,%eax
  80197a:	78 34                	js     8019b0 <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  80197c:	83 ec 08             	sub    $0x8,%esp
  80197f:	6a 02                	push   $0x2
  801981:	ff 75 e0             	pushl  -0x20(%ebp)
  801984:	e8 67 fd ff ff       	call   8016f0 <sys_env_set_status>
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	85 c0                	test   %eax,%eax
  80198e:	78 35                	js     8019c5 <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  801990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801993:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801996:	5b                   	pop    %ebx
  801997:	5e                   	pop    %esi
  801998:	5f                   	pop    %edi
  801999:	5d                   	pop    %ebp
  80199a:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  80199b:	50                   	push   %eax
  80199c:	68 65 32 80 00       	push   $0x803265
  8019a1:	68 82 00 00 00       	push   $0x82
  8019a6:	68 72 37 80 00       	push   $0x803772
  8019ab:	e8 cb f0 ff ff       	call   800a7b <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  8019b0:	50                   	push   %eax
  8019b1:	68 f0 37 80 00       	push   $0x8037f0
  8019b6:	68 87 00 00 00       	push   $0x87
  8019bb:	68 72 37 80 00       	push   $0x803772
  8019c0:	e8 b6 f0 ff ff       	call   800a7b <_panic>
        	panic("sys_env_set_status: %e", r);
  8019c5:	50                   	push   %eax
  8019c6:	68 7d 37 80 00       	push   $0x80377d
  8019cb:	68 8b 00 00 00       	push   $0x8b
  8019d0:	68 72 37 80 00       	push   $0x803772
  8019d5:	e8 a1 f0 ff ff       	call   800a7b <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  8019da:	a1 24 54 80 00       	mov    0x805424,%eax
  8019df:	8b 40 48             	mov    0x48(%eax),%eax
  8019e2:	83 ec 0c             	sub    $0xc,%esp
  8019e5:	68 05 08 00 00       	push   $0x805
  8019ea:	57                   	push   %edi
  8019eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019ee:	57                   	push   %edi
  8019ef:	50                   	push   %eax
  8019f0:	e8 77 fc ff ff       	call   80166c <sys_page_map>
  8019f5:	83 c4 20             	add    $0x20,%esp
  8019f8:	85 c0                	test   %eax,%eax
  8019fa:	0f 88 28 ff ff ff    	js     801928 <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  801a00:	a1 24 54 80 00       	mov    0x805424,%eax
  801a05:	8b 50 48             	mov    0x48(%eax),%edx
  801a08:	8b 40 48             	mov    0x48(%eax),%eax
  801a0b:	83 ec 0c             	sub    $0xc,%esp
  801a0e:	68 05 08 00 00       	push   $0x805
  801a13:	57                   	push   %edi
  801a14:	52                   	push   %edx
  801a15:	57                   	push   %edi
  801a16:	50                   	push   %eax
  801a17:	e8 50 fc ff ff       	call   80166c <sys_page_map>
  801a1c:	83 c4 20             	add    $0x20,%esp
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	0f 89 8f fe ff ff    	jns    8018b6 <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  801a27:	50                   	push   %eax
  801a28:	68 cc 37 80 00       	push   $0x8037cc
  801a2d:	6a 4f                	push   $0x4f
  801a2f:	68 72 37 80 00       	push   $0x803772
  801a34:	e8 42 f0 ff ff       	call   800a7b <_panic>

00801a39 <sfork>:

// Challenge!
int
sfork(void)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801a3f:	68 94 37 80 00       	push   $0x803794
  801a44:	68 94 00 00 00       	push   $0x94
  801a49:	68 72 37 80 00       	push   $0x803772
  801a4e:	e8 28 f0 ff ff       	call   800a7b <_panic>

00801a53 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	8b 55 08             	mov    0x8(%ebp),%edx
  801a59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a5c:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801a5f:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801a61:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801a64:	83 3a 01             	cmpl   $0x1,(%edx)
  801a67:	7e 09                	jle    801a72 <argstart+0x1f>
  801a69:	ba 01 32 80 00       	mov    $0x803201,%edx
  801a6e:	85 c9                	test   %ecx,%ecx
  801a70:	75 05                	jne    801a77 <argstart+0x24>
  801a72:	ba 00 00 00 00       	mov    $0x0,%edx
  801a77:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801a7a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <argnext>:

int
argnext(struct Argstate *args)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	53                   	push   %ebx
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801a8d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801a94:	8b 43 08             	mov    0x8(%ebx),%eax
  801a97:	85 c0                	test   %eax,%eax
  801a99:	74 72                	je     801b0d <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  801a9b:	80 38 00             	cmpb   $0x0,(%eax)
  801a9e:	75 48                	jne    801ae8 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801aa0:	8b 0b                	mov    (%ebx),%ecx
  801aa2:	83 39 01             	cmpl   $0x1,(%ecx)
  801aa5:	74 58                	je     801aff <argnext+0x7c>
		    || args->argv[1][0] != '-'
  801aa7:	8b 53 04             	mov    0x4(%ebx),%edx
  801aaa:	8b 42 04             	mov    0x4(%edx),%eax
  801aad:	80 38 2d             	cmpb   $0x2d,(%eax)
  801ab0:	75 4d                	jne    801aff <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  801ab2:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801ab6:	74 47                	je     801aff <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801ab8:	83 c0 01             	add    $0x1,%eax
  801abb:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	8b 01                	mov    (%ecx),%eax
  801ac3:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801aca:	50                   	push   %eax
  801acb:	8d 42 08             	lea    0x8(%edx),%eax
  801ace:	50                   	push   %eax
  801acf:	83 c2 04             	add    $0x4,%edx
  801ad2:	52                   	push   %edx
  801ad3:	e8 e6 f8 ff ff       	call   8013be <memmove>
		(*args->argc)--;
  801ad8:	8b 03                	mov    (%ebx),%eax
  801ada:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801add:	8b 43 08             	mov    0x8(%ebx),%eax
  801ae0:	83 c4 10             	add    $0x10,%esp
  801ae3:	80 38 2d             	cmpb   $0x2d,(%eax)
  801ae6:	74 11                	je     801af9 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801ae8:	8b 53 08             	mov    0x8(%ebx),%edx
  801aeb:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801aee:	83 c2 01             	add    $0x1,%edx
  801af1:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801af4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801af9:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801afd:	75 e9                	jne    801ae8 <argnext+0x65>
	args->curarg = 0;
  801aff:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801b0b:	eb e7                	jmp    801af4 <argnext+0x71>
		return -1;
  801b0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801b12:	eb e0                	jmp    801af4 <argnext+0x71>

00801b14 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	53                   	push   %ebx
  801b18:	83 ec 04             	sub    $0x4,%esp
  801b1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801b1e:	8b 43 08             	mov    0x8(%ebx),%eax
  801b21:	85 c0                	test   %eax,%eax
  801b23:	74 5b                	je     801b80 <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  801b25:	80 38 00             	cmpb   $0x0,(%eax)
  801b28:	74 12                	je     801b3c <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801b2a:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801b2d:	c7 43 08 01 32 80 00 	movl   $0x803201,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801b34:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801b37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    
	} else if (*args->argc > 1) {
  801b3c:	8b 13                	mov    (%ebx),%edx
  801b3e:	83 3a 01             	cmpl   $0x1,(%edx)
  801b41:	7f 10                	jg     801b53 <argnextvalue+0x3f>
		args->argvalue = 0;
  801b43:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801b4a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801b51:	eb e1                	jmp    801b34 <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  801b53:	8b 43 04             	mov    0x4(%ebx),%eax
  801b56:	8b 48 04             	mov    0x4(%eax),%ecx
  801b59:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801b5c:	83 ec 04             	sub    $0x4,%esp
  801b5f:	8b 12                	mov    (%edx),%edx
  801b61:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801b68:	52                   	push   %edx
  801b69:	8d 50 08             	lea    0x8(%eax),%edx
  801b6c:	52                   	push   %edx
  801b6d:	83 c0 04             	add    $0x4,%eax
  801b70:	50                   	push   %eax
  801b71:	e8 48 f8 ff ff       	call   8013be <memmove>
		(*args->argc)--;
  801b76:	8b 03                	mov    (%ebx),%eax
  801b78:	83 28 01             	subl   $0x1,(%eax)
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	eb b4                	jmp    801b34 <argnextvalue+0x20>
		return 0;
  801b80:	b8 00 00 00 00       	mov    $0x0,%eax
  801b85:	eb b0                	jmp    801b37 <argnextvalue+0x23>

00801b87 <argvalue>:
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	83 ec 08             	sub    $0x8,%esp
  801b8d:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801b90:	8b 42 0c             	mov    0xc(%edx),%eax
  801b93:	85 c0                	test   %eax,%eax
  801b95:	74 02                	je     801b99 <argvalue+0x12>
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801b99:	83 ec 0c             	sub    $0xc,%esp
  801b9c:	52                   	push   %edx
  801b9d:	e8 72 ff ff ff       	call   801b14 <argnextvalue>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	eb f0                	jmp    801b97 <argvalue+0x10>

00801ba7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	05 00 00 00 30       	add    $0x30000000,%eax
  801bb2:	c1 e8 0c             	shr    $0xc,%eax
}
  801bb5:	5d                   	pop    %ebp
  801bb6:	c3                   	ret    

00801bb7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801bc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bc7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801bcc:	5d                   	pop    %ebp
  801bcd:	c3                   	ret    

00801bce <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bd4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801bd9:	89 c2                	mov    %eax,%edx
  801bdb:	c1 ea 16             	shr    $0x16,%edx
  801bde:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801be5:	f6 c2 01             	test   $0x1,%dl
  801be8:	74 2a                	je     801c14 <fd_alloc+0x46>
  801bea:	89 c2                	mov    %eax,%edx
  801bec:	c1 ea 0c             	shr    $0xc,%edx
  801bef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801bf6:	f6 c2 01             	test   $0x1,%dl
  801bf9:	74 19                	je     801c14 <fd_alloc+0x46>
  801bfb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801c00:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801c05:	75 d2                	jne    801bd9 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c07:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801c0d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801c12:	eb 07                	jmp    801c1b <fd_alloc+0x4d>
			*fd_store = fd;
  801c14:	89 01                	mov    %eax,(%ecx)
			return 0;
  801c16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    

00801c1d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c23:	83 f8 1f             	cmp    $0x1f,%eax
  801c26:	77 36                	ja     801c5e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801c28:	c1 e0 0c             	shl    $0xc,%eax
  801c2b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c30:	89 c2                	mov    %eax,%edx
  801c32:	c1 ea 16             	shr    $0x16,%edx
  801c35:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801c3c:	f6 c2 01             	test   $0x1,%dl
  801c3f:	74 24                	je     801c65 <fd_lookup+0x48>
  801c41:	89 c2                	mov    %eax,%edx
  801c43:	c1 ea 0c             	shr    $0xc,%edx
  801c46:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c4d:	f6 c2 01             	test   $0x1,%dl
  801c50:	74 1a                	je     801c6c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c55:	89 02                	mov    %eax,(%edx)
	return 0;
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5c:	5d                   	pop    %ebp
  801c5d:	c3                   	ret    
		return -E_INVAL;
  801c5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c63:	eb f7                	jmp    801c5c <fd_lookup+0x3f>
		return -E_INVAL;
  801c65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c6a:	eb f0                	jmp    801c5c <fd_lookup+0x3f>
  801c6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c71:	eb e9                	jmp    801c5c <fd_lookup+0x3f>

00801c73 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 08             	sub    $0x8,%esp
  801c79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c7c:	ba 90 38 80 00       	mov    $0x803890,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801c81:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801c86:	39 08                	cmp    %ecx,(%eax)
  801c88:	74 33                	je     801cbd <dev_lookup+0x4a>
  801c8a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801c8d:	8b 02                	mov    (%edx),%eax
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	75 f3                	jne    801c86 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c93:	a1 24 54 80 00       	mov    0x805424,%eax
  801c98:	8b 40 48             	mov    0x48(%eax),%eax
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	51                   	push   %ecx
  801c9f:	50                   	push   %eax
  801ca0:	68 14 38 80 00       	push   $0x803814
  801ca5:	e8 ac ee ff ff       	call   800b56 <cprintf>
	*dev = 0;
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801cb3:	83 c4 10             	add    $0x10,%esp
  801cb6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    
			*dev = devtab[i];
  801cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc0:	89 01                	mov    %eax,(%ecx)
			return 0;
  801cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc7:	eb f2                	jmp    801cbb <dev_lookup+0x48>

00801cc9 <fd_close>:
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	57                   	push   %edi
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 1c             	sub    $0x1c,%esp
  801cd2:	8b 75 08             	mov    0x8(%ebp),%esi
  801cd5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cd8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801cdb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cdc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801ce2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ce5:	50                   	push   %eax
  801ce6:	e8 32 ff ff ff       	call   801c1d <fd_lookup>
  801ceb:	89 c3                	mov    %eax,%ebx
  801ced:	83 c4 08             	add    $0x8,%esp
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	78 05                	js     801cf9 <fd_close+0x30>
	    || fd != fd2)
  801cf4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801cf7:	74 16                	je     801d0f <fd_close+0x46>
		return (must_exist ? r : 0);
  801cf9:	89 f8                	mov    %edi,%eax
  801cfb:	84 c0                	test   %al,%al
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801d02:	0f 44 d8             	cmove  %eax,%ebx
}
  801d05:	89 d8                	mov    %ebx,%eax
  801d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d0a:	5b                   	pop    %ebx
  801d0b:	5e                   	pop    %esi
  801d0c:	5f                   	pop    %edi
  801d0d:	5d                   	pop    %ebp
  801d0e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d0f:	83 ec 08             	sub    $0x8,%esp
  801d12:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d15:	50                   	push   %eax
  801d16:	ff 36                	pushl  (%esi)
  801d18:	e8 56 ff ff ff       	call   801c73 <dev_lookup>
  801d1d:	89 c3                	mov    %eax,%ebx
  801d1f:	83 c4 10             	add    $0x10,%esp
  801d22:	85 c0                	test   %eax,%eax
  801d24:	78 15                	js     801d3b <fd_close+0x72>
		if (dev->dev_close)
  801d26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d29:	8b 40 10             	mov    0x10(%eax),%eax
  801d2c:	85 c0                	test   %eax,%eax
  801d2e:	74 1b                	je     801d4b <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801d30:	83 ec 0c             	sub    $0xc,%esp
  801d33:	56                   	push   %esi
  801d34:	ff d0                	call   *%eax
  801d36:	89 c3                	mov    %eax,%ebx
  801d38:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801d3b:	83 ec 08             	sub    $0x8,%esp
  801d3e:	56                   	push   %esi
  801d3f:	6a 00                	push   $0x0
  801d41:	e8 68 f9 ff ff       	call   8016ae <sys_page_unmap>
	return r;
  801d46:	83 c4 10             	add    $0x10,%esp
  801d49:	eb ba                	jmp    801d05 <fd_close+0x3c>
			r = 0;
  801d4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d50:	eb e9                	jmp    801d3b <fd_close+0x72>

00801d52 <close>:

int
close(int fdnum)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5b:	50                   	push   %eax
  801d5c:	ff 75 08             	pushl  0x8(%ebp)
  801d5f:	e8 b9 fe ff ff       	call   801c1d <fd_lookup>
  801d64:	83 c4 08             	add    $0x8,%esp
  801d67:	85 c0                	test   %eax,%eax
  801d69:	78 10                	js     801d7b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801d6b:	83 ec 08             	sub    $0x8,%esp
  801d6e:	6a 01                	push   $0x1
  801d70:	ff 75 f4             	pushl  -0xc(%ebp)
  801d73:	e8 51 ff ff ff       	call   801cc9 <fd_close>
  801d78:	83 c4 10             	add    $0x10,%esp
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <close_all>:

void
close_all(void)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	53                   	push   %ebx
  801d81:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801d84:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801d89:	83 ec 0c             	sub    $0xc,%esp
  801d8c:	53                   	push   %ebx
  801d8d:	e8 c0 ff ff ff       	call   801d52 <close>
	for (i = 0; i < MAXFD; i++)
  801d92:	83 c3 01             	add    $0x1,%ebx
  801d95:	83 c4 10             	add    $0x10,%esp
  801d98:	83 fb 20             	cmp    $0x20,%ebx
  801d9b:	75 ec                	jne    801d89 <close_all+0xc>
}
  801d9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	57                   	push   %edi
  801da6:	56                   	push   %esi
  801da7:	53                   	push   %ebx
  801da8:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801dab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801dae:	50                   	push   %eax
  801daf:	ff 75 08             	pushl  0x8(%ebp)
  801db2:	e8 66 fe ff ff       	call   801c1d <fd_lookup>
  801db7:	89 c3                	mov    %eax,%ebx
  801db9:	83 c4 08             	add    $0x8,%esp
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	0f 88 81 00 00 00    	js     801e45 <dup+0xa3>
		return r;
	close(newfdnum);
  801dc4:	83 ec 0c             	sub    $0xc,%esp
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	e8 83 ff ff ff       	call   801d52 <close>

	newfd = INDEX2FD(newfdnum);
  801dcf:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dd2:	c1 e6 0c             	shl    $0xc,%esi
  801dd5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801ddb:	83 c4 04             	add    $0x4,%esp
  801dde:	ff 75 e4             	pushl  -0x1c(%ebp)
  801de1:	e8 d1 fd ff ff       	call   801bb7 <fd2data>
  801de6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801de8:	89 34 24             	mov    %esi,(%esp)
  801deb:	e8 c7 fd ff ff       	call   801bb7 <fd2data>
  801df0:	83 c4 10             	add    $0x10,%esp
  801df3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801df5:	89 d8                	mov    %ebx,%eax
  801df7:	c1 e8 16             	shr    $0x16,%eax
  801dfa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e01:	a8 01                	test   $0x1,%al
  801e03:	74 11                	je     801e16 <dup+0x74>
  801e05:	89 d8                	mov    %ebx,%eax
  801e07:	c1 e8 0c             	shr    $0xc,%eax
  801e0a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e11:	f6 c2 01             	test   $0x1,%dl
  801e14:	75 39                	jne    801e4f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801e16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e19:	89 d0                	mov    %edx,%eax
  801e1b:	c1 e8 0c             	shr    $0xc,%eax
  801e1e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e25:	83 ec 0c             	sub    $0xc,%esp
  801e28:	25 07 0e 00 00       	and    $0xe07,%eax
  801e2d:	50                   	push   %eax
  801e2e:	56                   	push   %esi
  801e2f:	6a 00                	push   $0x0
  801e31:	52                   	push   %edx
  801e32:	6a 00                	push   $0x0
  801e34:	e8 33 f8 ff ff       	call   80166c <sys_page_map>
  801e39:	89 c3                	mov    %eax,%ebx
  801e3b:	83 c4 20             	add    $0x20,%esp
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	78 31                	js     801e73 <dup+0xd1>
		goto err;

	return newfdnum;
  801e42:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801e45:	89 d8                	mov    %ebx,%eax
  801e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4a:	5b                   	pop    %ebx
  801e4b:	5e                   	pop    %esi
  801e4c:	5f                   	pop    %edi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801e4f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	25 07 0e 00 00       	and    $0xe07,%eax
  801e5e:	50                   	push   %eax
  801e5f:	57                   	push   %edi
  801e60:	6a 00                	push   $0x0
  801e62:	53                   	push   %ebx
  801e63:	6a 00                	push   $0x0
  801e65:	e8 02 f8 ff ff       	call   80166c <sys_page_map>
  801e6a:	89 c3                	mov    %eax,%ebx
  801e6c:	83 c4 20             	add    $0x20,%esp
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	79 a3                	jns    801e16 <dup+0x74>
	sys_page_unmap(0, newfd);
  801e73:	83 ec 08             	sub    $0x8,%esp
  801e76:	56                   	push   %esi
  801e77:	6a 00                	push   $0x0
  801e79:	e8 30 f8 ff ff       	call   8016ae <sys_page_unmap>
	sys_page_unmap(0, nva);
  801e7e:	83 c4 08             	add    $0x8,%esp
  801e81:	57                   	push   %edi
  801e82:	6a 00                	push   $0x0
  801e84:	e8 25 f8 ff ff       	call   8016ae <sys_page_unmap>
	return r;
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	eb b7                	jmp    801e45 <dup+0xa3>

00801e8e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	53                   	push   %ebx
  801e92:	83 ec 14             	sub    $0x14,%esp
  801e95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e98:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e9b:	50                   	push   %eax
  801e9c:	53                   	push   %ebx
  801e9d:	e8 7b fd ff ff       	call   801c1d <fd_lookup>
  801ea2:	83 c4 08             	add    $0x8,%esp
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	78 3f                	js     801ee8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ea9:	83 ec 08             	sub    $0x8,%esp
  801eac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eaf:	50                   	push   %eax
  801eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb3:	ff 30                	pushl  (%eax)
  801eb5:	e8 b9 fd ff ff       	call   801c73 <dev_lookup>
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	78 27                	js     801ee8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ec1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ec4:	8b 42 08             	mov    0x8(%edx),%eax
  801ec7:	83 e0 03             	and    $0x3,%eax
  801eca:	83 f8 01             	cmp    $0x1,%eax
  801ecd:	74 1e                	je     801eed <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed2:	8b 40 08             	mov    0x8(%eax),%eax
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	74 35                	je     801f0e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801ed9:	83 ec 04             	sub    $0x4,%esp
  801edc:	ff 75 10             	pushl  0x10(%ebp)
  801edf:	ff 75 0c             	pushl  0xc(%ebp)
  801ee2:	52                   	push   %edx
  801ee3:	ff d0                	call   *%eax
  801ee5:	83 c4 10             	add    $0x10,%esp
}
  801ee8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801eed:	a1 24 54 80 00       	mov    0x805424,%eax
  801ef2:	8b 40 48             	mov    0x48(%eax),%eax
  801ef5:	83 ec 04             	sub    $0x4,%esp
  801ef8:	53                   	push   %ebx
  801ef9:	50                   	push   %eax
  801efa:	68 55 38 80 00       	push   $0x803855
  801eff:	e8 52 ec ff ff       	call   800b56 <cprintf>
		return -E_INVAL;
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f0c:	eb da                	jmp    801ee8 <read+0x5a>
		return -E_NOT_SUPP;
  801f0e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f13:	eb d3                	jmp    801ee8 <read+0x5a>

00801f15 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	57                   	push   %edi
  801f19:	56                   	push   %esi
  801f1a:	53                   	push   %ebx
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f21:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801f24:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f29:	39 f3                	cmp    %esi,%ebx
  801f2b:	73 25                	jae    801f52 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801f2d:	83 ec 04             	sub    $0x4,%esp
  801f30:	89 f0                	mov    %esi,%eax
  801f32:	29 d8                	sub    %ebx,%eax
  801f34:	50                   	push   %eax
  801f35:	89 d8                	mov    %ebx,%eax
  801f37:	03 45 0c             	add    0xc(%ebp),%eax
  801f3a:	50                   	push   %eax
  801f3b:	57                   	push   %edi
  801f3c:	e8 4d ff ff ff       	call   801e8e <read>
		if (m < 0)
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	85 c0                	test   %eax,%eax
  801f46:	78 08                	js     801f50 <readn+0x3b>
			return m;
		if (m == 0)
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	74 06                	je     801f52 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801f4c:	01 c3                	add    %eax,%ebx
  801f4e:	eb d9                	jmp    801f29 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801f50:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801f52:	89 d8                	mov    %ebx,%eax
  801f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	53                   	push   %ebx
  801f60:	83 ec 14             	sub    $0x14,%esp
  801f63:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f66:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f69:	50                   	push   %eax
  801f6a:	53                   	push   %ebx
  801f6b:	e8 ad fc ff ff       	call   801c1d <fd_lookup>
  801f70:	83 c4 08             	add    $0x8,%esp
  801f73:	85 c0                	test   %eax,%eax
  801f75:	78 3a                	js     801fb1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f77:	83 ec 08             	sub    $0x8,%esp
  801f7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7d:	50                   	push   %eax
  801f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f81:	ff 30                	pushl  (%eax)
  801f83:	e8 eb fc ff ff       	call   801c73 <dev_lookup>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	85 c0                	test   %eax,%eax
  801f8d:	78 22                	js     801fb1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f92:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801f96:	74 1e                	je     801fb6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801f98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9b:	8b 52 0c             	mov    0xc(%edx),%edx
  801f9e:	85 d2                	test   %edx,%edx
  801fa0:	74 35                	je     801fd7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	ff 75 10             	pushl  0x10(%ebp)
  801fa8:	ff 75 0c             	pushl  0xc(%ebp)
  801fab:	50                   	push   %eax
  801fac:	ff d2                	call   *%edx
  801fae:	83 c4 10             	add    $0x10,%esp
}
  801fb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801fb6:	a1 24 54 80 00       	mov    0x805424,%eax
  801fbb:	8b 40 48             	mov    0x48(%eax),%eax
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	53                   	push   %ebx
  801fc2:	50                   	push   %eax
  801fc3:	68 71 38 80 00       	push   $0x803871
  801fc8:	e8 89 eb ff ff       	call   800b56 <cprintf>
		return -E_INVAL;
  801fcd:	83 c4 10             	add    $0x10,%esp
  801fd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fd5:	eb da                	jmp    801fb1 <write+0x55>
		return -E_NOT_SUPP;
  801fd7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fdc:	eb d3                	jmp    801fb1 <write+0x55>

00801fde <seek>:

int
seek(int fdnum, off_t offset)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe4:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801fe7:	50                   	push   %eax
  801fe8:	ff 75 08             	pushl  0x8(%ebp)
  801feb:	e8 2d fc ff ff       	call   801c1d <fd_lookup>
  801ff0:	83 c4 08             	add    $0x8,%esp
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	78 0e                	js     802005 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ffd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	53                   	push   %ebx
  80200b:	83 ec 14             	sub    $0x14,%esp
  80200e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802011:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802014:	50                   	push   %eax
  802015:	53                   	push   %ebx
  802016:	e8 02 fc ff ff       	call   801c1d <fd_lookup>
  80201b:	83 c4 08             	add    $0x8,%esp
  80201e:	85 c0                	test   %eax,%eax
  802020:	78 37                	js     802059 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802022:	83 ec 08             	sub    $0x8,%esp
  802025:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802028:	50                   	push   %eax
  802029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202c:	ff 30                	pushl  (%eax)
  80202e:	e8 40 fc ff ff       	call   801c73 <dev_lookup>
  802033:	83 c4 10             	add    $0x10,%esp
  802036:	85 c0                	test   %eax,%eax
  802038:	78 1f                	js     802059 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80203a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802041:	74 1b                	je     80205e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802046:	8b 52 18             	mov    0x18(%edx),%edx
  802049:	85 d2                	test   %edx,%edx
  80204b:	74 32                	je     80207f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80204d:	83 ec 08             	sub    $0x8,%esp
  802050:	ff 75 0c             	pushl  0xc(%ebp)
  802053:	50                   	push   %eax
  802054:	ff d2                	call   *%edx
  802056:	83 c4 10             	add    $0x10,%esp
}
  802059:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80205e:	a1 24 54 80 00       	mov    0x805424,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802063:	8b 40 48             	mov    0x48(%eax),%eax
  802066:	83 ec 04             	sub    $0x4,%esp
  802069:	53                   	push   %ebx
  80206a:	50                   	push   %eax
  80206b:	68 34 38 80 00       	push   $0x803834
  802070:	e8 e1 ea ff ff       	call   800b56 <cprintf>
		return -E_INVAL;
  802075:	83 c4 10             	add    $0x10,%esp
  802078:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80207d:	eb da                	jmp    802059 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80207f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802084:	eb d3                	jmp    802059 <ftruncate+0x52>

00802086 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	53                   	push   %ebx
  80208a:	83 ec 14             	sub    $0x14,%esp
  80208d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802090:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802093:	50                   	push   %eax
  802094:	ff 75 08             	pushl  0x8(%ebp)
  802097:	e8 81 fb ff ff       	call   801c1d <fd_lookup>
  80209c:	83 c4 08             	add    $0x8,%esp
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	78 4b                	js     8020ee <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020a3:	83 ec 08             	sub    $0x8,%esp
  8020a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a9:	50                   	push   %eax
  8020aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ad:	ff 30                	pushl  (%eax)
  8020af:	e8 bf fb ff ff       	call   801c73 <dev_lookup>
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	78 33                	js     8020ee <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8020bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020be:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8020c2:	74 2f                	je     8020f3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8020c4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8020c7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8020ce:	00 00 00 
	stat->st_isdir = 0;
  8020d1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020d8:	00 00 00 
	stat->st_dev = dev;
  8020db:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8020e1:	83 ec 08             	sub    $0x8,%esp
  8020e4:	53                   	push   %ebx
  8020e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8020e8:	ff 50 14             	call   *0x14(%eax)
  8020eb:	83 c4 10             	add    $0x10,%esp
}
  8020ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    
		return -E_NOT_SUPP;
  8020f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020f8:	eb f4                	jmp    8020ee <fstat+0x68>

008020fa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	56                   	push   %esi
  8020fe:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8020ff:	83 ec 08             	sub    $0x8,%esp
  802102:	6a 00                	push   $0x0
  802104:	ff 75 08             	pushl  0x8(%ebp)
  802107:	e8 e7 01 00 00       	call   8022f3 <open>
  80210c:	89 c3                	mov    %eax,%ebx
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	85 c0                	test   %eax,%eax
  802113:	78 1b                	js     802130 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802115:	83 ec 08             	sub    $0x8,%esp
  802118:	ff 75 0c             	pushl  0xc(%ebp)
  80211b:	50                   	push   %eax
  80211c:	e8 65 ff ff ff       	call   802086 <fstat>
  802121:	89 c6                	mov    %eax,%esi
	close(fd);
  802123:	89 1c 24             	mov    %ebx,(%esp)
  802126:	e8 27 fc ff ff       	call   801d52 <close>
	return r;
  80212b:	83 c4 10             	add    $0x10,%esp
  80212e:	89 f3                	mov    %esi,%ebx
}
  802130:	89 d8                	mov    %ebx,%eax
  802132:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802135:	5b                   	pop    %ebx
  802136:	5e                   	pop    %esi
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    

00802139 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	56                   	push   %esi
  80213d:	53                   	push   %ebx
  80213e:	89 c6                	mov    %eax,%esi
  802140:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802142:	83 3d 20 54 80 00 00 	cmpl   $0x0,0x805420
  802149:	74 27                	je     802172 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80214b:	6a 07                	push   $0x7
  80214d:	68 00 60 80 00       	push   $0x806000
  802152:	56                   	push   %esi
  802153:	ff 35 20 54 80 00    	pushl  0x805420
  802159:	e8 b3 0d 00 00       	call   802f11 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80215e:	83 c4 0c             	add    $0xc,%esp
  802161:	6a 00                	push   $0x0
  802163:	53                   	push   %ebx
  802164:	6a 00                	push   $0x0
  802166:	e8 8f 0d 00 00       	call   802efa <ipc_recv>
}
  80216b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80216e:	5b                   	pop    %ebx
  80216f:	5e                   	pop    %esi
  802170:	5d                   	pop    %ebp
  802171:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802172:	83 ec 0c             	sub    $0xc,%esp
  802175:	6a 01                	push   $0x1
  802177:	e8 ac 0d 00 00       	call   802f28 <ipc_find_env>
  80217c:	a3 20 54 80 00       	mov    %eax,0x805420
  802181:	83 c4 10             	add    $0x10,%esp
  802184:	eb c5                	jmp    80214b <fsipc+0x12>

00802186 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	8b 40 0c             	mov    0xc(%eax),%eax
  802192:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  802197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80219f:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a4:	b8 02 00 00 00       	mov    $0x2,%eax
  8021a9:	e8 8b ff ff ff       	call   802139 <fsipc>
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <devfile_flush>:
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8021bc:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8021c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c6:	b8 06 00 00 00       	mov    $0x6,%eax
  8021cb:	e8 69 ff ff ff       	call   802139 <fsipc>
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <devfile_stat>:
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	53                   	push   %ebx
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e2:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8021e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ec:	b8 05 00 00 00       	mov    $0x5,%eax
  8021f1:	e8 43 ff ff ff       	call   802139 <fsipc>
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	78 2c                	js     802226 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8021fa:	83 ec 08             	sub    $0x8,%esp
  8021fd:	68 00 60 80 00       	push   $0x806000
  802202:	53                   	push   %ebx
  802203:	e8 28 f0 ff ff       	call   801230 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802208:	a1 80 60 80 00       	mov    0x806080,%eax
  80220d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802213:	a1 84 60 80 00       	mov    0x806084,%eax
  802218:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80221e:	83 c4 10             	add    $0x10,%esp
  802221:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802226:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <devfile_write>:
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 0c             	sub    $0xc,%esp
  802231:	8b 45 10             	mov    0x10(%ebp),%eax
  802234:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  802239:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80223e:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802241:	8b 55 08             	mov    0x8(%ebp),%edx
  802244:	8b 52 0c             	mov    0xc(%edx),%edx
  802247:	89 15 00 60 80 00    	mov    %edx,0x806000
        fsipcbuf.write.req_n = n;
  80224d:	a3 04 60 80 00       	mov    %eax,0x806004
        memmove(fsipcbuf.write.req_buf, buf, n);
  802252:	50                   	push   %eax
  802253:	ff 75 0c             	pushl  0xc(%ebp)
  802256:	68 08 60 80 00       	push   $0x806008
  80225b:	e8 5e f1 ff ff       	call   8013be <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802260:	ba 00 00 00 00       	mov    $0x0,%edx
  802265:	b8 04 00 00 00       	mov    $0x4,%eax
  80226a:	e8 ca fe ff ff       	call   802139 <fsipc>
}
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <devfile_read>:
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	56                   	push   %esi
  802275:	53                   	push   %ebx
  802276:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	8b 40 0c             	mov    0xc(%eax),%eax
  80227f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802284:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80228a:	ba 00 00 00 00       	mov    $0x0,%edx
  80228f:	b8 03 00 00 00       	mov    $0x3,%eax
  802294:	e8 a0 fe ff ff       	call   802139 <fsipc>
  802299:	89 c3                	mov    %eax,%ebx
  80229b:	85 c0                	test   %eax,%eax
  80229d:	78 1f                	js     8022be <devfile_read+0x4d>
	assert(r <= n);
  80229f:	39 f0                	cmp    %esi,%eax
  8022a1:	77 24                	ja     8022c7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8022a3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8022a8:	7f 33                	jg     8022dd <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8022aa:	83 ec 04             	sub    $0x4,%esp
  8022ad:	50                   	push   %eax
  8022ae:	68 00 60 80 00       	push   $0x806000
  8022b3:	ff 75 0c             	pushl  0xc(%ebp)
  8022b6:	e8 03 f1 ff ff       	call   8013be <memmove>
	return r;
  8022bb:	83 c4 10             	add    $0x10,%esp
}
  8022be:	89 d8                	mov    %ebx,%eax
  8022c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022c3:	5b                   	pop    %ebx
  8022c4:	5e                   	pop    %esi
  8022c5:	5d                   	pop    %ebp
  8022c6:	c3                   	ret    
	assert(r <= n);
  8022c7:	68 a0 38 80 00       	push   $0x8038a0
  8022cc:	68 1a 33 80 00       	push   $0x80331a
  8022d1:	6a 7c                	push   $0x7c
  8022d3:	68 a7 38 80 00       	push   $0x8038a7
  8022d8:	e8 9e e7 ff ff       	call   800a7b <_panic>
	assert(r <= PGSIZE);
  8022dd:	68 b2 38 80 00       	push   $0x8038b2
  8022e2:	68 1a 33 80 00       	push   $0x80331a
  8022e7:	6a 7d                	push   $0x7d
  8022e9:	68 a7 38 80 00       	push   $0x8038a7
  8022ee:	e8 88 e7 ff ff       	call   800a7b <_panic>

008022f3 <open>:
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	56                   	push   %esi
  8022f7:	53                   	push   %ebx
  8022f8:	83 ec 1c             	sub    $0x1c,%esp
  8022fb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8022fe:	56                   	push   %esi
  8022ff:	e8 f5 ee ff ff       	call   8011f9 <strlen>
  802304:	83 c4 10             	add    $0x10,%esp
  802307:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80230c:	7f 6c                	jg     80237a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80230e:	83 ec 0c             	sub    $0xc,%esp
  802311:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802314:	50                   	push   %eax
  802315:	e8 b4 f8 ff ff       	call   801bce <fd_alloc>
  80231a:	89 c3                	mov    %eax,%ebx
  80231c:	83 c4 10             	add    $0x10,%esp
  80231f:	85 c0                	test   %eax,%eax
  802321:	78 3c                	js     80235f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802323:	83 ec 08             	sub    $0x8,%esp
  802326:	56                   	push   %esi
  802327:	68 00 60 80 00       	push   $0x806000
  80232c:	e8 ff ee ff ff       	call   801230 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802331:	8b 45 0c             	mov    0xc(%ebp),%eax
  802334:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802339:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233c:	b8 01 00 00 00       	mov    $0x1,%eax
  802341:	e8 f3 fd ff ff       	call   802139 <fsipc>
  802346:	89 c3                	mov    %eax,%ebx
  802348:	83 c4 10             	add    $0x10,%esp
  80234b:	85 c0                	test   %eax,%eax
  80234d:	78 19                	js     802368 <open+0x75>
	return fd2num(fd);
  80234f:	83 ec 0c             	sub    $0xc,%esp
  802352:	ff 75 f4             	pushl  -0xc(%ebp)
  802355:	e8 4d f8 ff ff       	call   801ba7 <fd2num>
  80235a:	89 c3                	mov    %eax,%ebx
  80235c:	83 c4 10             	add    $0x10,%esp
}
  80235f:	89 d8                	mov    %ebx,%eax
  802361:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802364:	5b                   	pop    %ebx
  802365:	5e                   	pop    %esi
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    
		fd_close(fd, 0);
  802368:	83 ec 08             	sub    $0x8,%esp
  80236b:	6a 00                	push   $0x0
  80236d:	ff 75 f4             	pushl  -0xc(%ebp)
  802370:	e8 54 f9 ff ff       	call   801cc9 <fd_close>
		return r;
  802375:	83 c4 10             	add    $0x10,%esp
  802378:	eb e5                	jmp    80235f <open+0x6c>
		return -E_BAD_PATH;
  80237a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80237f:	eb de                	jmp    80235f <open+0x6c>

00802381 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802387:	ba 00 00 00 00       	mov    $0x0,%edx
  80238c:	b8 08 00 00 00       	mov    $0x8,%eax
  802391:	e8 a3 fd ff ff       	call   802139 <fsipc>
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  802398:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80239c:	7e 38                	jle    8023d6 <writebuf+0x3e>
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	53                   	push   %ebx
  8023a2:	83 ec 08             	sub    $0x8,%esp
  8023a5:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8023a7:	ff 70 04             	pushl  0x4(%eax)
  8023aa:	8d 40 10             	lea    0x10(%eax),%eax
  8023ad:	50                   	push   %eax
  8023ae:	ff 33                	pushl  (%ebx)
  8023b0:	e8 a7 fb ff ff       	call   801f5c <write>
		if (result > 0)
  8023b5:	83 c4 10             	add    $0x10,%esp
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	7e 03                	jle    8023bf <writebuf+0x27>
			b->result += result;
  8023bc:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8023bf:	39 43 04             	cmp    %eax,0x4(%ebx)
  8023c2:	74 0d                	je     8023d1 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8023cb:	0f 4f c2             	cmovg  %edx,%eax
  8023ce:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8023d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    
  8023d6:	f3 c3                	repz ret 

008023d8 <putch>:

static void
putch(int ch, void *thunk)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	53                   	push   %ebx
  8023dc:	83 ec 04             	sub    $0x4,%esp
  8023df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8023e2:	8b 53 04             	mov    0x4(%ebx),%edx
  8023e5:	8d 42 01             	lea    0x1(%edx),%eax
  8023e8:	89 43 04             	mov    %eax,0x4(%ebx)
  8023eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023ee:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8023f2:	3d 00 01 00 00       	cmp    $0x100,%eax
  8023f7:	74 06                	je     8023ff <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8023f9:	83 c4 04             	add    $0x4,%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5d                   	pop    %ebp
  8023fe:	c3                   	ret    
		writebuf(b);
  8023ff:	89 d8                	mov    %ebx,%eax
  802401:	e8 92 ff ff ff       	call   802398 <writebuf>
		b->idx = 0;
  802406:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80240d:	eb ea                	jmp    8023f9 <putch+0x21>

0080240f <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  802421:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802428:	00 00 00 
	b.result = 0;
  80242b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802432:	00 00 00 
	b.error = 1;
  802435:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  80243c:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80243f:	ff 75 10             	pushl  0x10(%ebp)
  802442:	ff 75 0c             	pushl  0xc(%ebp)
  802445:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80244b:	50                   	push   %eax
  80244c:	68 d8 23 80 00       	push   $0x8023d8
  802451:	e8 fd e7 ff ff       	call   800c53 <vprintfmt>
	if (b.idx > 0)
  802456:	83 c4 10             	add    $0x10,%esp
  802459:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802460:	7f 11                	jg     802473 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  802462:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802468:	85 c0                	test   %eax,%eax
  80246a:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    
		writebuf(&b);
  802473:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802479:	e8 1a ff ff ff       	call   802398 <writebuf>
  80247e:	eb e2                	jmp    802462 <vfprintf+0x53>

00802480 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802486:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802489:	50                   	push   %eax
  80248a:	ff 75 0c             	pushl  0xc(%ebp)
  80248d:	ff 75 08             	pushl  0x8(%ebp)
  802490:	e8 7a ff ff ff       	call   80240f <vfprintf>
	va_end(ap);

	return cnt;
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <printf>:

int
printf(const char *fmt, ...)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80249d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8024a0:	50                   	push   %eax
  8024a1:	ff 75 08             	pushl  0x8(%ebp)
  8024a4:	6a 01                	push   $0x1
  8024a6:	e8 64 ff ff ff       	call   80240f <vfprintf>
	va_end(ap);

	return cnt;
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
  8024b0:	57                   	push   %edi
  8024b1:	56                   	push   %esi
  8024b2:	53                   	push   %ebx
  8024b3:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8024b9:	6a 00                	push   $0x0
  8024bb:	ff 75 08             	pushl  0x8(%ebp)
  8024be:	e8 30 fe ff ff       	call   8022f3 <open>
  8024c3:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8024c9:	83 c4 10             	add    $0x10,%esp
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	0f 88 40 03 00 00    	js     802814 <spawn+0x367>
  8024d4:	89 c7                	mov    %eax,%edi
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8024d6:	83 ec 04             	sub    $0x4,%esp
  8024d9:	68 00 02 00 00       	push   $0x200
  8024de:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8024e4:	50                   	push   %eax
  8024e5:	57                   	push   %edi
  8024e6:	e8 2a fa ff ff       	call   801f15 <readn>
  8024eb:	83 c4 10             	add    $0x10,%esp
  8024ee:	3d 00 02 00 00       	cmp    $0x200,%eax
  8024f3:	75 5d                	jne    802552 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  8024f5:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8024fc:	45 4c 46 
  8024ff:	75 51                	jne    802552 <spawn+0xa5>
  802501:	b8 07 00 00 00       	mov    $0x7,%eax
  802506:	cd 30                	int    $0x30
  802508:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80250e:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802514:	85 c0                	test   %eax,%eax
  802516:	0f 88 81 04 00 00    	js     80299d <spawn+0x4f0>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80251c:	25 ff 03 00 00       	and    $0x3ff,%eax
  802521:	6b f0 7c             	imul   $0x7c,%eax,%esi
  802524:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80252a:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802530:	b9 11 00 00 00       	mov    $0x11,%ecx
  802535:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802537:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80253d:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802543:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  802548:	be 00 00 00 00       	mov    $0x0,%esi
  80254d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802550:	eb 4b                	jmp    80259d <spawn+0xf0>
		close(fd);
  802552:	83 ec 0c             	sub    $0xc,%esp
  802555:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80255b:	e8 f2 f7 ff ff       	call   801d52 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802560:	83 c4 0c             	add    $0xc,%esp
  802563:	68 7f 45 4c 46       	push   $0x464c457f
  802568:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80256e:	68 be 38 80 00       	push   $0x8038be
  802573:	e8 de e5 ff ff       	call   800b56 <cprintf>
		return -E_NOT_EXEC;
  802578:	83 c4 10             	add    $0x10,%esp
  80257b:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  802582:	ff ff ff 
  802585:	e9 8a 02 00 00       	jmp    802814 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  80258a:	83 ec 0c             	sub    $0xc,%esp
  80258d:	50                   	push   %eax
  80258e:	e8 66 ec ff ff       	call   8011f9 <strlen>
  802593:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  802597:	83 c3 01             	add    $0x1,%ebx
  80259a:	83 c4 10             	add    $0x10,%esp
  80259d:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8025a4:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	75 df                	jne    80258a <spawn+0xdd>
  8025ab:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8025b1:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8025b7:	bf 00 10 40 00       	mov    $0x401000,%edi
  8025bc:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8025be:	89 fa                	mov    %edi,%edx
  8025c0:	83 e2 fc             	and    $0xfffffffc,%edx
  8025c3:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8025ca:	29 c2                	sub    %eax,%edx
  8025cc:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8025d2:	8d 42 f8             	lea    -0x8(%edx),%eax
  8025d5:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8025da:	0f 86 ce 03 00 00    	jbe    8029ae <spawn+0x501>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8025e0:	83 ec 04             	sub    $0x4,%esp
  8025e3:	6a 07                	push   $0x7
  8025e5:	68 00 00 40 00       	push   $0x400000
  8025ea:	6a 00                	push   $0x0
  8025ec:	e8 38 f0 ff ff       	call   801629 <sys_page_alloc>
  8025f1:	83 c4 10             	add    $0x10,%esp
  8025f4:	85 c0                	test   %eax,%eax
  8025f6:	0f 88 b7 03 00 00    	js     8029b3 <spawn+0x506>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8025fc:	be 00 00 00 00       	mov    $0x0,%esi
  802601:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  802607:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80260a:	eb 30                	jmp    80263c <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  80260c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802612:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802618:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80261b:	83 ec 08             	sub    $0x8,%esp
  80261e:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802621:	57                   	push   %edi
  802622:	e8 09 ec ff ff       	call   801230 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802627:	83 c4 04             	add    $0x4,%esp
  80262a:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80262d:	e8 c7 eb ff ff       	call   8011f9 <strlen>
  802632:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802636:	83 c6 01             	add    $0x1,%esi
  802639:	83 c4 10             	add    $0x10,%esp
  80263c:	39 b5 88 fd ff ff    	cmp    %esi,-0x278(%ebp)
  802642:	7f c8                	jg     80260c <spawn+0x15f>
	}
	argv_store[argc] = 0;
  802644:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80264a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802650:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802657:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80265d:	0f 85 8c 00 00 00    	jne    8026ef <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802663:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  802669:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80266f:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  802672:	89 f8                	mov    %edi,%eax
  802674:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  80267a:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80267d:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802682:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802688:	83 ec 0c             	sub    $0xc,%esp
  80268b:	6a 07                	push   $0x7
  80268d:	68 00 d0 bf ee       	push   $0xeebfd000
  802692:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802698:	68 00 00 40 00       	push   $0x400000
  80269d:	6a 00                	push   $0x0
  80269f:	e8 c8 ef ff ff       	call   80166c <sys_page_map>
  8026a4:	89 c3                	mov    %eax,%ebx
  8026a6:	83 c4 20             	add    $0x20,%esp
  8026a9:	85 c0                	test   %eax,%eax
  8026ab:	0f 88 78 03 00 00    	js     802a29 <spawn+0x57c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8026b1:	83 ec 08             	sub    $0x8,%esp
  8026b4:	68 00 00 40 00       	push   $0x400000
  8026b9:	6a 00                	push   $0x0
  8026bb:	e8 ee ef ff ff       	call   8016ae <sys_page_unmap>
  8026c0:	89 c3                	mov    %eax,%ebx
  8026c2:	83 c4 10             	add    $0x10,%esp
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	0f 88 5c 03 00 00    	js     802a29 <spawn+0x57c>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8026cd:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8026d3:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8026da:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8026e0:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8026e7:	00 00 00 
  8026ea:	e9 56 01 00 00       	jmp    802845 <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8026ef:	68 34 39 80 00       	push   $0x803934
  8026f4:	68 1a 33 80 00       	push   $0x80331a
  8026f9:	68 f2 00 00 00       	push   $0xf2
  8026fe:	68 d8 38 80 00       	push   $0x8038d8
  802703:	e8 73 e3 ff ff       	call   800a7b <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802708:	83 ec 04             	sub    $0x4,%esp
  80270b:	6a 07                	push   $0x7
  80270d:	68 00 00 40 00       	push   $0x400000
  802712:	6a 00                	push   $0x0
  802714:	e8 10 ef ff ff       	call   801629 <sys_page_alloc>
  802719:	83 c4 10             	add    $0x10,%esp
  80271c:	85 c0                	test   %eax,%eax
  80271e:	0f 88 9a 02 00 00    	js     8029be <spawn+0x511>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802724:	83 ec 08             	sub    $0x8,%esp
  802727:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80272d:	01 f0                	add    %esi,%eax
  80272f:	50                   	push   %eax
  802730:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  802736:	e8 a3 f8 ff ff       	call   801fde <seek>
  80273b:	83 c4 10             	add    $0x10,%esp
  80273e:	85 c0                	test   %eax,%eax
  802740:	0f 88 7f 02 00 00    	js     8029c5 <spawn+0x518>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802746:	83 ec 04             	sub    $0x4,%esp
  802749:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80274f:	29 f0                	sub    %esi,%eax
  802751:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802756:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80275b:	0f 47 c1             	cmova  %ecx,%eax
  80275e:	50                   	push   %eax
  80275f:	68 00 00 40 00       	push   $0x400000
  802764:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80276a:	e8 a6 f7 ff ff       	call   801f15 <readn>
  80276f:	83 c4 10             	add    $0x10,%esp
  802772:	85 c0                	test   %eax,%eax
  802774:	0f 88 52 02 00 00    	js     8029cc <spawn+0x51f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80277a:	83 ec 0c             	sub    $0xc,%esp
  80277d:	57                   	push   %edi
  80277e:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  802784:	56                   	push   %esi
  802785:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80278b:	68 00 00 40 00       	push   $0x400000
  802790:	6a 00                	push   $0x0
  802792:	e8 d5 ee ff ff       	call   80166c <sys_page_map>
  802797:	83 c4 20             	add    $0x20,%esp
  80279a:	85 c0                	test   %eax,%eax
  80279c:	0f 88 80 00 00 00    	js     802822 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8027a2:	83 ec 08             	sub    $0x8,%esp
  8027a5:	68 00 00 40 00       	push   $0x400000
  8027aa:	6a 00                	push   $0x0
  8027ac:	e8 fd ee ff ff       	call   8016ae <sys_page_unmap>
  8027b1:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8027b4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8027ba:	89 de                	mov    %ebx,%esi
  8027bc:	39 9d 88 fd ff ff    	cmp    %ebx,-0x278(%ebp)
  8027c2:	76 73                	jbe    802837 <spawn+0x38a>
		if (i >= filesz) {
  8027c4:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8027ca:	0f 87 38 ff ff ff    	ja     802708 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8027d0:	83 ec 04             	sub    $0x4,%esp
  8027d3:	57                   	push   %edi
  8027d4:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  8027da:	56                   	push   %esi
  8027db:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8027e1:	e8 43 ee ff ff       	call   801629 <sys_page_alloc>
  8027e6:	83 c4 10             	add    $0x10,%esp
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	79 c7                	jns    8027b4 <spawn+0x307>
  8027ed:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8027ef:	83 ec 0c             	sub    $0xc,%esp
  8027f2:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8027f8:	e8 ad ed ff ff       	call   8015aa <sys_env_destroy>
	close(fd);
  8027fd:	83 c4 04             	add    $0x4,%esp
  802800:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  802806:	e8 47 f5 ff ff       	call   801d52 <close>
	return r;
  80280b:	83 c4 10             	add    $0x10,%esp
  80280e:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  802814:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80281a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80281d:	5b                   	pop    %ebx
  80281e:	5e                   	pop    %esi
  80281f:	5f                   	pop    %edi
  802820:	5d                   	pop    %ebp
  802821:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  802822:	50                   	push   %eax
  802823:	68 e4 38 80 00       	push   $0x8038e4
  802828:	68 25 01 00 00       	push   $0x125
  80282d:	68 d8 38 80 00       	push   $0x8038d8
  802832:	e8 44 e2 ff ff       	call   800a7b <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802837:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  80283e:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  802845:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80284c:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  802852:	7e 71                	jle    8028c5 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  802854:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  80285a:	83 39 01             	cmpl   $0x1,(%ecx)
  80285d:	75 d8                	jne    802837 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80285f:	8b 41 18             	mov    0x18(%ecx),%eax
  802862:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802865:	83 f8 01             	cmp    $0x1,%eax
  802868:	19 ff                	sbb    %edi,%edi
  80286a:	83 e7 fe             	and    $0xfffffffe,%edi
  80286d:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802870:	8b 71 04             	mov    0x4(%ecx),%esi
  802873:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  802879:	8b 59 10             	mov    0x10(%ecx),%ebx
  80287c:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802882:	8b 41 14             	mov    0x14(%ecx),%eax
  802885:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  80288b:	8b 51 08             	mov    0x8(%ecx),%edx
  80288e:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	if ((i = PGOFF(va))) {
  802894:	89 d0                	mov    %edx,%eax
  802896:	25 ff 0f 00 00       	and    $0xfff,%eax
  80289b:	74 1e                	je     8028bb <spawn+0x40e>
		va -= i;
  80289d:	29 c2                	sub    %eax,%edx
  80289f:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		memsz += i;
  8028a5:	01 85 88 fd ff ff    	add    %eax,-0x278(%ebp)
		filesz += i;
  8028ab:	01 c3                	add    %eax,%ebx
  8028ad:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  8028b3:	29 c6                	sub    %eax,%esi
  8028b5:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8028bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028c0:	e9 f5 fe ff ff       	jmp    8027ba <spawn+0x30d>
	close(fd);
  8028c5:	83 ec 0c             	sub    $0xc,%esp
  8028c8:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8028ce:	e8 7f f4 ff ff       	call   801d52 <close>
  8028d3:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i, j, pn, r;

        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  8028d6:	bf 02 00 00 00       	mov    $0x2,%edi
  8028db:	eb 7c                	jmp    802959 <spawn+0x4ac>
  8028dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
                if (uvpd[i] & PTE_P) {
                        for (j = 0; j < NPTENTRIES; j++) {
  8028e3:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  8028e9:	74 63                	je     80294e <spawn+0x4a1>
                                pn = PGNUM(PGADDR(i, j, 0));
  8028eb:	89 da                	mov    %ebx,%edx
  8028ed:	09 f2                	or     %esi,%edx
  8028ef:	89 d0                	mov    %edx,%eax
  8028f1:	c1 e8 0c             	shr    $0xc,%eax
                                if (pn == PGNUM(UXSTACKTOP - PGSIZE))
  8028f4:	3d ff eb 0e 00       	cmp    $0xeebff,%eax
  8028f9:	74 53                	je     80294e <spawn+0x4a1>
                                        break;
                                if ((uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  8028fb:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  802902:	f6 c1 01             	test   $0x1,%cl
  802905:	74 d6                	je     8028dd <spawn+0x430>
  802907:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  80290e:	f6 c5 04             	test   $0x4,%ch
  802911:	74 ca                	je     8028dd <spawn+0x430>
                                        if ((r = sys_page_map(0, (void *)PGADDR(i, j, 0), child, (void *)PGADDR(i, j, 0), uvpt[pn] & PTE_SYSCALL)) < 0)
  802913:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80291a:	83 ec 0c             	sub    $0xc,%esp
  80291d:	25 07 0e 00 00       	and    $0xe07,%eax
  802922:	50                   	push   %eax
  802923:	52                   	push   %edx
  802924:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80292a:	52                   	push   %edx
  80292b:	6a 00                	push   $0x0
  80292d:	e8 3a ed ff ff       	call   80166c <sys_page_map>
  802932:	83 c4 20             	add    $0x20,%esp
  802935:	85 c0                	test   %eax,%eax
  802937:	79 a4                	jns    8028dd <spawn+0x430>
		panic("copy_shared_pages: %e", r);
  802939:	50                   	push   %eax
  80293a:	68 1b 39 80 00       	push   $0x80391b
  80293f:	68 82 00 00 00       	push   $0x82
  802944:	68 d8 38 80 00       	push   $0x8038d8
  802949:	e8 2d e1 ff ff       	call   800a7b <_panic>
        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  80294e:	83 c7 01             	add    $0x1,%edi
  802951:	81 ff bb 03 00 00    	cmp    $0x3bb,%edi
  802957:	74 7a                	je     8029d3 <spawn+0x526>
                if (uvpd[i] & PTE_P) {
  802959:	8b 04 bd 00 d0 7b ef 	mov    -0x10843000(,%edi,4),%eax
  802960:	a8 01                	test   $0x1,%al
  802962:	74 ea                	je     80294e <spawn+0x4a1>
  802964:	89 fe                	mov    %edi,%esi
  802966:	c1 e6 16             	shl    $0x16,%esi
  802969:	bb 00 00 00 00       	mov    $0x0,%ebx
  80296e:	e9 78 ff ff ff       	jmp    8028eb <spawn+0x43e>
		panic("sys_env_set_trapframe: %e", r);
  802973:	50                   	push   %eax
  802974:	68 01 39 80 00       	push   $0x803901
  802979:	68 86 00 00 00       	push   $0x86
  80297e:	68 d8 38 80 00       	push   $0x8038d8
  802983:	e8 f3 e0 ff ff       	call   800a7b <_panic>
		panic("sys_env_set_status: %e", r);
  802988:	50                   	push   %eax
  802989:	68 7d 37 80 00       	push   $0x80377d
  80298e:	68 89 00 00 00       	push   $0x89
  802993:	68 d8 38 80 00       	push   $0x8038d8
  802998:	e8 de e0 ff ff       	call   800a7b <_panic>
		return r;
  80299d:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8029a3:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8029a9:	e9 66 fe ff ff       	jmp    802814 <spawn+0x367>
		return -E_NO_MEM;
  8029ae:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  8029b3:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8029b9:	e9 56 fe ff ff       	jmp    802814 <spawn+0x367>
  8029be:	89 c7                	mov    %eax,%edi
  8029c0:	e9 2a fe ff ff       	jmp    8027ef <spawn+0x342>
  8029c5:	89 c7                	mov    %eax,%edi
  8029c7:	e9 23 fe ff ff       	jmp    8027ef <spawn+0x342>
  8029cc:	89 c7                	mov    %eax,%edi
  8029ce:	e9 1c fe ff ff       	jmp    8027ef <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8029d3:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8029da:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8029dd:	83 ec 08             	sub    $0x8,%esp
  8029e0:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8029e6:	50                   	push   %eax
  8029e7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8029ed:	e8 40 ed ff ff       	call   801732 <sys_env_set_trapframe>
  8029f2:	83 c4 10             	add    $0x10,%esp
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	0f 88 76 ff ff ff    	js     802973 <spawn+0x4c6>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8029fd:	83 ec 08             	sub    $0x8,%esp
  802a00:	6a 02                	push   $0x2
  802a02:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802a08:	e8 e3 ec ff ff       	call   8016f0 <sys_env_set_status>
  802a0d:	83 c4 10             	add    $0x10,%esp
  802a10:	85 c0                	test   %eax,%eax
  802a12:	0f 88 70 ff ff ff    	js     802988 <spawn+0x4db>
	return child;
  802a18:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802a1e:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802a24:	e9 eb fd ff ff       	jmp    802814 <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  802a29:	83 ec 08             	sub    $0x8,%esp
  802a2c:	68 00 00 40 00       	push   $0x400000
  802a31:	6a 00                	push   $0x0
  802a33:	e8 76 ec ff ff       	call   8016ae <sys_page_unmap>
  802a38:	83 c4 10             	add    $0x10,%esp
  802a3b:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802a41:	e9 ce fd ff ff       	jmp    802814 <spawn+0x367>

00802a46 <spawnl>:
{
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
  802a49:	57                   	push   %edi
  802a4a:	56                   	push   %esi
  802a4b:	53                   	push   %ebx
  802a4c:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802a4f:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802a52:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802a57:	eb 05                	jmp    802a5e <spawnl+0x18>
		argc++;
  802a59:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802a5c:	89 ca                	mov    %ecx,%edx
  802a5e:	8d 4a 04             	lea    0x4(%edx),%ecx
  802a61:	83 3a 00             	cmpl   $0x0,(%edx)
  802a64:	75 f3                	jne    802a59 <spawnl+0x13>
	const char *argv[argc+2];
  802a66:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  802a6d:	83 e2 f0             	and    $0xfffffff0,%edx
  802a70:	29 d4                	sub    %edx,%esp
  802a72:	8d 54 24 03          	lea    0x3(%esp),%edx
  802a76:	c1 ea 02             	shr    $0x2,%edx
  802a79:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802a80:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802a82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a85:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802a8c:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802a93:	00 
	va_start(vl, arg0);
  802a94:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802a97:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802a99:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9e:	eb 0b                	jmp    802aab <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  802aa0:	83 c0 01             	add    $0x1,%eax
  802aa3:	8b 39                	mov    (%ecx),%edi
  802aa5:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802aa8:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802aab:	39 d0                	cmp    %edx,%eax
  802aad:	75 f1                	jne    802aa0 <spawnl+0x5a>
	return spawn(prog, argv);
  802aaf:	83 ec 08             	sub    $0x8,%esp
  802ab2:	56                   	push   %esi
  802ab3:	ff 75 08             	pushl  0x8(%ebp)
  802ab6:	e8 f2 f9 ff ff       	call   8024ad <spawn>
}
  802abb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802abe:	5b                   	pop    %ebx
  802abf:	5e                   	pop    %esi
  802ac0:	5f                   	pop    %edi
  802ac1:	5d                   	pop    %ebp
  802ac2:	c3                   	ret    

00802ac3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ac3:	55                   	push   %ebp
  802ac4:	89 e5                	mov    %esp,%ebp
  802ac6:	56                   	push   %esi
  802ac7:	53                   	push   %ebx
  802ac8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802acb:	83 ec 0c             	sub    $0xc,%esp
  802ace:	ff 75 08             	pushl  0x8(%ebp)
  802ad1:	e8 e1 f0 ff ff       	call   801bb7 <fd2data>
  802ad6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802ad8:	83 c4 08             	add    $0x8,%esp
  802adb:	68 5c 39 80 00       	push   $0x80395c
  802ae0:	53                   	push   %ebx
  802ae1:	e8 4a e7 ff ff       	call   801230 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802ae6:	8b 46 04             	mov    0x4(%esi),%eax
  802ae9:	2b 06                	sub    (%esi),%eax
  802aeb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802af1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802af8:	00 00 00 
	stat->st_dev = &devpipe;
  802afb:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802b02:	40 80 00 
	return 0;
}
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b0d:	5b                   	pop    %ebx
  802b0e:	5e                   	pop    %esi
  802b0f:	5d                   	pop    %ebp
  802b10:	c3                   	ret    

00802b11 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802b11:	55                   	push   %ebp
  802b12:	89 e5                	mov    %esp,%ebp
  802b14:	53                   	push   %ebx
  802b15:	83 ec 0c             	sub    $0xc,%esp
  802b18:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802b1b:	53                   	push   %ebx
  802b1c:	6a 00                	push   $0x0
  802b1e:	e8 8b eb ff ff       	call   8016ae <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802b23:	89 1c 24             	mov    %ebx,(%esp)
  802b26:	e8 8c f0 ff ff       	call   801bb7 <fd2data>
  802b2b:	83 c4 08             	add    $0x8,%esp
  802b2e:	50                   	push   %eax
  802b2f:	6a 00                	push   $0x0
  802b31:	e8 78 eb ff ff       	call   8016ae <sys_page_unmap>
}
  802b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b39:	c9                   	leave  
  802b3a:	c3                   	ret    

00802b3b <_pipeisclosed>:
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
  802b3e:	57                   	push   %edi
  802b3f:	56                   	push   %esi
  802b40:	53                   	push   %ebx
  802b41:	83 ec 1c             	sub    $0x1c,%esp
  802b44:	89 c7                	mov    %eax,%edi
  802b46:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802b48:	a1 24 54 80 00       	mov    0x805424,%eax
  802b4d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802b50:	83 ec 0c             	sub    $0xc,%esp
  802b53:	57                   	push   %edi
  802b54:	e8 08 04 00 00       	call   802f61 <pageref>
  802b59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802b5c:	89 34 24             	mov    %esi,(%esp)
  802b5f:	e8 fd 03 00 00       	call   802f61 <pageref>
		nn = thisenv->env_runs;
  802b64:	8b 15 24 54 80 00    	mov    0x805424,%edx
  802b6a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802b6d:	83 c4 10             	add    $0x10,%esp
  802b70:	39 cb                	cmp    %ecx,%ebx
  802b72:	74 1b                	je     802b8f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802b74:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802b77:	75 cf                	jne    802b48 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802b79:	8b 42 58             	mov    0x58(%edx),%eax
  802b7c:	6a 01                	push   $0x1
  802b7e:	50                   	push   %eax
  802b7f:	53                   	push   %ebx
  802b80:	68 63 39 80 00       	push   $0x803963
  802b85:	e8 cc df ff ff       	call   800b56 <cprintf>
  802b8a:	83 c4 10             	add    $0x10,%esp
  802b8d:	eb b9                	jmp    802b48 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802b8f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802b92:	0f 94 c0             	sete   %al
  802b95:	0f b6 c0             	movzbl %al,%eax
}
  802b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b9b:	5b                   	pop    %ebx
  802b9c:	5e                   	pop    %esi
  802b9d:	5f                   	pop    %edi
  802b9e:	5d                   	pop    %ebp
  802b9f:	c3                   	ret    

00802ba0 <devpipe_write>:
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
  802ba3:	57                   	push   %edi
  802ba4:	56                   	push   %esi
  802ba5:	53                   	push   %ebx
  802ba6:	83 ec 28             	sub    $0x28,%esp
  802ba9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802bac:	56                   	push   %esi
  802bad:	e8 05 f0 ff ff       	call   801bb7 <fd2data>
  802bb2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802bb4:	83 c4 10             	add    $0x10,%esp
  802bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  802bbc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802bbf:	74 4f                	je     802c10 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802bc1:	8b 43 04             	mov    0x4(%ebx),%eax
  802bc4:	8b 0b                	mov    (%ebx),%ecx
  802bc6:	8d 51 20             	lea    0x20(%ecx),%edx
  802bc9:	39 d0                	cmp    %edx,%eax
  802bcb:	72 14                	jb     802be1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802bcd:	89 da                	mov    %ebx,%edx
  802bcf:	89 f0                	mov    %esi,%eax
  802bd1:	e8 65 ff ff ff       	call   802b3b <_pipeisclosed>
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	75 3a                	jne    802c14 <devpipe_write+0x74>
			sys_yield();
  802bda:	e8 2b ea ff ff       	call   80160a <sys_yield>
  802bdf:	eb e0                	jmp    802bc1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802be1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802be4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802be8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802beb:	89 c2                	mov    %eax,%edx
  802bed:	c1 fa 1f             	sar    $0x1f,%edx
  802bf0:	89 d1                	mov    %edx,%ecx
  802bf2:	c1 e9 1b             	shr    $0x1b,%ecx
  802bf5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802bf8:	83 e2 1f             	and    $0x1f,%edx
  802bfb:	29 ca                	sub    %ecx,%edx
  802bfd:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802c01:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802c05:	83 c0 01             	add    $0x1,%eax
  802c08:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802c0b:	83 c7 01             	add    $0x1,%edi
  802c0e:	eb ac                	jmp    802bbc <devpipe_write+0x1c>
	return i;
  802c10:	89 f8                	mov    %edi,%eax
  802c12:	eb 05                	jmp    802c19 <devpipe_write+0x79>
				return 0;
  802c14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c1c:	5b                   	pop    %ebx
  802c1d:	5e                   	pop    %esi
  802c1e:	5f                   	pop    %edi
  802c1f:	5d                   	pop    %ebp
  802c20:	c3                   	ret    

00802c21 <devpipe_read>:
{
  802c21:	55                   	push   %ebp
  802c22:	89 e5                	mov    %esp,%ebp
  802c24:	57                   	push   %edi
  802c25:	56                   	push   %esi
  802c26:	53                   	push   %ebx
  802c27:	83 ec 18             	sub    $0x18,%esp
  802c2a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802c2d:	57                   	push   %edi
  802c2e:	e8 84 ef ff ff       	call   801bb7 <fd2data>
  802c33:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802c35:	83 c4 10             	add    $0x10,%esp
  802c38:	be 00 00 00 00       	mov    $0x0,%esi
  802c3d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802c40:	74 47                	je     802c89 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802c42:	8b 03                	mov    (%ebx),%eax
  802c44:	3b 43 04             	cmp    0x4(%ebx),%eax
  802c47:	75 22                	jne    802c6b <devpipe_read+0x4a>
			if (i > 0)
  802c49:	85 f6                	test   %esi,%esi
  802c4b:	75 14                	jne    802c61 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802c4d:	89 da                	mov    %ebx,%edx
  802c4f:	89 f8                	mov    %edi,%eax
  802c51:	e8 e5 fe ff ff       	call   802b3b <_pipeisclosed>
  802c56:	85 c0                	test   %eax,%eax
  802c58:	75 33                	jne    802c8d <devpipe_read+0x6c>
			sys_yield();
  802c5a:	e8 ab e9 ff ff       	call   80160a <sys_yield>
  802c5f:	eb e1                	jmp    802c42 <devpipe_read+0x21>
				return i;
  802c61:	89 f0                	mov    %esi,%eax
}
  802c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c66:	5b                   	pop    %ebx
  802c67:	5e                   	pop    %esi
  802c68:	5f                   	pop    %edi
  802c69:	5d                   	pop    %ebp
  802c6a:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802c6b:	99                   	cltd   
  802c6c:	c1 ea 1b             	shr    $0x1b,%edx
  802c6f:	01 d0                	add    %edx,%eax
  802c71:	83 e0 1f             	and    $0x1f,%eax
  802c74:	29 d0                	sub    %edx,%eax
  802c76:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802c7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c7e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802c81:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802c84:	83 c6 01             	add    $0x1,%esi
  802c87:	eb b4                	jmp    802c3d <devpipe_read+0x1c>
	return i;
  802c89:	89 f0                	mov    %esi,%eax
  802c8b:	eb d6                	jmp    802c63 <devpipe_read+0x42>
				return 0;
  802c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c92:	eb cf                	jmp    802c63 <devpipe_read+0x42>

00802c94 <pipe>:
{
  802c94:	55                   	push   %ebp
  802c95:	89 e5                	mov    %esp,%ebp
  802c97:	56                   	push   %esi
  802c98:	53                   	push   %ebx
  802c99:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802c9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c9f:	50                   	push   %eax
  802ca0:	e8 29 ef ff ff       	call   801bce <fd_alloc>
  802ca5:	89 c3                	mov    %eax,%ebx
  802ca7:	83 c4 10             	add    $0x10,%esp
  802caa:	85 c0                	test   %eax,%eax
  802cac:	78 5b                	js     802d09 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cae:	83 ec 04             	sub    $0x4,%esp
  802cb1:	68 07 04 00 00       	push   $0x407
  802cb6:	ff 75 f4             	pushl  -0xc(%ebp)
  802cb9:	6a 00                	push   $0x0
  802cbb:	e8 69 e9 ff ff       	call   801629 <sys_page_alloc>
  802cc0:	89 c3                	mov    %eax,%ebx
  802cc2:	83 c4 10             	add    $0x10,%esp
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	78 40                	js     802d09 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802cc9:	83 ec 0c             	sub    $0xc,%esp
  802ccc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ccf:	50                   	push   %eax
  802cd0:	e8 f9 ee ff ff       	call   801bce <fd_alloc>
  802cd5:	89 c3                	mov    %eax,%ebx
  802cd7:	83 c4 10             	add    $0x10,%esp
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	78 1b                	js     802cf9 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cde:	83 ec 04             	sub    $0x4,%esp
  802ce1:	68 07 04 00 00       	push   $0x407
  802ce6:	ff 75 f0             	pushl  -0x10(%ebp)
  802ce9:	6a 00                	push   $0x0
  802ceb:	e8 39 e9 ff ff       	call   801629 <sys_page_alloc>
  802cf0:	89 c3                	mov    %eax,%ebx
  802cf2:	83 c4 10             	add    $0x10,%esp
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	79 19                	jns    802d12 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802cf9:	83 ec 08             	sub    $0x8,%esp
  802cfc:	ff 75 f4             	pushl  -0xc(%ebp)
  802cff:	6a 00                	push   $0x0
  802d01:	e8 a8 e9 ff ff       	call   8016ae <sys_page_unmap>
  802d06:	83 c4 10             	add    $0x10,%esp
}
  802d09:	89 d8                	mov    %ebx,%eax
  802d0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d0e:	5b                   	pop    %ebx
  802d0f:	5e                   	pop    %esi
  802d10:	5d                   	pop    %ebp
  802d11:	c3                   	ret    
	va = fd2data(fd0);
  802d12:	83 ec 0c             	sub    $0xc,%esp
  802d15:	ff 75 f4             	pushl  -0xc(%ebp)
  802d18:	e8 9a ee ff ff       	call   801bb7 <fd2data>
  802d1d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d1f:	83 c4 0c             	add    $0xc,%esp
  802d22:	68 07 04 00 00       	push   $0x407
  802d27:	50                   	push   %eax
  802d28:	6a 00                	push   $0x0
  802d2a:	e8 fa e8 ff ff       	call   801629 <sys_page_alloc>
  802d2f:	89 c3                	mov    %eax,%ebx
  802d31:	83 c4 10             	add    $0x10,%esp
  802d34:	85 c0                	test   %eax,%eax
  802d36:	0f 88 8c 00 00 00    	js     802dc8 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d3c:	83 ec 0c             	sub    $0xc,%esp
  802d3f:	ff 75 f0             	pushl  -0x10(%ebp)
  802d42:	e8 70 ee ff ff       	call   801bb7 <fd2data>
  802d47:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802d4e:	50                   	push   %eax
  802d4f:	6a 00                	push   $0x0
  802d51:	56                   	push   %esi
  802d52:	6a 00                	push   $0x0
  802d54:	e8 13 e9 ff ff       	call   80166c <sys_page_map>
  802d59:	89 c3                	mov    %eax,%ebx
  802d5b:	83 c4 20             	add    $0x20,%esp
  802d5e:	85 c0                	test   %eax,%eax
  802d60:	78 58                	js     802dba <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802d6b:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7a:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802d80:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d85:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802d8c:	83 ec 0c             	sub    $0xc,%esp
  802d8f:	ff 75 f4             	pushl  -0xc(%ebp)
  802d92:	e8 10 ee ff ff       	call   801ba7 <fd2num>
  802d97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d9a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802d9c:	83 c4 04             	add    $0x4,%esp
  802d9f:	ff 75 f0             	pushl  -0x10(%ebp)
  802da2:	e8 00 ee ff ff       	call   801ba7 <fd2num>
  802da7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802daa:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802dad:	83 c4 10             	add    $0x10,%esp
  802db0:	bb 00 00 00 00       	mov    $0x0,%ebx
  802db5:	e9 4f ff ff ff       	jmp    802d09 <pipe+0x75>
	sys_page_unmap(0, va);
  802dba:	83 ec 08             	sub    $0x8,%esp
  802dbd:	56                   	push   %esi
  802dbe:	6a 00                	push   $0x0
  802dc0:	e8 e9 e8 ff ff       	call   8016ae <sys_page_unmap>
  802dc5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802dc8:	83 ec 08             	sub    $0x8,%esp
  802dcb:	ff 75 f0             	pushl  -0x10(%ebp)
  802dce:	6a 00                	push   $0x0
  802dd0:	e8 d9 e8 ff ff       	call   8016ae <sys_page_unmap>
  802dd5:	83 c4 10             	add    $0x10,%esp
  802dd8:	e9 1c ff ff ff       	jmp    802cf9 <pipe+0x65>

00802ddd <pipeisclosed>:
{
  802ddd:	55                   	push   %ebp
  802dde:	89 e5                	mov    %esp,%ebp
  802de0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802de3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802de6:	50                   	push   %eax
  802de7:	ff 75 08             	pushl  0x8(%ebp)
  802dea:	e8 2e ee ff ff       	call   801c1d <fd_lookup>
  802def:	83 c4 10             	add    $0x10,%esp
  802df2:	85 c0                	test   %eax,%eax
  802df4:	78 18                	js     802e0e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802df6:	83 ec 0c             	sub    $0xc,%esp
  802df9:	ff 75 f4             	pushl  -0xc(%ebp)
  802dfc:	e8 b6 ed ff ff       	call   801bb7 <fd2data>
	return _pipeisclosed(fd, p);
  802e01:	89 c2                	mov    %eax,%edx
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	e8 30 fd ff ff       	call   802b3b <_pipeisclosed>
  802e0b:	83 c4 10             	add    $0x10,%esp
}
  802e0e:	c9                   	leave  
  802e0f:	c3                   	ret    

00802e10 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802e10:	55                   	push   %ebp
  802e11:	89 e5                	mov    %esp,%ebp
  802e13:	56                   	push   %esi
  802e14:	53                   	push   %ebx
  802e15:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802e18:	85 f6                	test   %esi,%esi
  802e1a:	74 13                	je     802e2f <wait+0x1f>
	e = &envs[ENVX(envid)];
  802e1c:	89 f3                	mov    %esi,%ebx
  802e1e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802e24:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802e27:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802e2d:	eb 1b                	jmp    802e4a <wait+0x3a>
	assert(envid != 0);
  802e2f:	68 7b 39 80 00       	push   $0x80397b
  802e34:	68 1a 33 80 00       	push   $0x80331a
  802e39:	6a 09                	push   $0x9
  802e3b:	68 86 39 80 00       	push   $0x803986
  802e40:	e8 36 dc ff ff       	call   800a7b <_panic>
		sys_yield();
  802e45:	e8 c0 e7 ff ff       	call   80160a <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802e4a:	8b 43 48             	mov    0x48(%ebx),%eax
  802e4d:	39 f0                	cmp    %esi,%eax
  802e4f:	75 07                	jne    802e58 <wait+0x48>
  802e51:	8b 43 54             	mov    0x54(%ebx),%eax
  802e54:	85 c0                	test   %eax,%eax
  802e56:	75 ed                	jne    802e45 <wait+0x35>
}
  802e58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e5b:	5b                   	pop    %ebx
  802e5c:	5e                   	pop    %esi
  802e5d:	5d                   	pop    %ebp
  802e5e:	c3                   	ret    

00802e5f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802e5f:	55                   	push   %ebp
  802e60:	89 e5                	mov    %esp,%ebp
  802e62:	53                   	push   %ebx
  802e63:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  802e66:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802e6d:	74 0d                	je     802e7c <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802e77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e7a:	c9                   	leave  
  802e7b:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  802e7c:	e8 6a e7 ff ff       	call   8015eb <sys_getenvid>
  802e81:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  802e83:	83 ec 04             	sub    $0x4,%esp
  802e86:	6a 07                	push   $0x7
  802e88:	68 00 f0 bf ee       	push   $0xeebff000
  802e8d:	50                   	push   %eax
  802e8e:	e8 96 e7 ff ff       	call   801629 <sys_page_alloc>
        	if (r < 0) {
  802e93:	83 c4 10             	add    $0x10,%esp
  802e96:	85 c0                	test   %eax,%eax
  802e98:	78 27                	js     802ec1 <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  802e9a:	83 ec 08             	sub    $0x8,%esp
  802e9d:	68 d3 2e 80 00       	push   $0x802ed3
  802ea2:	53                   	push   %ebx
  802ea3:	e8 cc e8 ff ff       	call   801774 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  802ea8:	83 c4 10             	add    $0x10,%esp
  802eab:	85 c0                	test   %eax,%eax
  802ead:	79 c0                	jns    802e6f <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  802eaf:	50                   	push   %eax
  802eb0:	68 91 39 80 00       	push   $0x803991
  802eb5:	6a 28                	push   $0x28
  802eb7:	68 a5 39 80 00       	push   $0x8039a5
  802ebc:	e8 ba db ff ff       	call   800a7b <_panic>
            		panic("pgfault_handler: %e", r);
  802ec1:	50                   	push   %eax
  802ec2:	68 91 39 80 00       	push   $0x803991
  802ec7:	6a 24                	push   $0x24
  802ec9:	68 a5 39 80 00       	push   $0x8039a5
  802ece:	e8 a8 db ff ff       	call   800a7b <_panic>

00802ed3 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802ed3:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802ed4:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802ed9:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802edb:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  802ede:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  802ee2:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  802ee5:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  802ee9:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  802eed:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  802ef0:	83 c4 08             	add    $0x8,%esp
	popal
  802ef3:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  802ef4:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  802ef7:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  802ef8:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  802ef9:	c3                   	ret    

00802efa <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802efa:	55                   	push   %ebp
  802efb:	89 e5                	mov    %esp,%ebp
  802efd:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  802f00:	68 b3 39 80 00       	push   $0x8039b3
  802f05:	6a 1a                	push   $0x1a
  802f07:	68 cc 39 80 00       	push   $0x8039cc
  802f0c:	e8 6a db ff ff       	call   800a7b <_panic>

00802f11 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802f11:	55                   	push   %ebp
  802f12:	89 e5                	mov    %esp,%ebp
  802f14:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  802f17:	68 d6 39 80 00       	push   $0x8039d6
  802f1c:	6a 2a                	push   $0x2a
  802f1e:	68 cc 39 80 00       	push   $0x8039cc
  802f23:	e8 53 db ff ff       	call   800a7b <_panic>

00802f28 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802f28:	55                   	push   %ebp
  802f29:	89 e5                	mov    %esp,%ebp
  802f2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802f2e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802f33:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802f36:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802f3c:	8b 52 50             	mov    0x50(%edx),%edx
  802f3f:	39 ca                	cmp    %ecx,%edx
  802f41:	74 11                	je     802f54 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802f43:	83 c0 01             	add    $0x1,%eax
  802f46:	3d 00 04 00 00       	cmp    $0x400,%eax
  802f4b:	75 e6                	jne    802f33 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f52:	eb 0b                	jmp    802f5f <ipc_find_env+0x37>
			return envs[i].env_id;
  802f54:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802f57:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802f5c:	8b 40 48             	mov    0x48(%eax),%eax
}
  802f5f:	5d                   	pop    %ebp
  802f60:	c3                   	ret    

00802f61 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802f61:	55                   	push   %ebp
  802f62:	89 e5                	mov    %esp,%ebp
  802f64:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802f67:	89 d0                	mov    %edx,%eax
  802f69:	c1 e8 16             	shr    $0x16,%eax
  802f6c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802f73:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802f78:	f6 c1 01             	test   $0x1,%cl
  802f7b:	74 1d                	je     802f9a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802f7d:	c1 ea 0c             	shr    $0xc,%edx
  802f80:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802f87:	f6 c2 01             	test   $0x1,%dl
  802f8a:	74 0e                	je     802f9a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802f8c:	c1 ea 0c             	shr    $0xc,%edx
  802f8f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802f96:	ef 
  802f97:	0f b7 c0             	movzwl %ax,%eax
}
  802f9a:	5d                   	pop    %ebp
  802f9b:	c3                   	ret    
  802f9c:	66 90                	xchg   %ax,%ax
  802f9e:	66 90                	xchg   %ax,%ax

00802fa0 <__udivdi3>:
  802fa0:	55                   	push   %ebp
  802fa1:	57                   	push   %edi
  802fa2:	56                   	push   %esi
  802fa3:	53                   	push   %ebx
  802fa4:	83 ec 1c             	sub    $0x1c,%esp
  802fa7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802fab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802faf:	8b 74 24 34          	mov    0x34(%esp),%esi
  802fb3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802fb7:	85 d2                	test   %edx,%edx
  802fb9:	75 35                	jne    802ff0 <__udivdi3+0x50>
  802fbb:	39 f3                	cmp    %esi,%ebx
  802fbd:	0f 87 bd 00 00 00    	ja     803080 <__udivdi3+0xe0>
  802fc3:	85 db                	test   %ebx,%ebx
  802fc5:	89 d9                	mov    %ebx,%ecx
  802fc7:	75 0b                	jne    802fd4 <__udivdi3+0x34>
  802fc9:	b8 01 00 00 00       	mov    $0x1,%eax
  802fce:	31 d2                	xor    %edx,%edx
  802fd0:	f7 f3                	div    %ebx
  802fd2:	89 c1                	mov    %eax,%ecx
  802fd4:	31 d2                	xor    %edx,%edx
  802fd6:	89 f0                	mov    %esi,%eax
  802fd8:	f7 f1                	div    %ecx
  802fda:	89 c6                	mov    %eax,%esi
  802fdc:	89 e8                	mov    %ebp,%eax
  802fde:	89 f7                	mov    %esi,%edi
  802fe0:	f7 f1                	div    %ecx
  802fe2:	89 fa                	mov    %edi,%edx
  802fe4:	83 c4 1c             	add    $0x1c,%esp
  802fe7:	5b                   	pop    %ebx
  802fe8:	5e                   	pop    %esi
  802fe9:	5f                   	pop    %edi
  802fea:	5d                   	pop    %ebp
  802feb:	c3                   	ret    
  802fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ff0:	39 f2                	cmp    %esi,%edx
  802ff2:	77 7c                	ja     803070 <__udivdi3+0xd0>
  802ff4:	0f bd fa             	bsr    %edx,%edi
  802ff7:	83 f7 1f             	xor    $0x1f,%edi
  802ffa:	0f 84 98 00 00 00    	je     803098 <__udivdi3+0xf8>
  803000:	89 f9                	mov    %edi,%ecx
  803002:	b8 20 00 00 00       	mov    $0x20,%eax
  803007:	29 f8                	sub    %edi,%eax
  803009:	d3 e2                	shl    %cl,%edx
  80300b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80300f:	89 c1                	mov    %eax,%ecx
  803011:	89 da                	mov    %ebx,%edx
  803013:	d3 ea                	shr    %cl,%edx
  803015:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803019:	09 d1                	or     %edx,%ecx
  80301b:	89 f2                	mov    %esi,%edx
  80301d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803021:	89 f9                	mov    %edi,%ecx
  803023:	d3 e3                	shl    %cl,%ebx
  803025:	89 c1                	mov    %eax,%ecx
  803027:	d3 ea                	shr    %cl,%edx
  803029:	89 f9                	mov    %edi,%ecx
  80302b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80302f:	d3 e6                	shl    %cl,%esi
  803031:	89 eb                	mov    %ebp,%ebx
  803033:	89 c1                	mov    %eax,%ecx
  803035:	d3 eb                	shr    %cl,%ebx
  803037:	09 de                	or     %ebx,%esi
  803039:	89 f0                	mov    %esi,%eax
  80303b:	f7 74 24 08          	divl   0x8(%esp)
  80303f:	89 d6                	mov    %edx,%esi
  803041:	89 c3                	mov    %eax,%ebx
  803043:	f7 64 24 0c          	mull   0xc(%esp)
  803047:	39 d6                	cmp    %edx,%esi
  803049:	72 0c                	jb     803057 <__udivdi3+0xb7>
  80304b:	89 f9                	mov    %edi,%ecx
  80304d:	d3 e5                	shl    %cl,%ebp
  80304f:	39 c5                	cmp    %eax,%ebp
  803051:	73 5d                	jae    8030b0 <__udivdi3+0x110>
  803053:	39 d6                	cmp    %edx,%esi
  803055:	75 59                	jne    8030b0 <__udivdi3+0x110>
  803057:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80305a:	31 ff                	xor    %edi,%edi
  80305c:	89 fa                	mov    %edi,%edx
  80305e:	83 c4 1c             	add    $0x1c,%esp
  803061:	5b                   	pop    %ebx
  803062:	5e                   	pop    %esi
  803063:	5f                   	pop    %edi
  803064:	5d                   	pop    %ebp
  803065:	c3                   	ret    
  803066:	8d 76 00             	lea    0x0(%esi),%esi
  803069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  803070:	31 ff                	xor    %edi,%edi
  803072:	31 c0                	xor    %eax,%eax
  803074:	89 fa                	mov    %edi,%edx
  803076:	83 c4 1c             	add    $0x1c,%esp
  803079:	5b                   	pop    %ebx
  80307a:	5e                   	pop    %esi
  80307b:	5f                   	pop    %edi
  80307c:	5d                   	pop    %ebp
  80307d:	c3                   	ret    
  80307e:	66 90                	xchg   %ax,%ax
  803080:	31 ff                	xor    %edi,%edi
  803082:	89 e8                	mov    %ebp,%eax
  803084:	89 f2                	mov    %esi,%edx
  803086:	f7 f3                	div    %ebx
  803088:	89 fa                	mov    %edi,%edx
  80308a:	83 c4 1c             	add    $0x1c,%esp
  80308d:	5b                   	pop    %ebx
  80308e:	5e                   	pop    %esi
  80308f:	5f                   	pop    %edi
  803090:	5d                   	pop    %ebp
  803091:	c3                   	ret    
  803092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803098:	39 f2                	cmp    %esi,%edx
  80309a:	72 06                	jb     8030a2 <__udivdi3+0x102>
  80309c:	31 c0                	xor    %eax,%eax
  80309e:	39 eb                	cmp    %ebp,%ebx
  8030a0:	77 d2                	ja     803074 <__udivdi3+0xd4>
  8030a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a7:	eb cb                	jmp    803074 <__udivdi3+0xd4>
  8030a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030b0:	89 d8                	mov    %ebx,%eax
  8030b2:	31 ff                	xor    %edi,%edi
  8030b4:	eb be                	jmp    803074 <__udivdi3+0xd4>
  8030b6:	66 90                	xchg   %ax,%ax
  8030b8:	66 90                	xchg   %ax,%ax
  8030ba:	66 90                	xchg   %ax,%ax
  8030bc:	66 90                	xchg   %ax,%ax
  8030be:	66 90                	xchg   %ax,%ax

008030c0 <__umoddi3>:
  8030c0:	55                   	push   %ebp
  8030c1:	57                   	push   %edi
  8030c2:	56                   	push   %esi
  8030c3:	53                   	push   %ebx
  8030c4:	83 ec 1c             	sub    $0x1c,%esp
  8030c7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8030cb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8030cf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8030d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030d7:	85 ed                	test   %ebp,%ebp
  8030d9:	89 f0                	mov    %esi,%eax
  8030db:	89 da                	mov    %ebx,%edx
  8030dd:	75 19                	jne    8030f8 <__umoddi3+0x38>
  8030df:	39 df                	cmp    %ebx,%edi
  8030e1:	0f 86 b1 00 00 00    	jbe    803198 <__umoddi3+0xd8>
  8030e7:	f7 f7                	div    %edi
  8030e9:	89 d0                	mov    %edx,%eax
  8030eb:	31 d2                	xor    %edx,%edx
  8030ed:	83 c4 1c             	add    $0x1c,%esp
  8030f0:	5b                   	pop    %ebx
  8030f1:	5e                   	pop    %esi
  8030f2:	5f                   	pop    %edi
  8030f3:	5d                   	pop    %ebp
  8030f4:	c3                   	ret    
  8030f5:	8d 76 00             	lea    0x0(%esi),%esi
  8030f8:	39 dd                	cmp    %ebx,%ebp
  8030fa:	77 f1                	ja     8030ed <__umoddi3+0x2d>
  8030fc:	0f bd cd             	bsr    %ebp,%ecx
  8030ff:	83 f1 1f             	xor    $0x1f,%ecx
  803102:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803106:	0f 84 b4 00 00 00    	je     8031c0 <__umoddi3+0x100>
  80310c:	b8 20 00 00 00       	mov    $0x20,%eax
  803111:	89 c2                	mov    %eax,%edx
  803113:	8b 44 24 04          	mov    0x4(%esp),%eax
  803117:	29 c2                	sub    %eax,%edx
  803119:	89 c1                	mov    %eax,%ecx
  80311b:	89 f8                	mov    %edi,%eax
  80311d:	d3 e5                	shl    %cl,%ebp
  80311f:	89 d1                	mov    %edx,%ecx
  803121:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803125:	d3 e8                	shr    %cl,%eax
  803127:	09 c5                	or     %eax,%ebp
  803129:	8b 44 24 04          	mov    0x4(%esp),%eax
  80312d:	89 c1                	mov    %eax,%ecx
  80312f:	d3 e7                	shl    %cl,%edi
  803131:	89 d1                	mov    %edx,%ecx
  803133:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803137:	89 df                	mov    %ebx,%edi
  803139:	d3 ef                	shr    %cl,%edi
  80313b:	89 c1                	mov    %eax,%ecx
  80313d:	89 f0                	mov    %esi,%eax
  80313f:	d3 e3                	shl    %cl,%ebx
  803141:	89 d1                	mov    %edx,%ecx
  803143:	89 fa                	mov    %edi,%edx
  803145:	d3 e8                	shr    %cl,%eax
  803147:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80314c:	09 d8                	or     %ebx,%eax
  80314e:	f7 f5                	div    %ebp
  803150:	d3 e6                	shl    %cl,%esi
  803152:	89 d1                	mov    %edx,%ecx
  803154:	f7 64 24 08          	mull   0x8(%esp)
  803158:	39 d1                	cmp    %edx,%ecx
  80315a:	89 c3                	mov    %eax,%ebx
  80315c:	89 d7                	mov    %edx,%edi
  80315e:	72 06                	jb     803166 <__umoddi3+0xa6>
  803160:	75 0e                	jne    803170 <__umoddi3+0xb0>
  803162:	39 c6                	cmp    %eax,%esi
  803164:	73 0a                	jae    803170 <__umoddi3+0xb0>
  803166:	2b 44 24 08          	sub    0x8(%esp),%eax
  80316a:	19 ea                	sbb    %ebp,%edx
  80316c:	89 d7                	mov    %edx,%edi
  80316e:	89 c3                	mov    %eax,%ebx
  803170:	89 ca                	mov    %ecx,%edx
  803172:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  803177:	29 de                	sub    %ebx,%esi
  803179:	19 fa                	sbb    %edi,%edx
  80317b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80317f:	89 d0                	mov    %edx,%eax
  803181:	d3 e0                	shl    %cl,%eax
  803183:	89 d9                	mov    %ebx,%ecx
  803185:	d3 ee                	shr    %cl,%esi
  803187:	d3 ea                	shr    %cl,%edx
  803189:	09 f0                	or     %esi,%eax
  80318b:	83 c4 1c             	add    $0x1c,%esp
  80318e:	5b                   	pop    %ebx
  80318f:	5e                   	pop    %esi
  803190:	5f                   	pop    %edi
  803191:	5d                   	pop    %ebp
  803192:	c3                   	ret    
  803193:	90                   	nop
  803194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803198:	85 ff                	test   %edi,%edi
  80319a:	89 f9                	mov    %edi,%ecx
  80319c:	75 0b                	jne    8031a9 <__umoddi3+0xe9>
  80319e:	b8 01 00 00 00       	mov    $0x1,%eax
  8031a3:	31 d2                	xor    %edx,%edx
  8031a5:	f7 f7                	div    %edi
  8031a7:	89 c1                	mov    %eax,%ecx
  8031a9:	89 d8                	mov    %ebx,%eax
  8031ab:	31 d2                	xor    %edx,%edx
  8031ad:	f7 f1                	div    %ecx
  8031af:	89 f0                	mov    %esi,%eax
  8031b1:	f7 f1                	div    %ecx
  8031b3:	e9 31 ff ff ff       	jmp    8030e9 <__umoddi3+0x29>
  8031b8:	90                   	nop
  8031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8031c0:	39 dd                	cmp    %ebx,%ebp
  8031c2:	72 08                	jb     8031cc <__umoddi3+0x10c>
  8031c4:	39 f7                	cmp    %esi,%edi
  8031c6:	0f 87 21 ff ff ff    	ja     8030ed <__umoddi3+0x2d>
  8031cc:	89 da                	mov    %ebx,%edx
  8031ce:	89 f0                	mov    %esi,%eax
  8031d0:	29 f8                	sub    %edi,%eax
  8031d2:	19 ea                	sbb    %ebp,%edx
  8031d4:	e9 14 ff ff ff       	jmp    8030ed <__umoddi3+0x2d>
