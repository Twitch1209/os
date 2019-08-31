
obj/user/faultregs.debug：     文件格式 elf32-i386


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
  80002c:	e8 ae 05 00 00       	call   8005df <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 71 23 80 00       	push   $0x802371
  800049:	68 40 23 80 00       	push   $0x802340
  80004e:	e8 c7 06 00 00       	call   80071a <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 50 23 80 00       	push   $0x802350
  80005c:	68 54 23 80 00       	push   $0x802354
  800061:	e8 b4 06 00 00       	call   80071a <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 31 02 00 00    	je     8002a4 <check_regs+0x271>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 68 23 80 00       	push   $0x802368
  80007b:	e8 9a 06 00 00       	call   80071a <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 72 23 80 00       	push   $0x802372
  800093:	68 54 23 80 00       	push   $0x802354
  800098:	e8 7d 06 00 00       	call   80071a <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 12 02 00 00    	je     8002be <check_regs+0x28b>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 68 23 80 00       	push   $0x802368
  8000b4:	e8 61 06 00 00       	call   80071a <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 76 23 80 00       	push   $0x802376
  8000cc:	68 54 23 80 00       	push   $0x802354
  8000d1:	e8 44 06 00 00       	call   80071a <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 ee 01 00 00    	je     8002d3 <check_regs+0x2a0>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 68 23 80 00       	push   $0x802368
  8000ed:	e8 28 06 00 00       	call   80071a <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 7a 23 80 00       	push   $0x80237a
  800105:	68 54 23 80 00       	push   $0x802354
  80010a:	e8 0b 06 00 00       	call   80071a <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 ca 01 00 00    	je     8002e8 <check_regs+0x2b5>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 68 23 80 00       	push   $0x802368
  800126:	e8 ef 05 00 00       	call   80071a <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 7e 23 80 00       	push   $0x80237e
  80013e:	68 54 23 80 00       	push   $0x802354
  800143:	e8 d2 05 00 00       	call   80071a <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a6 01 00 00    	je     8002fd <check_regs+0x2ca>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 68 23 80 00       	push   $0x802368
  80015f:	e8 b6 05 00 00       	call   80071a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 82 23 80 00       	push   $0x802382
  800177:	68 54 23 80 00       	push   $0x802354
  80017c:	e8 99 05 00 00       	call   80071a <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 82 01 00 00    	je     800312 <check_regs+0x2df>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 68 23 80 00       	push   $0x802368
  800198:	e8 7d 05 00 00       	call   80071a <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 86 23 80 00       	push   $0x802386
  8001b0:	68 54 23 80 00       	push   $0x802354
  8001b5:	e8 60 05 00 00       	call   80071a <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5e 01 00 00    	je     800327 <check_regs+0x2f4>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 68 23 80 00       	push   $0x802368
  8001d1:	e8 44 05 00 00       	call   80071a <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 8a 23 80 00       	push   $0x80238a
  8001e9:	68 54 23 80 00       	push   $0x802354
  8001ee:	e8 27 05 00 00       	call   80071a <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 3a 01 00 00    	je     80033c <check_regs+0x309>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 68 23 80 00       	push   $0x802368
  80020a:	e8 0b 05 00 00       	call   80071a <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 8e 23 80 00       	push   $0x80238e
  800222:	68 54 23 80 00       	push   $0x802354
  800227:	e8 ee 04 00 00       	call   80071a <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 16 01 00 00    	je     800351 <check_regs+0x31e>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 68 23 80 00       	push   $0x802368
  800243:	e8 d2 04 00 00       	call   80071a <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 95 23 80 00       	push   $0x802395
  800253:	68 54 23 80 00       	push   $0x802354
  800258:	e8 bd 04 00 00       	call   80071a <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 68 23 80 00       	push   $0x802368
  800274:	e8 a1 04 00 00       	call   80071a <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 99 23 80 00       	push   $0x802399
  800284:	e8 91 04 00 00       	call   80071a <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 68 23 80 00       	push   $0x802368
  800294:	e8 81 04 00 00       	call   80071a <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    
	CHECK(edi, regs.reg_edi);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 64 23 80 00       	push   $0x802364
  8002ac:	e8 69 04 00 00       	call   80071a <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b9:	e9 ca fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 64 23 80 00       	push   $0x802364
  8002c6:	e8 4f 04 00 00       	call   80071a <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	e9 ee fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	68 64 23 80 00       	push   $0x802364
  8002db:	e8 3a 04 00 00       	call   80071a <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
  8002e3:	e9 12 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e8:	83 ec 0c             	sub    $0xc,%esp
  8002eb:	68 64 23 80 00       	push   $0x802364
  8002f0:	e8 25 04 00 00       	call   80071a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	e9 36 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fd:	83 ec 0c             	sub    $0xc,%esp
  800300:	68 64 23 80 00       	push   $0x802364
  800305:	e8 10 04 00 00       	call   80071a <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	e9 5a fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  800312:	83 ec 0c             	sub    $0xc,%esp
  800315:	68 64 23 80 00       	push   $0x802364
  80031a:	e8 fb 03 00 00       	call   80071a <cprintf>
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	e9 7e fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	68 64 23 80 00       	push   $0x802364
  80032f:	e8 e6 03 00 00       	call   80071a <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	e9 a2 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	68 64 23 80 00       	push   $0x802364
  800344:	e8 d1 03 00 00       	call   80071a <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	e9 c6 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  800351:	83 ec 0c             	sub    $0xc,%esp
  800354:	68 64 23 80 00       	push   $0x802364
  800359:	e8 bc 03 00 00       	call   80071a <cprintf>
	CHECK(esp, esp);
  80035e:	ff 73 28             	pushl  0x28(%ebx)
  800361:	ff 76 28             	pushl  0x28(%esi)
  800364:	68 95 23 80 00       	push   $0x802395
  800369:	68 54 23 80 00       	push   $0x802354
  80036e:	e8 a7 03 00 00       	call   80071a <cprintf>
  800373:	83 c4 20             	add    $0x20,%esp
  800376:	8b 43 28             	mov    0x28(%ebx),%eax
  800379:	39 46 28             	cmp    %eax,0x28(%esi)
  80037c:	0f 85 ea fe ff ff    	jne    80026c <check_regs+0x239>
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 64 23 80 00       	push   $0x802364
  80038a:	e8 8b 03 00 00       	call   80071a <cprintf>
	cprintf("Registers %s ", testname);
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	ff 75 0c             	pushl  0xc(%ebp)
  800395:	68 99 23 80 00       	push   $0x802399
  80039a:	e8 7b 03 00 00       	call   80071a <cprintf>
	if (!mismatch)
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	85 ff                	test   %edi,%edi
  8003a4:	0f 85 e2 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	68 64 23 80 00       	push   $0x802364
  8003b2:	e8 63 03 00 00       	call   80071a <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
  8003ba:	e9 dd fe ff ff       	jmp    80029c <check_regs+0x269>
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 64 23 80 00       	push   $0x802364
  8003c7:	e8 4e 03 00 00       	call   80071a <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 99 23 80 00       	push   $0x802399
  8003d7:	e8 3e 03 00 00       	call   80071a <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003ed:	8b 10                	mov    (%eax),%edx
  8003ef:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f5:	0f 85 a3 00 00 00    	jne    80049e <pgfault+0xba>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003fb:	8b 50 08             	mov    0x8(%eax),%edx
  8003fe:	89 15 40 40 80 00    	mov    %edx,0x804040
  800404:	8b 50 0c             	mov    0xc(%eax),%edx
  800407:	89 15 44 40 80 00    	mov    %edx,0x804044
  80040d:	8b 50 10             	mov    0x10(%eax),%edx
  800410:	89 15 48 40 80 00    	mov    %edx,0x804048
  800416:	8b 50 14             	mov    0x14(%eax),%edx
  800419:	89 15 4c 40 80 00    	mov    %edx,0x80404c
  80041f:	8b 50 18             	mov    0x18(%eax),%edx
  800422:	89 15 50 40 80 00    	mov    %edx,0x804050
  800428:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042b:	89 15 54 40 80 00    	mov    %edx,0x804054
  800431:	8b 50 20             	mov    0x20(%eax),%edx
  800434:	89 15 58 40 80 00    	mov    %edx,0x804058
  80043a:	8b 50 24             	mov    0x24(%eax),%edx
  80043d:	89 15 5c 40 80 00    	mov    %edx,0x80405c
	during.eip = utf->utf_eip;
  800443:	8b 50 28             	mov    0x28(%eax),%edx
  800446:	89 15 60 40 80 00    	mov    %edx,0x804060
	during.eflags = utf->utf_eflags & ~FL_RF;
  80044c:	8b 50 2c             	mov    0x2c(%eax),%edx
  80044f:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800455:	89 15 64 40 80 00    	mov    %edx,0x804064
	during.esp = utf->utf_esp;
  80045b:	8b 40 30             	mov    0x30(%eax),%eax
  80045e:	a3 68 40 80 00       	mov    %eax,0x804068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	68 bf 23 80 00       	push   $0x8023bf
  80046b:	68 cd 23 80 00       	push   $0x8023cd
  800470:	b9 40 40 80 00       	mov    $0x804040,%ecx
  800475:	ba b8 23 80 00       	mov    $0x8023b8,%edx
  80047a:	b8 80 40 80 00       	mov    $0x804080,%eax
  80047f:	e8 af fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800484:	83 c4 0c             	add    $0xc,%esp
  800487:	6a 07                	push   $0x7
  800489:	68 00 00 40 00       	push   $0x400000
  80048e:	6a 00                	push   $0x0
  800490:	e8 68 0c 00 00       	call   8010fd <sys_page_alloc>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	85 c0                	test   %eax,%eax
  80049a:	78 1a                	js     8004b6 <pgfault+0xd2>
		panic("sys_page_alloc: %e", r);
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	ff 70 28             	pushl  0x28(%eax)
  8004a4:	52                   	push   %edx
  8004a5:	68 00 24 80 00       	push   $0x802400
  8004aa:	6a 51                	push   $0x51
  8004ac:	68 a7 23 80 00       	push   $0x8023a7
  8004b1:	e8 89 01 00 00       	call   80063f <_panic>
		panic("sys_page_alloc: %e", r);
  8004b6:	50                   	push   %eax
  8004b7:	68 d4 23 80 00       	push   $0x8023d4
  8004bc:	6a 5c                	push   $0x5c
  8004be:	68 a7 23 80 00       	push   $0x8023a7
  8004c3:	e8 77 01 00 00       	call   80063f <_panic>

008004c8 <umain>:

void
umain(int argc, char **argv)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004ce:	68 e4 03 80 00       	push   $0x8003e4
  8004d3:	e8 16 0e 00 00       	call   8012ee <set_pgfault_handler>

	asm volatile(
  8004d8:	50                   	push   %eax
  8004d9:	9c                   	pushf  
  8004da:	58                   	pop    %eax
  8004db:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e0:	50                   	push   %eax
  8004e1:	9d                   	popf   
  8004e2:	a3 a4 40 80 00       	mov    %eax,0x8040a4
  8004e7:	8d 05 22 05 80 00    	lea    0x800522,%eax
  8004ed:	a3 a0 40 80 00       	mov    %eax,0x8040a0
  8004f2:	58                   	pop    %eax
  8004f3:	89 3d 80 40 80 00    	mov    %edi,0x804080
  8004f9:	89 35 84 40 80 00    	mov    %esi,0x804084
  8004ff:	89 2d 88 40 80 00    	mov    %ebp,0x804088
  800505:	89 1d 90 40 80 00    	mov    %ebx,0x804090
  80050b:	89 15 94 40 80 00    	mov    %edx,0x804094
  800511:	89 0d 98 40 80 00    	mov    %ecx,0x804098
  800517:	a3 9c 40 80 00       	mov    %eax,0x80409c
  80051c:	89 25 a8 40 80 00    	mov    %esp,0x8040a8
  800522:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800529:	00 00 00 
  80052c:	89 3d 00 40 80 00    	mov    %edi,0x804000
  800532:	89 35 04 40 80 00    	mov    %esi,0x804004
  800538:	89 2d 08 40 80 00    	mov    %ebp,0x804008
  80053e:	89 1d 10 40 80 00    	mov    %ebx,0x804010
  800544:	89 15 14 40 80 00    	mov    %edx,0x804014
  80054a:	89 0d 18 40 80 00    	mov    %ecx,0x804018
  800550:	a3 1c 40 80 00       	mov    %eax,0x80401c
  800555:	89 25 28 40 80 00    	mov    %esp,0x804028
  80055b:	8b 3d 80 40 80 00    	mov    0x804080,%edi
  800561:	8b 35 84 40 80 00    	mov    0x804084,%esi
  800567:	8b 2d 88 40 80 00    	mov    0x804088,%ebp
  80056d:	8b 1d 90 40 80 00    	mov    0x804090,%ebx
  800573:	8b 15 94 40 80 00    	mov    0x804094,%edx
  800579:	8b 0d 98 40 80 00    	mov    0x804098,%ecx
  80057f:	a1 9c 40 80 00       	mov    0x80409c,%eax
  800584:	8b 25 a8 40 80 00    	mov    0x8040a8,%esp
  80058a:	50                   	push   %eax
  80058b:	9c                   	pushf  
  80058c:	58                   	pop    %eax
  80058d:	a3 24 40 80 00       	mov    %eax,0x804024
  800592:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  80059d:	74 10                	je     8005af <umain+0xe7>
		cprintf("EIP after page-fault MISMATCH\n");
  80059f:	83 ec 0c             	sub    $0xc,%esp
  8005a2:	68 34 24 80 00       	push   $0x802434
  8005a7:	e8 6e 01 00 00       	call   80071a <cprintf>
  8005ac:	83 c4 10             	add    $0x10,%esp
	after.eip = before.eip;
  8005af:	a1 a0 40 80 00       	mov    0x8040a0,%eax
  8005b4:	a3 20 40 80 00       	mov    %eax,0x804020

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	68 e7 23 80 00       	push   $0x8023e7
  8005c1:	68 f8 23 80 00       	push   $0x8023f8
  8005c6:	b9 00 40 80 00       	mov    $0x804000,%ecx
  8005cb:	ba b8 23 80 00       	mov    $0x8023b8,%edx
  8005d0:	b8 80 40 80 00       	mov    $0x804080,%eax
  8005d5:	e8 59 fa ff ff       	call   800033 <check_regs>
}
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	56                   	push   %esi
  8005e3:	53                   	push   %ebx
  8005e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005e7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005ea:	e8 d0 0a 00 00       	call   8010bf <sys_getenvid>
  8005ef:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005f4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005f7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005fc:	a3 b0 40 80 00       	mov    %eax,0x8040b0

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800601:	85 db                	test   %ebx,%ebx
  800603:	7e 07                	jle    80060c <libmain+0x2d>
		binaryname = argv[0];
  800605:	8b 06                	mov    (%esi),%eax
  800607:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80060c:	83 ec 08             	sub    $0x8,%esp
  80060f:	56                   	push   %esi
  800610:	53                   	push   %ebx
  800611:	e8 b2 fe ff ff       	call   8004c8 <umain>

	// exit gracefully
	exit();
  800616:	e8 0a 00 00 00       	call   800625 <exit>
}
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800621:	5b                   	pop    %ebx
  800622:	5e                   	pop    %esi
  800623:	5d                   	pop    %ebp
  800624:	c3                   	ret    

00800625 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800625:	55                   	push   %ebp
  800626:	89 e5                	mov    %esp,%ebp
  800628:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80062b:	e8 2f 0f 00 00       	call   80155f <close_all>
	sys_env_destroy(0);
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	6a 00                	push   $0x0
  800635:	e8 44 0a 00 00       	call   80107e <sys_env_destroy>
}
  80063a:	83 c4 10             	add    $0x10,%esp
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
  800642:	56                   	push   %esi
  800643:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800644:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800647:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80064d:	e8 6d 0a 00 00       	call   8010bf <sys_getenvid>
  800652:	83 ec 0c             	sub    $0xc,%esp
  800655:	ff 75 0c             	pushl  0xc(%ebp)
  800658:	ff 75 08             	pushl  0x8(%ebp)
  80065b:	56                   	push   %esi
  80065c:	50                   	push   %eax
  80065d:	68 60 24 80 00       	push   $0x802460
  800662:	e8 b3 00 00 00       	call   80071a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800667:	83 c4 18             	add    $0x18,%esp
  80066a:	53                   	push   %ebx
  80066b:	ff 75 10             	pushl  0x10(%ebp)
  80066e:	e8 56 00 00 00       	call   8006c9 <vcprintf>
	cprintf("\n");
  800673:	c7 04 24 70 23 80 00 	movl   $0x802370,(%esp)
  80067a:	e8 9b 00 00 00       	call   80071a <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800682:	cc                   	int3   
  800683:	eb fd                	jmp    800682 <_panic+0x43>

00800685 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	53                   	push   %ebx
  800689:	83 ec 04             	sub    $0x4,%esp
  80068c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80068f:	8b 13                	mov    (%ebx),%edx
  800691:	8d 42 01             	lea    0x1(%edx),%eax
  800694:	89 03                	mov    %eax,(%ebx)
  800696:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800699:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80069d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a2:	74 09                	je     8006ad <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006a4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ab:	c9                   	leave  
  8006ac:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	68 ff 00 00 00       	push   $0xff
  8006b5:	8d 43 08             	lea    0x8(%ebx),%eax
  8006b8:	50                   	push   %eax
  8006b9:	e8 83 09 00 00       	call   801041 <sys_cputs>
		b->idx = 0;
  8006be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	eb db                	jmp    8006a4 <putch+0x1f>

008006c9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006c9:	55                   	push   %ebp
  8006ca:	89 e5                	mov    %esp,%ebp
  8006cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d9:	00 00 00 
	b.cnt = 0;
  8006dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f2:	50                   	push   %eax
  8006f3:	68 85 06 80 00       	push   $0x800685
  8006f8:	e8 1a 01 00 00       	call   800817 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006fd:	83 c4 08             	add    $0x8,%esp
  800700:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800706:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80070c:	50                   	push   %eax
  80070d:	e8 2f 09 00 00       	call   801041 <sys_cputs>

	return b.cnt;
}
  800712:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800720:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800723:	50                   	push   %eax
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	e8 9d ff ff ff       	call   8006c9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    

0080072e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80072e:	55                   	push   %ebp
  80072f:	89 e5                	mov    %esp,%ebp
  800731:	57                   	push   %edi
  800732:	56                   	push   %esi
  800733:	53                   	push   %ebx
  800734:	83 ec 1c             	sub    $0x1c,%esp
  800737:	89 c7                	mov    %eax,%edi
  800739:	89 d6                	mov    %edx,%esi
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800747:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80074a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80074f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800752:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800755:	39 d3                	cmp    %edx,%ebx
  800757:	72 05                	jb     80075e <printnum+0x30>
  800759:	39 45 10             	cmp    %eax,0x10(%ebp)
  80075c:	77 7a                	ja     8007d8 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80075e:	83 ec 0c             	sub    $0xc,%esp
  800761:	ff 75 18             	pushl  0x18(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80076a:	53                   	push   %ebx
  80076b:	ff 75 10             	pushl  0x10(%ebp)
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 e4             	pushl  -0x1c(%ebp)
  800774:	ff 75 e0             	pushl  -0x20(%ebp)
  800777:	ff 75 dc             	pushl  -0x24(%ebp)
  80077a:	ff 75 d8             	pushl  -0x28(%ebp)
  80077d:	e8 6e 19 00 00       	call   8020f0 <__udivdi3>
  800782:	83 c4 18             	add    $0x18,%esp
  800785:	52                   	push   %edx
  800786:	50                   	push   %eax
  800787:	89 f2                	mov    %esi,%edx
  800789:	89 f8                	mov    %edi,%eax
  80078b:	e8 9e ff ff ff       	call   80072e <printnum>
  800790:	83 c4 20             	add    $0x20,%esp
  800793:	eb 13                	jmp    8007a8 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	56                   	push   %esi
  800799:	ff 75 18             	pushl  0x18(%ebp)
  80079c:	ff d7                	call   *%edi
  80079e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8007a1:	83 eb 01             	sub    $0x1,%ebx
  8007a4:	85 db                	test   %ebx,%ebx
  8007a6:	7f ed                	jg     800795 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	56                   	push   %esi
  8007ac:	83 ec 04             	sub    $0x4,%esp
  8007af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8007b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8007bb:	e8 50 1a 00 00       	call   802210 <__umoddi3>
  8007c0:	83 c4 14             	add    $0x14,%esp
  8007c3:	0f be 80 83 24 80 00 	movsbl 0x802483(%eax),%eax
  8007ca:	50                   	push   %eax
  8007cb:	ff d7                	call   *%edi
}
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d3:	5b                   	pop    %ebx
  8007d4:	5e                   	pop    %esi
  8007d5:	5f                   	pop    %edi
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    
  8007d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8007db:	eb c4                	jmp    8007a1 <printnum+0x73>

008007dd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007e3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007e7:	8b 10                	mov    (%eax),%edx
  8007e9:	3b 50 04             	cmp    0x4(%eax),%edx
  8007ec:	73 0a                	jae    8007f8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007ee:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007f1:	89 08                	mov    %ecx,(%eax)
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	88 02                	mov    %al,(%edx)
}
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <printfmt>:
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800803:	50                   	push   %eax
  800804:	ff 75 10             	pushl  0x10(%ebp)
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	ff 75 08             	pushl  0x8(%ebp)
  80080d:	e8 05 00 00 00       	call   800817 <vprintfmt>
}
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <vprintfmt>:
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	57                   	push   %edi
  80081b:	56                   	push   %esi
  80081c:	53                   	push   %ebx
  80081d:	83 ec 2c             	sub    $0x2c,%esp
  800820:	8b 75 08             	mov    0x8(%ebp),%esi
  800823:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800826:	8b 7d 10             	mov    0x10(%ebp),%edi
  800829:	e9 8c 03 00 00       	jmp    800bba <vprintfmt+0x3a3>
		padc = ' ';
  80082e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800832:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800839:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800840:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800847:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80084c:	8d 47 01             	lea    0x1(%edi),%eax
  80084f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800852:	0f b6 17             	movzbl (%edi),%edx
  800855:	8d 42 dd             	lea    -0x23(%edx),%eax
  800858:	3c 55                	cmp    $0x55,%al
  80085a:	0f 87 dd 03 00 00    	ja     800c3d <vprintfmt+0x426>
  800860:	0f b6 c0             	movzbl %al,%eax
  800863:	ff 24 85 c0 25 80 00 	jmp    *0x8025c0(,%eax,4)
  80086a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80086d:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800871:	eb d9                	jmp    80084c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800873:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800876:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80087a:	eb d0                	jmp    80084c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80087c:	0f b6 d2             	movzbl %dl,%edx
  80087f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800882:	b8 00 00 00 00       	mov    $0x0,%eax
  800887:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80088a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80088d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800891:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800894:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800897:	83 f9 09             	cmp    $0x9,%ecx
  80089a:	77 55                	ja     8008f1 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80089c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80089f:	eb e9                	jmp    80088a <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	8d 40 04             	lea    0x4(%eax),%eax
  8008af:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8008b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008b9:	79 91                	jns    80084c <vprintfmt+0x35>
				width = precision, precision = -1;
  8008bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008c1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8008c8:	eb 82                	jmp    80084c <vprintfmt+0x35>
  8008ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d4:	0f 49 d0             	cmovns %eax,%edx
  8008d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008dd:	e9 6a ff ff ff       	jmp    80084c <vprintfmt+0x35>
  8008e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8008e5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8008ec:	e9 5b ff ff ff       	jmp    80084c <vprintfmt+0x35>
  8008f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008f7:	eb bc                	jmp    8008b5 <vprintfmt+0x9e>
			lflag++;
  8008f9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008ff:	e9 48 ff ff ff       	jmp    80084c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	8d 78 04             	lea    0x4(%eax),%edi
  80090a:	83 ec 08             	sub    $0x8,%esp
  80090d:	53                   	push   %ebx
  80090e:	ff 30                	pushl  (%eax)
  800910:	ff d6                	call   *%esi
			break;
  800912:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800915:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800918:	e9 9a 02 00 00       	jmp    800bb7 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	8d 78 04             	lea    0x4(%eax),%edi
  800923:	8b 00                	mov    (%eax),%eax
  800925:	99                   	cltd   
  800926:	31 d0                	xor    %edx,%eax
  800928:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80092a:	83 f8 0f             	cmp    $0xf,%eax
  80092d:	7f 23                	jg     800952 <vprintfmt+0x13b>
  80092f:	8b 14 85 20 27 80 00 	mov    0x802720(,%eax,4),%edx
  800936:	85 d2                	test   %edx,%edx
  800938:	74 18                	je     800952 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80093a:	52                   	push   %edx
  80093b:	68 75 28 80 00       	push   $0x802875
  800940:	53                   	push   %ebx
  800941:	56                   	push   %esi
  800942:	e8 b3 fe ff ff       	call   8007fa <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80094a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80094d:	e9 65 02 00 00       	jmp    800bb7 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800952:	50                   	push   %eax
  800953:	68 9b 24 80 00       	push   $0x80249b
  800958:	53                   	push   %ebx
  800959:	56                   	push   %esi
  80095a:	e8 9b fe ff ff       	call   8007fa <printfmt>
  80095f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800962:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800965:	e9 4d 02 00 00       	jmp    800bb7 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	83 c0 04             	add    $0x4,%eax
  800970:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800973:	8b 45 14             	mov    0x14(%ebp),%eax
  800976:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800978:	85 ff                	test   %edi,%edi
  80097a:	b8 94 24 80 00       	mov    $0x802494,%eax
  80097f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800982:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800986:	0f 8e bd 00 00 00    	jle    800a49 <vprintfmt+0x232>
  80098c:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800990:	75 0e                	jne    8009a0 <vprintfmt+0x189>
  800992:	89 75 08             	mov    %esi,0x8(%ebp)
  800995:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800998:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80099b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80099e:	eb 6d                	jmp    800a0d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 d0             	pushl  -0x30(%ebp)
  8009a6:	57                   	push   %edi
  8009a7:	e8 39 03 00 00       	call   800ce5 <strnlen>
  8009ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009af:	29 c1                	sub    %eax,%ecx
  8009b1:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8009b4:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8009b7:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8009bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009be:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8009c1:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c3:	eb 0f                	jmp    8009d4 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	53                   	push   %ebx
  8009c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8009cc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ce:	83 ef 01             	sub    $0x1,%edi
  8009d1:	83 c4 10             	add    $0x10,%esp
  8009d4:	85 ff                	test   %edi,%edi
  8009d6:	7f ed                	jg     8009c5 <vprintfmt+0x1ae>
  8009d8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8009db:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8009de:	85 c9                	test   %ecx,%ecx
  8009e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e5:	0f 49 c1             	cmovns %ecx,%eax
  8009e8:	29 c1                	sub    %eax,%ecx
  8009ea:	89 75 08             	mov    %esi,0x8(%ebp)
  8009ed:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8009f0:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8009f3:	89 cb                	mov    %ecx,%ebx
  8009f5:	eb 16                	jmp    800a0d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8009fb:	75 31                	jne    800a2e <vprintfmt+0x217>
					putch(ch, putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	50                   	push   %eax
  800a04:	ff 55 08             	call   *0x8(%ebp)
  800a07:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0a:	83 eb 01             	sub    $0x1,%ebx
  800a0d:	83 c7 01             	add    $0x1,%edi
  800a10:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800a14:	0f be c2             	movsbl %dl,%eax
  800a17:	85 c0                	test   %eax,%eax
  800a19:	74 59                	je     800a74 <vprintfmt+0x25d>
  800a1b:	85 f6                	test   %esi,%esi
  800a1d:	78 d8                	js     8009f7 <vprintfmt+0x1e0>
  800a1f:	83 ee 01             	sub    $0x1,%esi
  800a22:	79 d3                	jns    8009f7 <vprintfmt+0x1e0>
  800a24:	89 df                	mov    %ebx,%edi
  800a26:	8b 75 08             	mov    0x8(%ebp),%esi
  800a29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a2c:	eb 37                	jmp    800a65 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800a2e:	0f be d2             	movsbl %dl,%edx
  800a31:	83 ea 20             	sub    $0x20,%edx
  800a34:	83 fa 5e             	cmp    $0x5e,%edx
  800a37:	76 c4                	jbe    8009fd <vprintfmt+0x1e6>
					putch('?', putdat);
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	6a 3f                	push   $0x3f
  800a41:	ff 55 08             	call   *0x8(%ebp)
  800a44:	83 c4 10             	add    $0x10,%esp
  800a47:	eb c1                	jmp    800a0a <vprintfmt+0x1f3>
  800a49:	89 75 08             	mov    %esi,0x8(%ebp)
  800a4c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a4f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800a52:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a55:	eb b6                	jmp    800a0d <vprintfmt+0x1f6>
				putch(' ', putdat);
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	53                   	push   %ebx
  800a5b:	6a 20                	push   $0x20
  800a5d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a5f:	83 ef 01             	sub    $0x1,%edi
  800a62:	83 c4 10             	add    $0x10,%esp
  800a65:	85 ff                	test   %edi,%edi
  800a67:	7f ee                	jg     800a57 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800a69:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6f:	e9 43 01 00 00       	jmp    800bb7 <vprintfmt+0x3a0>
  800a74:	89 df                	mov    %ebx,%edi
  800a76:	8b 75 08             	mov    0x8(%ebp),%esi
  800a79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a7c:	eb e7                	jmp    800a65 <vprintfmt+0x24e>
	if (lflag >= 2)
  800a7e:	83 f9 01             	cmp    $0x1,%ecx
  800a81:	7e 3f                	jle    800ac2 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800a83:	8b 45 14             	mov    0x14(%ebp),%eax
  800a86:	8b 50 04             	mov    0x4(%eax),%edx
  800a89:	8b 00                	mov    (%eax),%eax
  800a8b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	8d 40 08             	lea    0x8(%eax),%eax
  800a97:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800a9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a9e:	79 5c                	jns    800afc <vprintfmt+0x2e5>
				putch('-', putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	53                   	push   %ebx
  800aa4:	6a 2d                	push   $0x2d
  800aa6:	ff d6                	call   *%esi
				num = -(long long) num;
  800aa8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800aab:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800aae:	f7 da                	neg    %edx
  800ab0:	83 d1 00             	adc    $0x0,%ecx
  800ab3:	f7 d9                	neg    %ecx
  800ab5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ab8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800abd:	e9 db 00 00 00       	jmp    800b9d <vprintfmt+0x386>
	else if (lflag)
  800ac2:	85 c9                	test   %ecx,%ecx
  800ac4:	75 1b                	jne    800ae1 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac9:	8b 00                	mov    (%eax),%eax
  800acb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ace:	89 c1                	mov    %eax,%ecx
  800ad0:	c1 f9 1f             	sar    $0x1f,%ecx
  800ad3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	8d 40 04             	lea    0x4(%eax),%eax
  800adc:	89 45 14             	mov    %eax,0x14(%ebp)
  800adf:	eb b9                	jmp    800a9a <vprintfmt+0x283>
		return va_arg(*ap, long);
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ae9:	89 c1                	mov    %eax,%ecx
  800aeb:	c1 f9 1f             	sar    $0x1f,%ecx
  800aee:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800af1:	8b 45 14             	mov    0x14(%ebp),%eax
  800af4:	8d 40 04             	lea    0x4(%eax),%eax
  800af7:	89 45 14             	mov    %eax,0x14(%ebp)
  800afa:	eb 9e                	jmp    800a9a <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800afc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800aff:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800b02:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b07:	e9 91 00 00 00       	jmp    800b9d <vprintfmt+0x386>
	if (lflag >= 2)
  800b0c:	83 f9 01             	cmp    $0x1,%ecx
  800b0f:	7e 15                	jle    800b26 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800b11:	8b 45 14             	mov    0x14(%ebp),%eax
  800b14:	8b 10                	mov    (%eax),%edx
  800b16:	8b 48 04             	mov    0x4(%eax),%ecx
  800b19:	8d 40 08             	lea    0x8(%eax),%eax
  800b1c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b1f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b24:	eb 77                	jmp    800b9d <vprintfmt+0x386>
	else if (lflag)
  800b26:	85 c9                	test   %ecx,%ecx
  800b28:	75 17                	jne    800b41 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800b2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2d:	8b 10                	mov    (%eax),%edx
  800b2f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b34:	8d 40 04             	lea    0x4(%eax),%eax
  800b37:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b3a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b3f:	eb 5c                	jmp    800b9d <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800b41:	8b 45 14             	mov    0x14(%ebp),%eax
  800b44:	8b 10                	mov    (%eax),%edx
  800b46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b4b:	8d 40 04             	lea    0x4(%eax),%eax
  800b4e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b56:	eb 45                	jmp    800b9d <vprintfmt+0x386>
			putch('X', putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	53                   	push   %ebx
  800b5c:	6a 58                	push   $0x58
  800b5e:	ff d6                	call   *%esi
			putch('X', putdat);
  800b60:	83 c4 08             	add    $0x8,%esp
  800b63:	53                   	push   %ebx
  800b64:	6a 58                	push   $0x58
  800b66:	ff d6                	call   *%esi
			putch('X', putdat);
  800b68:	83 c4 08             	add    $0x8,%esp
  800b6b:	53                   	push   %ebx
  800b6c:	6a 58                	push   $0x58
  800b6e:	ff d6                	call   *%esi
			break;
  800b70:	83 c4 10             	add    $0x10,%esp
  800b73:	eb 42                	jmp    800bb7 <vprintfmt+0x3a0>
			putch('0', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	53                   	push   %ebx
  800b79:	6a 30                	push   $0x30
  800b7b:	ff d6                	call   *%esi
			putch('x', putdat);
  800b7d:	83 c4 08             	add    $0x8,%esp
  800b80:	53                   	push   %ebx
  800b81:	6a 78                	push   $0x78
  800b83:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b85:	8b 45 14             	mov    0x14(%ebp),%eax
  800b88:	8b 10                	mov    (%eax),%edx
  800b8a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800b8f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b92:	8d 40 04             	lea    0x4(%eax),%eax
  800b95:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b98:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b9d:	83 ec 0c             	sub    $0xc,%esp
  800ba0:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800ba4:	57                   	push   %edi
  800ba5:	ff 75 e0             	pushl  -0x20(%ebp)
  800ba8:	50                   	push   %eax
  800ba9:	51                   	push   %ecx
  800baa:	52                   	push   %edx
  800bab:	89 da                	mov    %ebx,%edx
  800bad:	89 f0                	mov    %esi,%eax
  800baf:	e8 7a fb ff ff       	call   80072e <printnum>
			break;
  800bb4:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800bb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bba:	83 c7 01             	add    $0x1,%edi
  800bbd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800bc1:	83 f8 25             	cmp    $0x25,%eax
  800bc4:	0f 84 64 fc ff ff    	je     80082e <vprintfmt+0x17>
			if (ch == '\0')
  800bca:	85 c0                	test   %eax,%eax
  800bcc:	0f 84 8b 00 00 00    	je     800c5d <vprintfmt+0x446>
			putch(ch, putdat);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	53                   	push   %ebx
  800bd6:	50                   	push   %eax
  800bd7:	ff d6                	call   *%esi
  800bd9:	83 c4 10             	add    $0x10,%esp
  800bdc:	eb dc                	jmp    800bba <vprintfmt+0x3a3>
	if (lflag >= 2)
  800bde:	83 f9 01             	cmp    $0x1,%ecx
  800be1:	7e 15                	jle    800bf8 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  800be3:	8b 45 14             	mov    0x14(%ebp),%eax
  800be6:	8b 10                	mov    (%eax),%edx
  800be8:	8b 48 04             	mov    0x4(%eax),%ecx
  800beb:	8d 40 08             	lea    0x8(%eax),%eax
  800bee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bf1:	b8 10 00 00 00       	mov    $0x10,%eax
  800bf6:	eb a5                	jmp    800b9d <vprintfmt+0x386>
	else if (lflag)
  800bf8:	85 c9                	test   %ecx,%ecx
  800bfa:	75 17                	jne    800c13 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800bfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bff:	8b 10                	mov    (%eax),%edx
  800c01:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c06:	8d 40 04             	lea    0x4(%eax),%eax
  800c09:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c0c:	b8 10 00 00 00       	mov    $0x10,%eax
  800c11:	eb 8a                	jmp    800b9d <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800c13:	8b 45 14             	mov    0x14(%ebp),%eax
  800c16:	8b 10                	mov    (%eax),%edx
  800c18:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c1d:	8d 40 04             	lea    0x4(%eax),%eax
  800c20:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c23:	b8 10 00 00 00       	mov    $0x10,%eax
  800c28:	e9 70 ff ff ff       	jmp    800b9d <vprintfmt+0x386>
			putch(ch, putdat);
  800c2d:	83 ec 08             	sub    $0x8,%esp
  800c30:	53                   	push   %ebx
  800c31:	6a 25                	push   $0x25
  800c33:	ff d6                	call   *%esi
			break;
  800c35:	83 c4 10             	add    $0x10,%esp
  800c38:	e9 7a ff ff ff       	jmp    800bb7 <vprintfmt+0x3a0>
			putch('%', putdat);
  800c3d:	83 ec 08             	sub    $0x8,%esp
  800c40:	53                   	push   %ebx
  800c41:	6a 25                	push   $0x25
  800c43:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	89 f8                	mov    %edi,%eax
  800c4a:	eb 03                	jmp    800c4f <vprintfmt+0x438>
  800c4c:	83 e8 01             	sub    $0x1,%eax
  800c4f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c53:	75 f7                	jne    800c4c <vprintfmt+0x435>
  800c55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c58:	e9 5a ff ff ff       	jmp    800bb7 <vprintfmt+0x3a0>
}
  800c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 18             	sub    $0x18,%esp
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c74:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c78:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c82:	85 c0                	test   %eax,%eax
  800c84:	74 26                	je     800cac <vsnprintf+0x47>
  800c86:	85 d2                	test   %edx,%edx
  800c88:	7e 22                	jle    800cac <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c8a:	ff 75 14             	pushl  0x14(%ebp)
  800c8d:	ff 75 10             	pushl  0x10(%ebp)
  800c90:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c93:	50                   	push   %eax
  800c94:	68 dd 07 80 00       	push   $0x8007dd
  800c99:	e8 79 fb ff ff       	call   800817 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ca1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ca7:	83 c4 10             	add    $0x10,%esp
}
  800caa:	c9                   	leave  
  800cab:	c3                   	ret    
		return -E_INVAL;
  800cac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cb1:	eb f7                	jmp    800caa <vsnprintf+0x45>

00800cb3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cb9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cbc:	50                   	push   %eax
  800cbd:	ff 75 10             	pushl  0x10(%ebp)
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	ff 75 08             	pushl  0x8(%ebp)
  800cc6:	e8 9a ff ff ff       	call   800c65 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ccb:	c9                   	leave  
  800ccc:	c3                   	ret    

00800ccd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd8:	eb 03                	jmp    800cdd <strlen+0x10>
		n++;
  800cda:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800cdd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ce1:	75 f7                	jne    800cda <strlen+0xd>
	return n;
}
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cee:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf3:	eb 03                	jmp    800cf8 <strnlen+0x13>
		n++;
  800cf5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cf8:	39 d0                	cmp    %edx,%eax
  800cfa:	74 06                	je     800d02 <strnlen+0x1d>
  800cfc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d00:	75 f3                	jne    800cf5 <strnlen+0x10>
	return n;
}
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	53                   	push   %ebx
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d0e:	89 c2                	mov    %eax,%edx
  800d10:	83 c1 01             	add    $0x1,%ecx
  800d13:	83 c2 01             	add    $0x1,%edx
  800d16:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d1a:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d1d:	84 db                	test   %bl,%bl
  800d1f:	75 ef                	jne    800d10 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d21:	5b                   	pop    %ebx
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	53                   	push   %ebx
  800d28:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d2b:	53                   	push   %ebx
  800d2c:	e8 9c ff ff ff       	call   800ccd <strlen>
  800d31:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	01 d8                	add    %ebx,%eax
  800d39:	50                   	push   %eax
  800d3a:	e8 c5 ff ff ff       	call   800d04 <strcpy>
	return dst;
}
  800d3f:	89 d8                	mov    %ebx,%eax
  800d41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d44:	c9                   	leave  
  800d45:	c3                   	ret    

00800d46 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
  800d4b:	8b 75 08             	mov    0x8(%ebp),%esi
  800d4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d51:	89 f3                	mov    %esi,%ebx
  800d53:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d56:	89 f2                	mov    %esi,%edx
  800d58:	eb 0f                	jmp    800d69 <strncpy+0x23>
		*dst++ = *src;
  800d5a:	83 c2 01             	add    $0x1,%edx
  800d5d:	0f b6 01             	movzbl (%ecx),%eax
  800d60:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d63:	80 39 01             	cmpb   $0x1,(%ecx)
  800d66:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800d69:	39 da                	cmp    %ebx,%edx
  800d6b:	75 ed                	jne    800d5a <strncpy+0x14>
	}
	return ret;
}
  800d6d:	89 f0                	mov    %esi,%eax
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
  800d78:	8b 75 08             	mov    0x8(%ebp),%esi
  800d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d81:	89 f0                	mov    %esi,%eax
  800d83:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d87:	85 c9                	test   %ecx,%ecx
  800d89:	75 0b                	jne    800d96 <strlcpy+0x23>
  800d8b:	eb 17                	jmp    800da4 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d8d:	83 c2 01             	add    $0x1,%edx
  800d90:	83 c0 01             	add    $0x1,%eax
  800d93:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800d96:	39 d8                	cmp    %ebx,%eax
  800d98:	74 07                	je     800da1 <strlcpy+0x2e>
  800d9a:	0f b6 0a             	movzbl (%edx),%ecx
  800d9d:	84 c9                	test   %cl,%cl
  800d9f:	75 ec                	jne    800d8d <strlcpy+0x1a>
		*dst = '\0';
  800da1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da4:	29 f0                	sub    %esi,%eax
}
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800db3:	eb 06                	jmp    800dbb <strcmp+0x11>
		p++, q++;
  800db5:	83 c1 01             	add    $0x1,%ecx
  800db8:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800dbb:	0f b6 01             	movzbl (%ecx),%eax
  800dbe:	84 c0                	test   %al,%al
  800dc0:	74 04                	je     800dc6 <strcmp+0x1c>
  800dc2:	3a 02                	cmp    (%edx),%al
  800dc4:	74 ef                	je     800db5 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc6:	0f b6 c0             	movzbl %al,%eax
  800dc9:	0f b6 12             	movzbl (%edx),%edx
  800dcc:	29 d0                	sub    %edx,%eax
}
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	53                   	push   %ebx
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dda:	89 c3                	mov    %eax,%ebx
  800ddc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ddf:	eb 06                	jmp    800de7 <strncmp+0x17>
		n--, p++, q++;
  800de1:	83 c0 01             	add    $0x1,%eax
  800de4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800de7:	39 d8                	cmp    %ebx,%eax
  800de9:	74 16                	je     800e01 <strncmp+0x31>
  800deb:	0f b6 08             	movzbl (%eax),%ecx
  800dee:	84 c9                	test   %cl,%cl
  800df0:	74 04                	je     800df6 <strncmp+0x26>
  800df2:	3a 0a                	cmp    (%edx),%cl
  800df4:	74 eb                	je     800de1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800df6:	0f b6 00             	movzbl (%eax),%eax
  800df9:	0f b6 12             	movzbl (%edx),%edx
  800dfc:	29 d0                	sub    %edx,%eax
}
  800dfe:	5b                   	pop    %ebx
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    
		return 0;
  800e01:	b8 00 00 00 00       	mov    $0x0,%eax
  800e06:	eb f6                	jmp    800dfe <strncmp+0x2e>

00800e08 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e12:	0f b6 10             	movzbl (%eax),%edx
  800e15:	84 d2                	test   %dl,%dl
  800e17:	74 09                	je     800e22 <strchr+0x1a>
		if (*s == c)
  800e19:	38 ca                	cmp    %cl,%dl
  800e1b:	74 0a                	je     800e27 <strchr+0x1f>
	for (; *s; s++)
  800e1d:	83 c0 01             	add    $0x1,%eax
  800e20:	eb f0                	jmp    800e12 <strchr+0xa>
			return (char *) s;
	return 0;
  800e22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e33:	eb 03                	jmp    800e38 <strfind+0xf>
  800e35:	83 c0 01             	add    $0x1,%eax
  800e38:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e3b:	38 ca                	cmp    %cl,%dl
  800e3d:	74 04                	je     800e43 <strfind+0x1a>
  800e3f:	84 d2                	test   %dl,%dl
  800e41:	75 f2                	jne    800e35 <strfind+0xc>
			break;
	return (char *) s;
}
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    

00800e45 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	57                   	push   %edi
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
  800e4b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e51:	85 c9                	test   %ecx,%ecx
  800e53:	74 13                	je     800e68 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e55:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e5b:	75 05                	jne    800e62 <memset+0x1d>
  800e5d:	f6 c1 03             	test   $0x3,%cl
  800e60:	74 0d                	je     800e6f <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e65:	fc                   	cld    
  800e66:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e68:	89 f8                	mov    %edi,%eax
  800e6a:	5b                   	pop    %ebx
  800e6b:	5e                   	pop    %esi
  800e6c:	5f                   	pop    %edi
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    
		c &= 0xFF;
  800e6f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e73:	89 d3                	mov    %edx,%ebx
  800e75:	c1 e3 08             	shl    $0x8,%ebx
  800e78:	89 d0                	mov    %edx,%eax
  800e7a:	c1 e0 18             	shl    $0x18,%eax
  800e7d:	89 d6                	mov    %edx,%esi
  800e7f:	c1 e6 10             	shl    $0x10,%esi
  800e82:	09 f0                	or     %esi,%eax
  800e84:	09 c2                	or     %eax,%edx
  800e86:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800e88:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e8b:	89 d0                	mov    %edx,%eax
  800e8d:	fc                   	cld    
  800e8e:	f3 ab                	rep stos %eax,%es:(%edi)
  800e90:	eb d6                	jmp    800e68 <memset+0x23>

00800e92 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	57                   	push   %edi
  800e96:	56                   	push   %esi
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ea0:	39 c6                	cmp    %eax,%esi
  800ea2:	73 35                	jae    800ed9 <memmove+0x47>
  800ea4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ea7:	39 c2                	cmp    %eax,%edx
  800ea9:	76 2e                	jbe    800ed9 <memmove+0x47>
		s += n;
		d += n;
  800eab:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eae:	89 d6                	mov    %edx,%esi
  800eb0:	09 fe                	or     %edi,%esi
  800eb2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800eb8:	74 0c                	je     800ec6 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800eba:	83 ef 01             	sub    $0x1,%edi
  800ebd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ec0:	fd                   	std    
  800ec1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ec3:	fc                   	cld    
  800ec4:	eb 21                	jmp    800ee7 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ec6:	f6 c1 03             	test   $0x3,%cl
  800ec9:	75 ef                	jne    800eba <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ecb:	83 ef 04             	sub    $0x4,%edi
  800ece:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ed1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ed4:	fd                   	std    
  800ed5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ed7:	eb ea                	jmp    800ec3 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ed9:	89 f2                	mov    %esi,%edx
  800edb:	09 c2                	or     %eax,%edx
  800edd:	f6 c2 03             	test   $0x3,%dl
  800ee0:	74 09                	je     800eeb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ee2:	89 c7                	mov    %eax,%edi
  800ee4:	fc                   	cld    
  800ee5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eeb:	f6 c1 03             	test   $0x3,%cl
  800eee:	75 f2                	jne    800ee2 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ef0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ef3:	89 c7                	mov    %eax,%edi
  800ef5:	fc                   	cld    
  800ef6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ef8:	eb ed                	jmp    800ee7 <memmove+0x55>

00800efa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800efd:	ff 75 10             	pushl  0x10(%ebp)
  800f00:	ff 75 0c             	pushl  0xc(%ebp)
  800f03:	ff 75 08             	pushl  0x8(%ebp)
  800f06:	e8 87 ff ff ff       	call   800e92 <memmove>
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	56                   	push   %esi
  800f11:	53                   	push   %ebx
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f18:	89 c6                	mov    %eax,%esi
  800f1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f1d:	39 f0                	cmp    %esi,%eax
  800f1f:	74 1c                	je     800f3d <memcmp+0x30>
		if (*s1 != *s2)
  800f21:	0f b6 08             	movzbl (%eax),%ecx
  800f24:	0f b6 1a             	movzbl (%edx),%ebx
  800f27:	38 d9                	cmp    %bl,%cl
  800f29:	75 08                	jne    800f33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f2b:	83 c0 01             	add    $0x1,%eax
  800f2e:	83 c2 01             	add    $0x1,%edx
  800f31:	eb ea                	jmp    800f1d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f33:	0f b6 c1             	movzbl %cl,%eax
  800f36:	0f b6 db             	movzbl %bl,%ebx
  800f39:	29 d8                	sub    %ebx,%eax
  800f3b:	eb 05                	jmp    800f42 <memcmp+0x35>
	}

	return 0;
  800f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f42:	5b                   	pop    %ebx
  800f43:	5e                   	pop    %esi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f4f:	89 c2                	mov    %eax,%edx
  800f51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f54:	39 d0                	cmp    %edx,%eax
  800f56:	73 09                	jae    800f61 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f58:	38 08                	cmp    %cl,(%eax)
  800f5a:	74 05                	je     800f61 <memfind+0x1b>
	for (; s < ends; s++)
  800f5c:	83 c0 01             	add    $0x1,%eax
  800f5f:	eb f3                	jmp    800f54 <memfind+0xe>
			break;
	return (void *) s;
}
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6f:	eb 03                	jmp    800f74 <strtol+0x11>
		s++;
  800f71:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800f74:	0f b6 01             	movzbl (%ecx),%eax
  800f77:	3c 20                	cmp    $0x20,%al
  800f79:	74 f6                	je     800f71 <strtol+0xe>
  800f7b:	3c 09                	cmp    $0x9,%al
  800f7d:	74 f2                	je     800f71 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800f7f:	3c 2b                	cmp    $0x2b,%al
  800f81:	74 2e                	je     800fb1 <strtol+0x4e>
	int neg = 0;
  800f83:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800f88:	3c 2d                	cmp    $0x2d,%al
  800f8a:	74 2f                	je     800fbb <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f8c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800f92:	75 05                	jne    800f99 <strtol+0x36>
  800f94:	80 39 30             	cmpb   $0x30,(%ecx)
  800f97:	74 2c                	je     800fc5 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f99:	85 db                	test   %ebx,%ebx
  800f9b:	75 0a                	jne    800fa7 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f9d:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800fa2:	80 39 30             	cmpb   $0x30,(%ecx)
  800fa5:	74 28                	je     800fcf <strtol+0x6c>
		base = 10;
  800fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fac:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800faf:	eb 50                	jmp    801001 <strtol+0x9e>
		s++;
  800fb1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800fb4:	bf 00 00 00 00       	mov    $0x0,%edi
  800fb9:	eb d1                	jmp    800f8c <strtol+0x29>
		s++, neg = 1;
  800fbb:	83 c1 01             	add    $0x1,%ecx
  800fbe:	bf 01 00 00 00       	mov    $0x1,%edi
  800fc3:	eb c7                	jmp    800f8c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fc5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800fc9:	74 0e                	je     800fd9 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800fcb:	85 db                	test   %ebx,%ebx
  800fcd:	75 d8                	jne    800fa7 <strtol+0x44>
		s++, base = 8;
  800fcf:	83 c1 01             	add    $0x1,%ecx
  800fd2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800fd7:	eb ce                	jmp    800fa7 <strtol+0x44>
		s += 2, base = 16;
  800fd9:	83 c1 02             	add    $0x2,%ecx
  800fdc:	bb 10 00 00 00       	mov    $0x10,%ebx
  800fe1:	eb c4                	jmp    800fa7 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800fe3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800fe6:	89 f3                	mov    %esi,%ebx
  800fe8:	80 fb 19             	cmp    $0x19,%bl
  800feb:	77 29                	ja     801016 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800fed:	0f be d2             	movsbl %dl,%edx
  800ff0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ff3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ff6:	7d 30                	jge    801028 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ff8:	83 c1 01             	add    $0x1,%ecx
  800ffb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fff:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801001:	0f b6 11             	movzbl (%ecx),%edx
  801004:	8d 72 d0             	lea    -0x30(%edx),%esi
  801007:	89 f3                	mov    %esi,%ebx
  801009:	80 fb 09             	cmp    $0x9,%bl
  80100c:	77 d5                	ja     800fe3 <strtol+0x80>
			dig = *s - '0';
  80100e:	0f be d2             	movsbl %dl,%edx
  801011:	83 ea 30             	sub    $0x30,%edx
  801014:	eb dd                	jmp    800ff3 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  801016:	8d 72 bf             	lea    -0x41(%edx),%esi
  801019:	89 f3                	mov    %esi,%ebx
  80101b:	80 fb 19             	cmp    $0x19,%bl
  80101e:	77 08                	ja     801028 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801020:	0f be d2             	movsbl %dl,%edx
  801023:	83 ea 37             	sub    $0x37,%edx
  801026:	eb cb                	jmp    800ff3 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  801028:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102c:	74 05                	je     801033 <strtol+0xd0>
		*endptr = (char *) s;
  80102e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801031:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801033:	89 c2                	mov    %eax,%edx
  801035:	f7 da                	neg    %edx
  801037:	85 ff                	test   %edi,%edi
  801039:	0f 45 c2             	cmovne %edx,%eax
}
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	57                   	push   %edi
  801045:	56                   	push   %esi
  801046:	53                   	push   %ebx
	asm volatile("int %1\n"
  801047:	b8 00 00 00 00       	mov    $0x0,%eax
  80104c:	8b 55 08             	mov    0x8(%ebp),%edx
  80104f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801052:	89 c3                	mov    %eax,%ebx
  801054:	89 c7                	mov    %eax,%edi
  801056:	89 c6                	mov    %eax,%esi
  801058:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80105a:	5b                   	pop    %ebx
  80105b:	5e                   	pop    %esi
  80105c:	5f                   	pop    %edi
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    

0080105f <sys_cgetc>:

int
sys_cgetc(void)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	57                   	push   %edi
  801063:	56                   	push   %esi
  801064:	53                   	push   %ebx
	asm volatile("int %1\n"
  801065:	ba 00 00 00 00       	mov    $0x0,%edx
  80106a:	b8 01 00 00 00       	mov    $0x1,%eax
  80106f:	89 d1                	mov    %edx,%ecx
  801071:	89 d3                	mov    %edx,%ebx
  801073:	89 d7                	mov    %edx,%edi
  801075:	89 d6                	mov    %edx,%esi
  801077:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801079:	5b                   	pop    %ebx
  80107a:	5e                   	pop    %esi
  80107b:	5f                   	pop    %edi
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801087:	b9 00 00 00 00       	mov    $0x0,%ecx
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	b8 03 00 00 00       	mov    $0x3,%eax
  801094:	89 cb                	mov    %ecx,%ebx
  801096:	89 cf                	mov    %ecx,%edi
  801098:	89 ce                	mov    %ecx,%esi
  80109a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80109c:	85 c0                	test   %eax,%eax
  80109e:	7f 08                	jg     8010a8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a3:	5b                   	pop    %ebx
  8010a4:	5e                   	pop    %esi
  8010a5:	5f                   	pop    %edi
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a8:	83 ec 0c             	sub    $0xc,%esp
  8010ab:	50                   	push   %eax
  8010ac:	6a 03                	push   $0x3
  8010ae:	68 7f 27 80 00       	push   $0x80277f
  8010b3:	6a 23                	push   $0x23
  8010b5:	68 9c 27 80 00       	push   $0x80279c
  8010ba:	e8 80 f5 ff ff       	call   80063f <_panic>

008010bf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	57                   	push   %edi
  8010c3:	56                   	push   %esi
  8010c4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ca:	b8 02 00 00 00       	mov    $0x2,%eax
  8010cf:	89 d1                	mov    %edx,%ecx
  8010d1:	89 d3                	mov    %edx,%ebx
  8010d3:	89 d7                	mov    %edx,%edi
  8010d5:	89 d6                	mov    %edx,%esi
  8010d7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010d9:	5b                   	pop    %ebx
  8010da:	5e                   	pop    %esi
  8010db:	5f                   	pop    %edi
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <sys_yield>:

void
sys_yield(void)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	57                   	push   %edi
  8010e2:	56                   	push   %esi
  8010e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e9:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010ee:	89 d1                	mov    %edx,%ecx
  8010f0:	89 d3                	mov    %edx,%ebx
  8010f2:	89 d7                	mov    %edx,%edi
  8010f4:	89 d6                	mov    %edx,%esi
  8010f6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010f8:	5b                   	pop    %ebx
  8010f9:	5e                   	pop    %esi
  8010fa:	5f                   	pop    %edi
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    

008010fd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	57                   	push   %edi
  801101:	56                   	push   %esi
  801102:	53                   	push   %ebx
  801103:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801106:	be 00 00 00 00       	mov    $0x0,%esi
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801111:	b8 04 00 00 00       	mov    $0x4,%eax
  801116:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801119:	89 f7                	mov    %esi,%edi
  80111b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80111d:	85 c0                	test   %eax,%eax
  80111f:	7f 08                	jg     801129 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801121:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801124:	5b                   	pop    %ebx
  801125:	5e                   	pop    %esi
  801126:	5f                   	pop    %edi
  801127:	5d                   	pop    %ebp
  801128:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801129:	83 ec 0c             	sub    $0xc,%esp
  80112c:	50                   	push   %eax
  80112d:	6a 04                	push   $0x4
  80112f:	68 7f 27 80 00       	push   $0x80277f
  801134:	6a 23                	push   $0x23
  801136:	68 9c 27 80 00       	push   $0x80279c
  80113b:	e8 ff f4 ff ff       	call   80063f <_panic>

00801140 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	57                   	push   %edi
  801144:	56                   	push   %esi
  801145:	53                   	push   %ebx
  801146:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114f:	b8 05 00 00 00       	mov    $0x5,%eax
  801154:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801157:	8b 7d 14             	mov    0x14(%ebp),%edi
  80115a:	8b 75 18             	mov    0x18(%ebp),%esi
  80115d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80115f:	85 c0                	test   %eax,%eax
  801161:	7f 08                	jg     80116b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801163:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801166:	5b                   	pop    %ebx
  801167:	5e                   	pop    %esi
  801168:	5f                   	pop    %edi
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80116b:	83 ec 0c             	sub    $0xc,%esp
  80116e:	50                   	push   %eax
  80116f:	6a 05                	push   $0x5
  801171:	68 7f 27 80 00       	push   $0x80277f
  801176:	6a 23                	push   $0x23
  801178:	68 9c 27 80 00       	push   $0x80279c
  80117d:	e8 bd f4 ff ff       	call   80063f <_panic>

00801182 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	57                   	push   %edi
  801186:	56                   	push   %esi
  801187:	53                   	push   %ebx
  801188:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80118b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801190:	8b 55 08             	mov    0x8(%ebp),%edx
  801193:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801196:	b8 06 00 00 00       	mov    $0x6,%eax
  80119b:	89 df                	mov    %ebx,%edi
  80119d:	89 de                	mov    %ebx,%esi
  80119f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a1:	85 c0                	test   %eax,%eax
  8011a3:	7f 08                	jg     8011ad <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a8:	5b                   	pop    %ebx
  8011a9:	5e                   	pop    %esi
  8011aa:	5f                   	pop    %edi
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ad:	83 ec 0c             	sub    $0xc,%esp
  8011b0:	50                   	push   %eax
  8011b1:	6a 06                	push   $0x6
  8011b3:	68 7f 27 80 00       	push   $0x80277f
  8011b8:	6a 23                	push   $0x23
  8011ba:	68 9c 27 80 00       	push   $0x80279c
  8011bf:	e8 7b f4 ff ff       	call   80063f <_panic>

008011c4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	57                   	push   %edi
  8011c8:	56                   	push   %esi
  8011c9:	53                   	push   %ebx
  8011ca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d8:	b8 08 00 00 00       	mov    $0x8,%eax
  8011dd:	89 df                	mov    %ebx,%edi
  8011df:	89 de                	mov    %ebx,%esi
  8011e1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	7f 08                	jg     8011ef <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ea:	5b                   	pop    %ebx
  8011eb:	5e                   	pop    %esi
  8011ec:	5f                   	pop    %edi
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ef:	83 ec 0c             	sub    $0xc,%esp
  8011f2:	50                   	push   %eax
  8011f3:	6a 08                	push   $0x8
  8011f5:	68 7f 27 80 00       	push   $0x80277f
  8011fa:	6a 23                	push   $0x23
  8011fc:	68 9c 27 80 00       	push   $0x80279c
  801201:	e8 39 f4 ff ff       	call   80063f <_panic>

00801206 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	57                   	push   %edi
  80120a:	56                   	push   %esi
  80120b:	53                   	push   %ebx
  80120c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80120f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801214:	8b 55 08             	mov    0x8(%ebp),%edx
  801217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121a:	b8 09 00 00 00       	mov    $0x9,%eax
  80121f:	89 df                	mov    %ebx,%edi
  801221:	89 de                	mov    %ebx,%esi
  801223:	cd 30                	int    $0x30
	if(check && ret > 0)
  801225:	85 c0                	test   %eax,%eax
  801227:	7f 08                	jg     801231 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801229:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122c:	5b                   	pop    %ebx
  80122d:	5e                   	pop    %esi
  80122e:	5f                   	pop    %edi
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	50                   	push   %eax
  801235:	6a 09                	push   $0x9
  801237:	68 7f 27 80 00       	push   $0x80277f
  80123c:	6a 23                	push   $0x23
  80123e:	68 9c 27 80 00       	push   $0x80279c
  801243:	e8 f7 f3 ff ff       	call   80063f <_panic>

00801248 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	57                   	push   %edi
  80124c:	56                   	push   %esi
  80124d:	53                   	push   %ebx
  80124e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801251:	bb 00 00 00 00       	mov    $0x0,%ebx
  801256:	8b 55 08             	mov    0x8(%ebp),%edx
  801259:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801261:	89 df                	mov    %ebx,%edi
  801263:	89 de                	mov    %ebx,%esi
  801265:	cd 30                	int    $0x30
	if(check && ret > 0)
  801267:	85 c0                	test   %eax,%eax
  801269:	7f 08                	jg     801273 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80126b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126e:	5b                   	pop    %ebx
  80126f:	5e                   	pop    %esi
  801270:	5f                   	pop    %edi
  801271:	5d                   	pop    %ebp
  801272:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801273:	83 ec 0c             	sub    $0xc,%esp
  801276:	50                   	push   %eax
  801277:	6a 0a                	push   $0xa
  801279:	68 7f 27 80 00       	push   $0x80277f
  80127e:	6a 23                	push   $0x23
  801280:	68 9c 27 80 00       	push   $0x80279c
  801285:	e8 b5 f3 ff ff       	call   80063f <_panic>

0080128a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	57                   	push   %edi
  80128e:	56                   	push   %esi
  80128f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801290:	8b 55 08             	mov    0x8(%ebp),%edx
  801293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801296:	b8 0c 00 00 00       	mov    $0xc,%eax
  80129b:	be 00 00 00 00       	mov    $0x0,%esi
  8012a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012a3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012a6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012a8:	5b                   	pop    %ebx
  8012a9:	5e                   	pop    %esi
  8012aa:	5f                   	pop    %edi
  8012ab:	5d                   	pop    %ebp
  8012ac:	c3                   	ret    

008012ad <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	57                   	push   %edi
  8012b1:	56                   	push   %esi
  8012b2:	53                   	push   %ebx
  8012b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012be:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012c3:	89 cb                	mov    %ecx,%ebx
  8012c5:	89 cf                	mov    %ecx,%edi
  8012c7:	89 ce                	mov    %ecx,%esi
  8012c9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	7f 08                	jg     8012d7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  8012db:	6a 0d                	push   $0xd
  8012dd:	68 7f 27 80 00       	push   $0x80277f
  8012e2:	6a 23                	push   $0x23
  8012e4:	68 9c 27 80 00       	push   $0x80279c
  8012e9:	e8 51 f3 ff ff       	call   80063f <_panic>

008012ee <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	53                   	push   %ebx
  8012f2:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  8012f5:	83 3d b4 40 80 00 00 	cmpl   $0x0,0x8040b4
  8012fc:	74 0d                	je     80130b <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	a3 b4 40 80 00       	mov    %eax,0x8040b4
}
  801306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801309:	c9                   	leave  
  80130a:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  80130b:	e8 af fd ff ff       	call   8010bf <sys_getenvid>
  801310:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801312:	83 ec 04             	sub    $0x4,%esp
  801315:	6a 07                	push   $0x7
  801317:	68 00 f0 bf ee       	push   $0xeebff000
  80131c:	50                   	push   %eax
  80131d:	e8 db fd ff ff       	call   8010fd <sys_page_alloc>
        	if (r < 0) {
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	78 27                	js     801350 <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801329:	83 ec 08             	sub    $0x8,%esp
  80132c:	68 62 13 80 00       	push   $0x801362
  801331:	53                   	push   %ebx
  801332:	e8 11 ff ff ff       	call   801248 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	85 c0                	test   %eax,%eax
  80133c:	79 c0                	jns    8012fe <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  80133e:	50                   	push   %eax
  80133f:	68 aa 27 80 00       	push   $0x8027aa
  801344:	6a 28                	push   $0x28
  801346:	68 be 27 80 00       	push   $0x8027be
  80134b:	e8 ef f2 ff ff       	call   80063f <_panic>
            		panic("pgfault_handler: %e", r);
  801350:	50                   	push   %eax
  801351:	68 aa 27 80 00       	push   $0x8027aa
  801356:	6a 24                	push   $0x24
  801358:	68 be 27 80 00       	push   $0x8027be
  80135d:	e8 dd f2 ff ff       	call   80063f <_panic>

00801362 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801362:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801363:	a1 b4 40 80 00       	mov    0x8040b4,%eax
	call *%eax
  801368:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80136a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  80136d:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801371:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801374:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801378:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  80137c:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80137f:	83 c4 08             	add    $0x8,%esp
	popal
  801382:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801383:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801386:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801387:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801388:	c3                   	ret    

00801389 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	05 00 00 00 30       	add    $0x30000000,%eax
  801394:	c1 e8 0c             	shr    $0xc,%eax
}
  801397:	5d                   	pop    %ebp
  801398:	c3                   	ret    

00801399 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013ae:	5d                   	pop    %ebp
  8013af:	c3                   	ret    

008013b0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013bb:	89 c2                	mov    %eax,%edx
  8013bd:	c1 ea 16             	shr    $0x16,%edx
  8013c0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013c7:	f6 c2 01             	test   $0x1,%dl
  8013ca:	74 2a                	je     8013f6 <fd_alloc+0x46>
  8013cc:	89 c2                	mov    %eax,%edx
  8013ce:	c1 ea 0c             	shr    $0xc,%edx
  8013d1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013d8:	f6 c2 01             	test   $0x1,%dl
  8013db:	74 19                	je     8013f6 <fd_alloc+0x46>
  8013dd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013e2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013e7:	75 d2                	jne    8013bb <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013e9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013ef:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013f4:	eb 07                	jmp    8013fd <fd_alloc+0x4d>
			*fd_store = fd;
  8013f6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013fd:	5d                   	pop    %ebp
  8013fe:	c3                   	ret    

008013ff <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801405:	83 f8 1f             	cmp    $0x1f,%eax
  801408:	77 36                	ja     801440 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80140a:	c1 e0 0c             	shl    $0xc,%eax
  80140d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801412:	89 c2                	mov    %eax,%edx
  801414:	c1 ea 16             	shr    $0x16,%edx
  801417:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80141e:	f6 c2 01             	test   $0x1,%dl
  801421:	74 24                	je     801447 <fd_lookup+0x48>
  801423:	89 c2                	mov    %eax,%edx
  801425:	c1 ea 0c             	shr    $0xc,%edx
  801428:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80142f:	f6 c2 01             	test   $0x1,%dl
  801432:	74 1a                	je     80144e <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	89 02                	mov    %eax,(%edx)
	return 0;
  801439:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80143e:	5d                   	pop    %ebp
  80143f:	c3                   	ret    
		return -E_INVAL;
  801440:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801445:	eb f7                	jmp    80143e <fd_lookup+0x3f>
		return -E_INVAL;
  801447:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144c:	eb f0                	jmp    80143e <fd_lookup+0x3f>
  80144e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801453:	eb e9                	jmp    80143e <fd_lookup+0x3f>

00801455 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 08             	sub    $0x8,%esp
  80145b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80145e:	ba 4c 28 80 00       	mov    $0x80284c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801463:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801468:	39 08                	cmp    %ecx,(%eax)
  80146a:	74 33                	je     80149f <dev_lookup+0x4a>
  80146c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80146f:	8b 02                	mov    (%edx),%eax
  801471:	85 c0                	test   %eax,%eax
  801473:	75 f3                	jne    801468 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801475:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  80147a:	8b 40 48             	mov    0x48(%eax),%eax
  80147d:	83 ec 04             	sub    $0x4,%esp
  801480:	51                   	push   %ecx
  801481:	50                   	push   %eax
  801482:	68 cc 27 80 00       	push   $0x8027cc
  801487:	e8 8e f2 ff ff       	call   80071a <cprintf>
	*dev = 0;
  80148c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    
			*dev = devtab[i];
  80149f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a9:	eb f2                	jmp    80149d <dev_lookup+0x48>

008014ab <fd_close>:
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	57                   	push   %edi
  8014af:	56                   	push   %esi
  8014b0:	53                   	push   %ebx
  8014b1:	83 ec 1c             	sub    $0x1c,%esp
  8014b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8014b7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014bd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014be:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014c4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014c7:	50                   	push   %eax
  8014c8:	e8 32 ff ff ff       	call   8013ff <fd_lookup>
  8014cd:	89 c3                	mov    %eax,%ebx
  8014cf:	83 c4 08             	add    $0x8,%esp
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	78 05                	js     8014db <fd_close+0x30>
	    || fd != fd2)
  8014d6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014d9:	74 16                	je     8014f1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8014db:	89 f8                	mov    %edi,%eax
  8014dd:	84 c0                	test   %al,%al
  8014df:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e4:	0f 44 d8             	cmove  %eax,%ebx
}
  8014e7:	89 d8                	mov    %ebx,%eax
  8014e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ec:	5b                   	pop    %ebx
  8014ed:	5e                   	pop    %esi
  8014ee:	5f                   	pop    %edi
  8014ef:	5d                   	pop    %ebp
  8014f0:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014f1:	83 ec 08             	sub    $0x8,%esp
  8014f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014f7:	50                   	push   %eax
  8014f8:	ff 36                	pushl  (%esi)
  8014fa:	e8 56 ff ff ff       	call   801455 <dev_lookup>
  8014ff:	89 c3                	mov    %eax,%ebx
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	78 15                	js     80151d <fd_close+0x72>
		if (dev->dev_close)
  801508:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80150b:	8b 40 10             	mov    0x10(%eax),%eax
  80150e:	85 c0                	test   %eax,%eax
  801510:	74 1b                	je     80152d <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801512:	83 ec 0c             	sub    $0xc,%esp
  801515:	56                   	push   %esi
  801516:	ff d0                	call   *%eax
  801518:	89 c3                	mov    %eax,%ebx
  80151a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80151d:	83 ec 08             	sub    $0x8,%esp
  801520:	56                   	push   %esi
  801521:	6a 00                	push   $0x0
  801523:	e8 5a fc ff ff       	call   801182 <sys_page_unmap>
	return r;
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	eb ba                	jmp    8014e7 <fd_close+0x3c>
			r = 0;
  80152d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801532:	eb e9                	jmp    80151d <fd_close+0x72>

00801534 <close>:

int
close(int fdnum)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80153a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153d:	50                   	push   %eax
  80153e:	ff 75 08             	pushl  0x8(%ebp)
  801541:	e8 b9 fe ff ff       	call   8013ff <fd_lookup>
  801546:	83 c4 08             	add    $0x8,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 10                	js     80155d <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	6a 01                	push   $0x1
  801552:	ff 75 f4             	pushl  -0xc(%ebp)
  801555:	e8 51 ff ff ff       	call   8014ab <fd_close>
  80155a:	83 c4 10             	add    $0x10,%esp
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <close_all>:

void
close_all(void)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	53                   	push   %ebx
  801563:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801566:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80156b:	83 ec 0c             	sub    $0xc,%esp
  80156e:	53                   	push   %ebx
  80156f:	e8 c0 ff ff ff       	call   801534 <close>
	for (i = 0; i < MAXFD; i++)
  801574:	83 c3 01             	add    $0x1,%ebx
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	83 fb 20             	cmp    $0x20,%ebx
  80157d:	75 ec                	jne    80156b <close_all+0xc>
}
  80157f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	57                   	push   %edi
  801588:	56                   	push   %esi
  801589:	53                   	push   %ebx
  80158a:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80158d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801590:	50                   	push   %eax
  801591:	ff 75 08             	pushl  0x8(%ebp)
  801594:	e8 66 fe ff ff       	call   8013ff <fd_lookup>
  801599:	89 c3                	mov    %eax,%ebx
  80159b:	83 c4 08             	add    $0x8,%esp
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	0f 88 81 00 00 00    	js     801627 <dup+0xa3>
		return r;
	close(newfdnum);
  8015a6:	83 ec 0c             	sub    $0xc,%esp
  8015a9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ac:	e8 83 ff ff ff       	call   801534 <close>

	newfd = INDEX2FD(newfdnum);
  8015b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015b4:	c1 e6 0c             	shl    $0xc,%esi
  8015b7:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015bd:	83 c4 04             	add    $0x4,%esp
  8015c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015c3:	e8 d1 fd ff ff       	call   801399 <fd2data>
  8015c8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015ca:	89 34 24             	mov    %esi,(%esp)
  8015cd:	e8 c7 fd ff ff       	call   801399 <fd2data>
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015d7:	89 d8                	mov    %ebx,%eax
  8015d9:	c1 e8 16             	shr    $0x16,%eax
  8015dc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015e3:	a8 01                	test   $0x1,%al
  8015e5:	74 11                	je     8015f8 <dup+0x74>
  8015e7:	89 d8                	mov    %ebx,%eax
  8015e9:	c1 e8 0c             	shr    $0xc,%eax
  8015ec:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015f3:	f6 c2 01             	test   $0x1,%dl
  8015f6:	75 39                	jne    801631 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015fb:	89 d0                	mov    %edx,%eax
  8015fd:	c1 e8 0c             	shr    $0xc,%eax
  801600:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801607:	83 ec 0c             	sub    $0xc,%esp
  80160a:	25 07 0e 00 00       	and    $0xe07,%eax
  80160f:	50                   	push   %eax
  801610:	56                   	push   %esi
  801611:	6a 00                	push   $0x0
  801613:	52                   	push   %edx
  801614:	6a 00                	push   $0x0
  801616:	e8 25 fb ff ff       	call   801140 <sys_page_map>
  80161b:	89 c3                	mov    %eax,%ebx
  80161d:	83 c4 20             	add    $0x20,%esp
  801620:	85 c0                	test   %eax,%eax
  801622:	78 31                	js     801655 <dup+0xd1>
		goto err;

	return newfdnum;
  801624:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801627:	89 d8                	mov    %ebx,%eax
  801629:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162c:	5b                   	pop    %ebx
  80162d:	5e                   	pop    %esi
  80162e:	5f                   	pop    %edi
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801631:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801638:	83 ec 0c             	sub    $0xc,%esp
  80163b:	25 07 0e 00 00       	and    $0xe07,%eax
  801640:	50                   	push   %eax
  801641:	57                   	push   %edi
  801642:	6a 00                	push   $0x0
  801644:	53                   	push   %ebx
  801645:	6a 00                	push   $0x0
  801647:	e8 f4 fa ff ff       	call   801140 <sys_page_map>
  80164c:	89 c3                	mov    %eax,%ebx
  80164e:	83 c4 20             	add    $0x20,%esp
  801651:	85 c0                	test   %eax,%eax
  801653:	79 a3                	jns    8015f8 <dup+0x74>
	sys_page_unmap(0, newfd);
  801655:	83 ec 08             	sub    $0x8,%esp
  801658:	56                   	push   %esi
  801659:	6a 00                	push   $0x0
  80165b:	e8 22 fb ff ff       	call   801182 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801660:	83 c4 08             	add    $0x8,%esp
  801663:	57                   	push   %edi
  801664:	6a 00                	push   $0x0
  801666:	e8 17 fb ff ff       	call   801182 <sys_page_unmap>
	return r;
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	eb b7                	jmp    801627 <dup+0xa3>

00801670 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	53                   	push   %ebx
  801674:	83 ec 14             	sub    $0x14,%esp
  801677:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80167a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80167d:	50                   	push   %eax
  80167e:	53                   	push   %ebx
  80167f:	e8 7b fd ff ff       	call   8013ff <fd_lookup>
  801684:	83 c4 08             	add    $0x8,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	78 3f                	js     8016ca <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80168b:	83 ec 08             	sub    $0x8,%esp
  80168e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801691:	50                   	push   %eax
  801692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801695:	ff 30                	pushl  (%eax)
  801697:	e8 b9 fd ff ff       	call   801455 <dev_lookup>
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	78 27                	js     8016ca <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016a6:	8b 42 08             	mov    0x8(%edx),%eax
  8016a9:	83 e0 03             	and    $0x3,%eax
  8016ac:	83 f8 01             	cmp    $0x1,%eax
  8016af:	74 1e                	je     8016cf <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b4:	8b 40 08             	mov    0x8(%eax),%eax
  8016b7:	85 c0                	test   %eax,%eax
  8016b9:	74 35                	je     8016f0 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016bb:	83 ec 04             	sub    $0x4,%esp
  8016be:	ff 75 10             	pushl  0x10(%ebp)
  8016c1:	ff 75 0c             	pushl  0xc(%ebp)
  8016c4:	52                   	push   %edx
  8016c5:	ff d0                	call   *%eax
  8016c7:	83 c4 10             	add    $0x10,%esp
}
  8016ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016cf:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  8016d4:	8b 40 48             	mov    0x48(%eax),%eax
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	53                   	push   %ebx
  8016db:	50                   	push   %eax
  8016dc:	68 10 28 80 00       	push   $0x802810
  8016e1:	e8 34 f0 ff ff       	call   80071a <cprintf>
		return -E_INVAL;
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ee:	eb da                	jmp    8016ca <read+0x5a>
		return -E_NOT_SUPP;
  8016f0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f5:	eb d3                	jmp    8016ca <read+0x5a>

008016f7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	57                   	push   %edi
  8016fb:	56                   	push   %esi
  8016fc:	53                   	push   %ebx
  8016fd:	83 ec 0c             	sub    $0xc,%esp
  801700:	8b 7d 08             	mov    0x8(%ebp),%edi
  801703:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801706:	bb 00 00 00 00       	mov    $0x0,%ebx
  80170b:	39 f3                	cmp    %esi,%ebx
  80170d:	73 25                	jae    801734 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	89 f0                	mov    %esi,%eax
  801714:	29 d8                	sub    %ebx,%eax
  801716:	50                   	push   %eax
  801717:	89 d8                	mov    %ebx,%eax
  801719:	03 45 0c             	add    0xc(%ebp),%eax
  80171c:	50                   	push   %eax
  80171d:	57                   	push   %edi
  80171e:	e8 4d ff ff ff       	call   801670 <read>
		if (m < 0)
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	85 c0                	test   %eax,%eax
  801728:	78 08                	js     801732 <readn+0x3b>
			return m;
		if (m == 0)
  80172a:	85 c0                	test   %eax,%eax
  80172c:	74 06                	je     801734 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80172e:	01 c3                	add    %eax,%ebx
  801730:	eb d9                	jmp    80170b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801732:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801734:	89 d8                	mov    %ebx,%eax
  801736:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801739:	5b                   	pop    %ebx
  80173a:	5e                   	pop    %esi
  80173b:	5f                   	pop    %edi
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    

0080173e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	53                   	push   %ebx
  801742:	83 ec 14             	sub    $0x14,%esp
  801745:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801748:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80174b:	50                   	push   %eax
  80174c:	53                   	push   %ebx
  80174d:	e8 ad fc ff ff       	call   8013ff <fd_lookup>
  801752:	83 c4 08             	add    $0x8,%esp
  801755:	85 c0                	test   %eax,%eax
  801757:	78 3a                	js     801793 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175f:	50                   	push   %eax
  801760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801763:	ff 30                	pushl  (%eax)
  801765:	e8 eb fc ff ff       	call   801455 <dev_lookup>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	85 c0                	test   %eax,%eax
  80176f:	78 22                	js     801793 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801774:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801778:	74 1e                	je     801798 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80177a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177d:	8b 52 0c             	mov    0xc(%edx),%edx
  801780:	85 d2                	test   %edx,%edx
  801782:	74 35                	je     8017b9 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	ff 75 10             	pushl  0x10(%ebp)
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	50                   	push   %eax
  80178e:	ff d2                	call   *%edx
  801790:	83 c4 10             	add    $0x10,%esp
}
  801793:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801796:	c9                   	leave  
  801797:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801798:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  80179d:	8b 40 48             	mov    0x48(%eax),%eax
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	53                   	push   %ebx
  8017a4:	50                   	push   %eax
  8017a5:	68 2c 28 80 00       	push   $0x80282c
  8017aa:	e8 6b ef ff ff       	call   80071a <cprintf>
		return -E_INVAL;
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b7:	eb da                	jmp    801793 <write+0x55>
		return -E_NOT_SUPP;
  8017b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017be:	eb d3                	jmp    801793 <write+0x55>

008017c0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017c9:	50                   	push   %eax
  8017ca:	ff 75 08             	pushl  0x8(%ebp)
  8017cd:	e8 2d fc ff ff       	call   8013ff <fd_lookup>
  8017d2:	83 c4 08             	add    $0x8,%esp
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	78 0e                	js     8017e7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017df:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	53                   	push   %ebx
  8017ed:	83 ec 14             	sub    $0x14,%esp
  8017f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f6:	50                   	push   %eax
  8017f7:	53                   	push   %ebx
  8017f8:	e8 02 fc ff ff       	call   8013ff <fd_lookup>
  8017fd:	83 c4 08             	add    $0x8,%esp
  801800:	85 c0                	test   %eax,%eax
  801802:	78 37                	js     80183b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801804:	83 ec 08             	sub    $0x8,%esp
  801807:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180a:	50                   	push   %eax
  80180b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180e:	ff 30                	pushl  (%eax)
  801810:	e8 40 fc ff ff       	call   801455 <dev_lookup>
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	85 c0                	test   %eax,%eax
  80181a:	78 1f                	js     80183b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80181c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801823:	74 1b                	je     801840 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801825:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801828:	8b 52 18             	mov    0x18(%edx),%edx
  80182b:	85 d2                	test   %edx,%edx
  80182d:	74 32                	je     801861 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	ff 75 0c             	pushl  0xc(%ebp)
  801835:	50                   	push   %eax
  801836:	ff d2                	call   *%edx
  801838:	83 c4 10             	add    $0x10,%esp
}
  80183b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801840:	a1 b0 40 80 00       	mov    0x8040b0,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801845:	8b 40 48             	mov    0x48(%eax),%eax
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	53                   	push   %ebx
  80184c:	50                   	push   %eax
  80184d:	68 ec 27 80 00       	push   $0x8027ec
  801852:	e8 c3 ee ff ff       	call   80071a <cprintf>
		return -E_INVAL;
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80185f:	eb da                	jmp    80183b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801861:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801866:	eb d3                	jmp    80183b <ftruncate+0x52>

00801868 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	53                   	push   %ebx
  80186c:	83 ec 14             	sub    $0x14,%esp
  80186f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801872:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801875:	50                   	push   %eax
  801876:	ff 75 08             	pushl  0x8(%ebp)
  801879:	e8 81 fb ff ff       	call   8013ff <fd_lookup>
  80187e:	83 c4 08             	add    $0x8,%esp
  801881:	85 c0                	test   %eax,%eax
  801883:	78 4b                	js     8018d0 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801885:	83 ec 08             	sub    $0x8,%esp
  801888:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188b:	50                   	push   %eax
  80188c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188f:	ff 30                	pushl  (%eax)
  801891:	e8 bf fb ff ff       	call   801455 <dev_lookup>
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	85 c0                	test   %eax,%eax
  80189b:	78 33                	js     8018d0 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80189d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a0:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018a4:	74 2f                	je     8018d5 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018a6:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018a9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018b0:	00 00 00 
	stat->st_isdir = 0;
  8018b3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018ba:	00 00 00 
	stat->st_dev = dev;
  8018bd:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	53                   	push   %ebx
  8018c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8018ca:	ff 50 14             	call   *0x14(%eax)
  8018cd:	83 c4 10             	add    $0x10,%esp
}
  8018d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    
		return -E_NOT_SUPP;
  8018d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018da:	eb f4                	jmp    8018d0 <fstat+0x68>

008018dc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	56                   	push   %esi
  8018e0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	6a 00                	push   $0x0
  8018e6:	ff 75 08             	pushl  0x8(%ebp)
  8018e9:	e8 e7 01 00 00       	call   801ad5 <open>
  8018ee:	89 c3                	mov    %eax,%ebx
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 1b                	js     801912 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	50                   	push   %eax
  8018fe:	e8 65 ff ff ff       	call   801868 <fstat>
  801903:	89 c6                	mov    %eax,%esi
	close(fd);
  801905:	89 1c 24             	mov    %ebx,(%esp)
  801908:	e8 27 fc ff ff       	call   801534 <close>
	return r;
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	89 f3                	mov    %esi,%ebx
}
  801912:	89 d8                	mov    %ebx,%eax
  801914:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    

0080191b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	56                   	push   %esi
  80191f:	53                   	push   %ebx
  801920:	89 c6                	mov    %eax,%esi
  801922:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801924:	83 3d ac 40 80 00 00 	cmpl   $0x0,0x8040ac
  80192b:	74 27                	je     801954 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80192d:	6a 07                	push   $0x7
  80192f:	68 00 50 80 00       	push   $0x805000
  801934:	56                   	push   %esi
  801935:	ff 35 ac 40 80 00    	pushl  0x8040ac
  80193b:	e8 1b 07 00 00       	call   80205b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801940:	83 c4 0c             	add    $0xc,%esp
  801943:	6a 00                	push   $0x0
  801945:	53                   	push   %ebx
  801946:	6a 00                	push   $0x0
  801948:	e8 f7 06 00 00       	call   802044 <ipc_recv>
}
  80194d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801950:	5b                   	pop    %ebx
  801951:	5e                   	pop    %esi
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801954:	83 ec 0c             	sub    $0xc,%esp
  801957:	6a 01                	push   $0x1
  801959:	e8 14 07 00 00       	call   802072 <ipc_find_env>
  80195e:	a3 ac 40 80 00       	mov    %eax,0x8040ac
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	eb c5                	jmp    80192d <fsipc+0x12>

00801968 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	8b 40 0c             	mov    0xc(%eax),%eax
  801974:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801979:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801981:	ba 00 00 00 00       	mov    $0x0,%edx
  801986:	b8 02 00 00 00       	mov    $0x2,%eax
  80198b:	e8 8b ff ff ff       	call   80191b <fsipc>
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <devfile_flush>:
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8b 40 0c             	mov    0xc(%eax),%eax
  80199e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a8:	b8 06 00 00 00       	mov    $0x6,%eax
  8019ad:	e8 69 ff ff ff       	call   80191b <fsipc>
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <devfile_stat>:
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	53                   	push   %ebx
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c4:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ce:	b8 05 00 00 00       	mov    $0x5,%eax
  8019d3:	e8 43 ff ff ff       	call   80191b <fsipc>
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	78 2c                	js     801a08 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019dc:	83 ec 08             	sub    $0x8,%esp
  8019df:	68 00 50 80 00       	push   $0x805000
  8019e4:	53                   	push   %ebx
  8019e5:	e8 1a f3 ff ff       	call   800d04 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019ea:	a1 80 50 80 00       	mov    0x805080,%eax
  8019ef:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019f5:	a1 84 50 80 00       	mov    0x805084,%eax
  8019fa:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a00:	83 c4 10             	add    $0x10,%esp
  801a03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <devfile_write>:
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 0c             	sub    $0xc,%esp
  801a13:	8b 45 10             	mov    0x10(%ebp),%eax
  801a16:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a1b:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a20:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a23:	8b 55 08             	mov    0x8(%ebp),%edx
  801a26:	8b 52 0c             	mov    0xc(%edx),%edx
  801a29:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801a2f:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  801a34:	50                   	push   %eax
  801a35:	ff 75 0c             	pushl  0xc(%ebp)
  801a38:	68 08 50 80 00       	push   $0x805008
  801a3d:	e8 50 f4 ff ff       	call   800e92 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a42:	ba 00 00 00 00       	mov    $0x0,%edx
  801a47:	b8 04 00 00 00       	mov    $0x4,%eax
  801a4c:	e8 ca fe ff ff       	call   80191b <fsipc>
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <devfile_read>:
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
  801a58:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a61:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a66:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a71:	b8 03 00 00 00       	mov    $0x3,%eax
  801a76:	e8 a0 fe ff ff       	call   80191b <fsipc>
  801a7b:	89 c3                	mov    %eax,%ebx
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	78 1f                	js     801aa0 <devfile_read+0x4d>
	assert(r <= n);
  801a81:	39 f0                	cmp    %esi,%eax
  801a83:	77 24                	ja     801aa9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801a85:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a8a:	7f 33                	jg     801abf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	50                   	push   %eax
  801a90:	68 00 50 80 00       	push   $0x805000
  801a95:	ff 75 0c             	pushl  0xc(%ebp)
  801a98:	e8 f5 f3 ff ff       	call   800e92 <memmove>
	return r;
  801a9d:	83 c4 10             	add    $0x10,%esp
}
  801aa0:	89 d8                	mov    %ebx,%eax
  801aa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa5:	5b                   	pop    %ebx
  801aa6:	5e                   	pop    %esi
  801aa7:	5d                   	pop    %ebp
  801aa8:	c3                   	ret    
	assert(r <= n);
  801aa9:	68 5c 28 80 00       	push   $0x80285c
  801aae:	68 63 28 80 00       	push   $0x802863
  801ab3:	6a 7c                	push   $0x7c
  801ab5:	68 78 28 80 00       	push   $0x802878
  801aba:	e8 80 eb ff ff       	call   80063f <_panic>
	assert(r <= PGSIZE);
  801abf:	68 83 28 80 00       	push   $0x802883
  801ac4:	68 63 28 80 00       	push   $0x802863
  801ac9:	6a 7d                	push   $0x7d
  801acb:	68 78 28 80 00       	push   $0x802878
  801ad0:	e8 6a eb ff ff       	call   80063f <_panic>

00801ad5 <open>:
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	56                   	push   %esi
  801ad9:	53                   	push   %ebx
  801ada:	83 ec 1c             	sub    $0x1c,%esp
  801add:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ae0:	56                   	push   %esi
  801ae1:	e8 e7 f1 ff ff       	call   800ccd <strlen>
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aee:	7f 6c                	jg     801b5c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801af0:	83 ec 0c             	sub    $0xc,%esp
  801af3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af6:	50                   	push   %eax
  801af7:	e8 b4 f8 ff ff       	call   8013b0 <fd_alloc>
  801afc:	89 c3                	mov    %eax,%ebx
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	85 c0                	test   %eax,%eax
  801b03:	78 3c                	js     801b41 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b05:	83 ec 08             	sub    $0x8,%esp
  801b08:	56                   	push   %esi
  801b09:	68 00 50 80 00       	push   $0x805000
  801b0e:	e8 f1 f1 ff ff       	call   800d04 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b16:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b23:	e8 f3 fd ff ff       	call   80191b <fsipc>
  801b28:	89 c3                	mov    %eax,%ebx
  801b2a:	83 c4 10             	add    $0x10,%esp
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 19                	js     801b4a <open+0x75>
	return fd2num(fd);
  801b31:	83 ec 0c             	sub    $0xc,%esp
  801b34:	ff 75 f4             	pushl  -0xc(%ebp)
  801b37:	e8 4d f8 ff ff       	call   801389 <fd2num>
  801b3c:	89 c3                	mov    %eax,%ebx
  801b3e:	83 c4 10             	add    $0x10,%esp
}
  801b41:	89 d8                	mov    %ebx,%eax
  801b43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5e                   	pop    %esi
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    
		fd_close(fd, 0);
  801b4a:	83 ec 08             	sub    $0x8,%esp
  801b4d:	6a 00                	push   $0x0
  801b4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801b52:	e8 54 f9 ff ff       	call   8014ab <fd_close>
		return r;
  801b57:	83 c4 10             	add    $0x10,%esp
  801b5a:	eb e5                	jmp    801b41 <open+0x6c>
		return -E_BAD_PATH;
  801b5c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b61:	eb de                	jmp    801b41 <open+0x6c>

00801b63 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b69:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6e:	b8 08 00 00 00       	mov    $0x8,%eax
  801b73:	e8 a3 fd ff ff       	call   80191b <fsipc>
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	56                   	push   %esi
  801b7e:	53                   	push   %ebx
  801b7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b82:	83 ec 0c             	sub    $0xc,%esp
  801b85:	ff 75 08             	pushl  0x8(%ebp)
  801b88:	e8 0c f8 ff ff       	call   801399 <fd2data>
  801b8d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b8f:	83 c4 08             	add    $0x8,%esp
  801b92:	68 8f 28 80 00       	push   $0x80288f
  801b97:	53                   	push   %ebx
  801b98:	e8 67 f1 ff ff       	call   800d04 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b9d:	8b 46 04             	mov    0x4(%esi),%eax
  801ba0:	2b 06                	sub    (%esi),%eax
  801ba2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ba8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801baf:	00 00 00 
	stat->st_dev = &devpipe;
  801bb2:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801bb9:	30 80 00 
	return 0;
}
  801bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc4:	5b                   	pop    %ebx
  801bc5:	5e                   	pop    %esi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    

00801bc8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 0c             	sub    $0xc,%esp
  801bcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801bd2:	53                   	push   %ebx
  801bd3:	6a 00                	push   $0x0
  801bd5:	e8 a8 f5 ff ff       	call   801182 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bda:	89 1c 24             	mov    %ebx,(%esp)
  801bdd:	e8 b7 f7 ff ff       	call   801399 <fd2data>
  801be2:	83 c4 08             	add    $0x8,%esp
  801be5:	50                   	push   %eax
  801be6:	6a 00                	push   $0x0
  801be8:	e8 95 f5 ff ff       	call   801182 <sys_page_unmap>
}
  801bed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <_pipeisclosed>:
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	57                   	push   %edi
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 1c             	sub    $0x1c,%esp
  801bfb:	89 c7                	mov    %eax,%edi
  801bfd:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bff:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801c04:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c07:	83 ec 0c             	sub    $0xc,%esp
  801c0a:	57                   	push   %edi
  801c0b:	e8 9b 04 00 00       	call   8020ab <pageref>
  801c10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c13:	89 34 24             	mov    %esi,(%esp)
  801c16:	e8 90 04 00 00       	call   8020ab <pageref>
		nn = thisenv->env_runs;
  801c1b:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  801c21:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c24:	83 c4 10             	add    $0x10,%esp
  801c27:	39 cb                	cmp    %ecx,%ebx
  801c29:	74 1b                	je     801c46 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c2b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c2e:	75 cf                	jne    801bff <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c30:	8b 42 58             	mov    0x58(%edx),%eax
  801c33:	6a 01                	push   $0x1
  801c35:	50                   	push   %eax
  801c36:	53                   	push   %ebx
  801c37:	68 96 28 80 00       	push   $0x802896
  801c3c:	e8 d9 ea ff ff       	call   80071a <cprintf>
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	eb b9                	jmp    801bff <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c46:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c49:	0f 94 c0             	sete   %al
  801c4c:	0f b6 c0             	movzbl %al,%eax
}
  801c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c52:	5b                   	pop    %ebx
  801c53:	5e                   	pop    %esi
  801c54:	5f                   	pop    %edi
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    

00801c57 <devpipe_write>:
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	57                   	push   %edi
  801c5b:	56                   	push   %esi
  801c5c:	53                   	push   %ebx
  801c5d:	83 ec 28             	sub    $0x28,%esp
  801c60:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c63:	56                   	push   %esi
  801c64:	e8 30 f7 ff ff       	call   801399 <fd2data>
  801c69:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c73:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c76:	74 4f                	je     801cc7 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c78:	8b 43 04             	mov    0x4(%ebx),%eax
  801c7b:	8b 0b                	mov    (%ebx),%ecx
  801c7d:	8d 51 20             	lea    0x20(%ecx),%edx
  801c80:	39 d0                	cmp    %edx,%eax
  801c82:	72 14                	jb     801c98 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c84:	89 da                	mov    %ebx,%edx
  801c86:	89 f0                	mov    %esi,%eax
  801c88:	e8 65 ff ff ff       	call   801bf2 <_pipeisclosed>
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	75 3a                	jne    801ccb <devpipe_write+0x74>
			sys_yield();
  801c91:	e8 48 f4 ff ff       	call   8010de <sys_yield>
  801c96:	eb e0                	jmp    801c78 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c9b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c9f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ca2:	89 c2                	mov    %eax,%edx
  801ca4:	c1 fa 1f             	sar    $0x1f,%edx
  801ca7:	89 d1                	mov    %edx,%ecx
  801ca9:	c1 e9 1b             	shr    $0x1b,%ecx
  801cac:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801caf:	83 e2 1f             	and    $0x1f,%edx
  801cb2:	29 ca                	sub    %ecx,%edx
  801cb4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801cb8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cbc:	83 c0 01             	add    $0x1,%eax
  801cbf:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cc2:	83 c7 01             	add    $0x1,%edi
  801cc5:	eb ac                	jmp    801c73 <devpipe_write+0x1c>
	return i;
  801cc7:	89 f8                	mov    %edi,%eax
  801cc9:	eb 05                	jmp    801cd0 <devpipe_write+0x79>
				return 0;
  801ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cd3:	5b                   	pop    %ebx
  801cd4:	5e                   	pop    %esi
  801cd5:	5f                   	pop    %edi
  801cd6:	5d                   	pop    %ebp
  801cd7:	c3                   	ret    

00801cd8 <devpipe_read>:
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	57                   	push   %edi
  801cdc:	56                   	push   %esi
  801cdd:	53                   	push   %ebx
  801cde:	83 ec 18             	sub    $0x18,%esp
  801ce1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ce4:	57                   	push   %edi
  801ce5:	e8 af f6 ff ff       	call   801399 <fd2data>
  801cea:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	be 00 00 00 00       	mov    $0x0,%esi
  801cf4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cf7:	74 47                	je     801d40 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801cf9:	8b 03                	mov    (%ebx),%eax
  801cfb:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cfe:	75 22                	jne    801d22 <devpipe_read+0x4a>
			if (i > 0)
  801d00:	85 f6                	test   %esi,%esi
  801d02:	75 14                	jne    801d18 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801d04:	89 da                	mov    %ebx,%edx
  801d06:	89 f8                	mov    %edi,%eax
  801d08:	e8 e5 fe ff ff       	call   801bf2 <_pipeisclosed>
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	75 33                	jne    801d44 <devpipe_read+0x6c>
			sys_yield();
  801d11:	e8 c8 f3 ff ff       	call   8010de <sys_yield>
  801d16:	eb e1                	jmp    801cf9 <devpipe_read+0x21>
				return i;
  801d18:	89 f0                	mov    %esi,%eax
}
  801d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d1d:	5b                   	pop    %ebx
  801d1e:	5e                   	pop    %esi
  801d1f:	5f                   	pop    %edi
  801d20:	5d                   	pop    %ebp
  801d21:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d22:	99                   	cltd   
  801d23:	c1 ea 1b             	shr    $0x1b,%edx
  801d26:	01 d0                	add    %edx,%eax
  801d28:	83 e0 1f             	and    $0x1f,%eax
  801d2b:	29 d0                	sub    %edx,%eax
  801d2d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d35:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d38:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d3b:	83 c6 01             	add    $0x1,%esi
  801d3e:	eb b4                	jmp    801cf4 <devpipe_read+0x1c>
	return i;
  801d40:	89 f0                	mov    %esi,%eax
  801d42:	eb d6                	jmp    801d1a <devpipe_read+0x42>
				return 0;
  801d44:	b8 00 00 00 00       	mov    $0x0,%eax
  801d49:	eb cf                	jmp    801d1a <devpipe_read+0x42>

00801d4b <pipe>:
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d56:	50                   	push   %eax
  801d57:	e8 54 f6 ff ff       	call   8013b0 <fd_alloc>
  801d5c:	89 c3                	mov    %eax,%ebx
  801d5e:	83 c4 10             	add    $0x10,%esp
  801d61:	85 c0                	test   %eax,%eax
  801d63:	78 5b                	js     801dc0 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d65:	83 ec 04             	sub    $0x4,%esp
  801d68:	68 07 04 00 00       	push   $0x407
  801d6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d70:	6a 00                	push   $0x0
  801d72:	e8 86 f3 ff ff       	call   8010fd <sys_page_alloc>
  801d77:	89 c3                	mov    %eax,%ebx
  801d79:	83 c4 10             	add    $0x10,%esp
  801d7c:	85 c0                	test   %eax,%eax
  801d7e:	78 40                	js     801dc0 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d80:	83 ec 0c             	sub    $0xc,%esp
  801d83:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d86:	50                   	push   %eax
  801d87:	e8 24 f6 ff ff       	call   8013b0 <fd_alloc>
  801d8c:	89 c3                	mov    %eax,%ebx
  801d8e:	83 c4 10             	add    $0x10,%esp
  801d91:	85 c0                	test   %eax,%eax
  801d93:	78 1b                	js     801db0 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d95:	83 ec 04             	sub    $0x4,%esp
  801d98:	68 07 04 00 00       	push   $0x407
  801d9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801da0:	6a 00                	push   $0x0
  801da2:	e8 56 f3 ff ff       	call   8010fd <sys_page_alloc>
  801da7:	89 c3                	mov    %eax,%ebx
  801da9:	83 c4 10             	add    $0x10,%esp
  801dac:	85 c0                	test   %eax,%eax
  801dae:	79 19                	jns    801dc9 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801db0:	83 ec 08             	sub    $0x8,%esp
  801db3:	ff 75 f4             	pushl  -0xc(%ebp)
  801db6:	6a 00                	push   $0x0
  801db8:	e8 c5 f3 ff ff       	call   801182 <sys_page_unmap>
  801dbd:	83 c4 10             	add    $0x10,%esp
}
  801dc0:	89 d8                	mov    %ebx,%eax
  801dc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc5:	5b                   	pop    %ebx
  801dc6:	5e                   	pop    %esi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    
	va = fd2data(fd0);
  801dc9:	83 ec 0c             	sub    $0xc,%esp
  801dcc:	ff 75 f4             	pushl  -0xc(%ebp)
  801dcf:	e8 c5 f5 ff ff       	call   801399 <fd2data>
  801dd4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd6:	83 c4 0c             	add    $0xc,%esp
  801dd9:	68 07 04 00 00       	push   $0x407
  801dde:	50                   	push   %eax
  801ddf:	6a 00                	push   $0x0
  801de1:	e8 17 f3 ff ff       	call   8010fd <sys_page_alloc>
  801de6:	89 c3                	mov    %eax,%ebx
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	85 c0                	test   %eax,%eax
  801ded:	0f 88 8c 00 00 00    	js     801e7f <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df3:	83 ec 0c             	sub    $0xc,%esp
  801df6:	ff 75 f0             	pushl  -0x10(%ebp)
  801df9:	e8 9b f5 ff ff       	call   801399 <fd2data>
  801dfe:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e05:	50                   	push   %eax
  801e06:	6a 00                	push   $0x0
  801e08:	56                   	push   %esi
  801e09:	6a 00                	push   $0x0
  801e0b:	e8 30 f3 ff ff       	call   801140 <sys_page_map>
  801e10:	89 c3                	mov    %eax,%ebx
  801e12:	83 c4 20             	add    $0x20,%esp
  801e15:	85 c0                	test   %eax,%eax
  801e17:	78 58                	js     801e71 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e22:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e31:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e37:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e43:	83 ec 0c             	sub    $0xc,%esp
  801e46:	ff 75 f4             	pushl  -0xc(%ebp)
  801e49:	e8 3b f5 ff ff       	call   801389 <fd2num>
  801e4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e51:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e53:	83 c4 04             	add    $0x4,%esp
  801e56:	ff 75 f0             	pushl  -0x10(%ebp)
  801e59:	e8 2b f5 ff ff       	call   801389 <fd2num>
  801e5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e61:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e6c:	e9 4f ff ff ff       	jmp    801dc0 <pipe+0x75>
	sys_page_unmap(0, va);
  801e71:	83 ec 08             	sub    $0x8,%esp
  801e74:	56                   	push   %esi
  801e75:	6a 00                	push   $0x0
  801e77:	e8 06 f3 ff ff       	call   801182 <sys_page_unmap>
  801e7c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e7f:	83 ec 08             	sub    $0x8,%esp
  801e82:	ff 75 f0             	pushl  -0x10(%ebp)
  801e85:	6a 00                	push   $0x0
  801e87:	e8 f6 f2 ff ff       	call   801182 <sys_page_unmap>
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	e9 1c ff ff ff       	jmp    801db0 <pipe+0x65>

00801e94 <pipeisclosed>:
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e9d:	50                   	push   %eax
  801e9e:	ff 75 08             	pushl  0x8(%ebp)
  801ea1:	e8 59 f5 ff ff       	call   8013ff <fd_lookup>
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 18                	js     801ec5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ead:	83 ec 0c             	sub    $0xc,%esp
  801eb0:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb3:	e8 e1 f4 ff ff       	call   801399 <fd2data>
	return _pipeisclosed(fd, p);
  801eb8:	89 c2                	mov    %eax,%edx
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	e8 30 fd ff ff       	call   801bf2 <_pipeisclosed>
  801ec2:	83 c4 10             	add    $0x10,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecf:	5d                   	pop    %ebp
  801ed0:	c3                   	ret    

00801ed1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ed7:	68 ae 28 80 00       	push   $0x8028ae
  801edc:	ff 75 0c             	pushl  0xc(%ebp)
  801edf:	e8 20 ee ff ff       	call   800d04 <strcpy>
	return 0;
}
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <devcons_write>:
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	57                   	push   %edi
  801eef:	56                   	push   %esi
  801ef0:	53                   	push   %ebx
  801ef1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ef7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801efc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f02:	eb 2f                	jmp    801f33 <devcons_write+0x48>
		m = n - tot;
  801f04:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f07:	29 f3                	sub    %esi,%ebx
  801f09:	83 fb 7f             	cmp    $0x7f,%ebx
  801f0c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f11:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f14:	83 ec 04             	sub    $0x4,%esp
  801f17:	53                   	push   %ebx
  801f18:	89 f0                	mov    %esi,%eax
  801f1a:	03 45 0c             	add    0xc(%ebp),%eax
  801f1d:	50                   	push   %eax
  801f1e:	57                   	push   %edi
  801f1f:	e8 6e ef ff ff       	call   800e92 <memmove>
		sys_cputs(buf, m);
  801f24:	83 c4 08             	add    $0x8,%esp
  801f27:	53                   	push   %ebx
  801f28:	57                   	push   %edi
  801f29:	e8 13 f1 ff ff       	call   801041 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f2e:	01 de                	add    %ebx,%esi
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f36:	72 cc                	jb     801f04 <devcons_write+0x19>
}
  801f38:	89 f0                	mov    %esi,%eax
  801f3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f3d:	5b                   	pop    %ebx
  801f3e:	5e                   	pop    %esi
  801f3f:	5f                   	pop    %edi
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    

00801f42 <devcons_read>:
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 08             	sub    $0x8,%esp
  801f48:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f51:	75 07                	jne    801f5a <devcons_read+0x18>
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    
		sys_yield();
  801f55:	e8 84 f1 ff ff       	call   8010de <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f5a:	e8 00 f1 ff ff       	call   80105f <sys_cgetc>
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	74 f2                	je     801f55 <devcons_read+0x13>
	if (c < 0)
  801f63:	85 c0                	test   %eax,%eax
  801f65:	78 ec                	js     801f53 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801f67:	83 f8 04             	cmp    $0x4,%eax
  801f6a:	74 0c                	je     801f78 <devcons_read+0x36>
	*(char*)vbuf = c;
  801f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6f:	88 02                	mov    %al,(%edx)
	return 1;
  801f71:	b8 01 00 00 00       	mov    $0x1,%eax
  801f76:	eb db                	jmp    801f53 <devcons_read+0x11>
		return 0;
  801f78:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7d:	eb d4                	jmp    801f53 <devcons_read+0x11>

00801f7f <cputchar>:
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f8b:	6a 01                	push   $0x1
  801f8d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f90:	50                   	push   %eax
  801f91:	e8 ab f0 ff ff       	call   801041 <sys_cputs>
}
  801f96:	83 c4 10             	add    $0x10,%esp
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <getchar>:
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fa1:	6a 01                	push   $0x1
  801fa3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fa6:	50                   	push   %eax
  801fa7:	6a 00                	push   $0x0
  801fa9:	e8 c2 f6 ff ff       	call   801670 <read>
	if (r < 0)
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	78 08                	js     801fbd <getchar+0x22>
	if (r < 1)
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	7e 06                	jle    801fbf <getchar+0x24>
	return c;
  801fb9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    
		return -E_EOF;
  801fbf:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fc4:	eb f7                	jmp    801fbd <getchar+0x22>

00801fc6 <iscons>:
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fcf:	50                   	push   %eax
  801fd0:	ff 75 08             	pushl  0x8(%ebp)
  801fd3:	e8 27 f4 ff ff       	call   8013ff <fd_lookup>
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	78 11                	js     801ff0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fe8:	39 10                	cmp    %edx,(%eax)
  801fea:	0f 94 c0             	sete   %al
  801fed:	0f b6 c0             	movzbl %al,%eax
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <opencons>:
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801ff8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ffb:	50                   	push   %eax
  801ffc:	e8 af f3 ff ff       	call   8013b0 <fd_alloc>
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	85 c0                	test   %eax,%eax
  802006:	78 3a                	js     802042 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802008:	83 ec 04             	sub    $0x4,%esp
  80200b:	68 07 04 00 00       	push   $0x407
  802010:	ff 75 f4             	pushl  -0xc(%ebp)
  802013:	6a 00                	push   $0x0
  802015:	e8 e3 f0 ff ff       	call   8010fd <sys_page_alloc>
  80201a:	83 c4 10             	add    $0x10,%esp
  80201d:	85 c0                	test   %eax,%eax
  80201f:	78 21                	js     802042 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802024:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80202a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802036:	83 ec 0c             	sub    $0xc,%esp
  802039:	50                   	push   %eax
  80203a:	e8 4a f3 ff ff       	call   801389 <fd2num>
  80203f:	83 c4 10             	add    $0x10,%esp
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  80204a:	68 ba 28 80 00       	push   $0x8028ba
  80204f:	6a 1a                	push   $0x1a
  802051:	68 d3 28 80 00       	push   $0x8028d3
  802056:	e8 e4 e5 ff ff       	call   80063f <_panic>

0080205b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  802061:	68 dd 28 80 00       	push   $0x8028dd
  802066:	6a 2a                	push   $0x2a
  802068:	68 d3 28 80 00       	push   $0x8028d3
  80206d:	e8 cd e5 ff ff       	call   80063f <_panic>

00802072 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80207d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802080:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802086:	8b 52 50             	mov    0x50(%edx),%edx
  802089:	39 ca                	cmp    %ecx,%edx
  80208b:	74 11                	je     80209e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80208d:	83 c0 01             	add    $0x1,%eax
  802090:	3d 00 04 00 00       	cmp    $0x400,%eax
  802095:	75 e6                	jne    80207d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
  80209c:	eb 0b                	jmp    8020a9 <ipc_find_env+0x37>
			return envs[i].env_id;
  80209e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020a6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020a9:	5d                   	pop    %ebp
  8020aa:	c3                   	ret    

008020ab <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020b1:	89 d0                	mov    %edx,%eax
  8020b3:	c1 e8 16             	shr    $0x16,%eax
  8020b6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020c2:	f6 c1 01             	test   $0x1,%cl
  8020c5:	74 1d                	je     8020e4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020c7:	c1 ea 0c             	shr    $0xc,%edx
  8020ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020d1:	f6 c2 01             	test   $0x1,%dl
  8020d4:	74 0e                	je     8020e4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020d6:	c1 ea 0c             	shr    $0xc,%edx
  8020d9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020e0:	ef 
  8020e1:	0f b7 c0             	movzwl %ax,%eax
}
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    
  8020e6:	66 90                	xchg   %ax,%ax
  8020e8:	66 90                	xchg   %ax,%ax
  8020ea:	66 90                	xchg   %ax,%ax
  8020ec:	66 90                	xchg   %ax,%ax
  8020ee:	66 90                	xchg   %ax,%ax

008020f0 <__udivdi3>:
  8020f0:	55                   	push   %ebp
  8020f1:	57                   	push   %edi
  8020f2:	56                   	push   %esi
  8020f3:	53                   	push   %ebx
  8020f4:	83 ec 1c             	sub    $0x1c,%esp
  8020f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802103:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802107:	85 d2                	test   %edx,%edx
  802109:	75 35                	jne    802140 <__udivdi3+0x50>
  80210b:	39 f3                	cmp    %esi,%ebx
  80210d:	0f 87 bd 00 00 00    	ja     8021d0 <__udivdi3+0xe0>
  802113:	85 db                	test   %ebx,%ebx
  802115:	89 d9                	mov    %ebx,%ecx
  802117:	75 0b                	jne    802124 <__udivdi3+0x34>
  802119:	b8 01 00 00 00       	mov    $0x1,%eax
  80211e:	31 d2                	xor    %edx,%edx
  802120:	f7 f3                	div    %ebx
  802122:	89 c1                	mov    %eax,%ecx
  802124:	31 d2                	xor    %edx,%edx
  802126:	89 f0                	mov    %esi,%eax
  802128:	f7 f1                	div    %ecx
  80212a:	89 c6                	mov    %eax,%esi
  80212c:	89 e8                	mov    %ebp,%eax
  80212e:	89 f7                	mov    %esi,%edi
  802130:	f7 f1                	div    %ecx
  802132:	89 fa                	mov    %edi,%edx
  802134:	83 c4 1c             	add    $0x1c,%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5f                   	pop    %edi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    
  80213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802140:	39 f2                	cmp    %esi,%edx
  802142:	77 7c                	ja     8021c0 <__udivdi3+0xd0>
  802144:	0f bd fa             	bsr    %edx,%edi
  802147:	83 f7 1f             	xor    $0x1f,%edi
  80214a:	0f 84 98 00 00 00    	je     8021e8 <__udivdi3+0xf8>
  802150:	89 f9                	mov    %edi,%ecx
  802152:	b8 20 00 00 00       	mov    $0x20,%eax
  802157:	29 f8                	sub    %edi,%eax
  802159:	d3 e2                	shl    %cl,%edx
  80215b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80215f:	89 c1                	mov    %eax,%ecx
  802161:	89 da                	mov    %ebx,%edx
  802163:	d3 ea                	shr    %cl,%edx
  802165:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802169:	09 d1                	or     %edx,%ecx
  80216b:	89 f2                	mov    %esi,%edx
  80216d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802171:	89 f9                	mov    %edi,%ecx
  802173:	d3 e3                	shl    %cl,%ebx
  802175:	89 c1                	mov    %eax,%ecx
  802177:	d3 ea                	shr    %cl,%edx
  802179:	89 f9                	mov    %edi,%ecx
  80217b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80217f:	d3 e6                	shl    %cl,%esi
  802181:	89 eb                	mov    %ebp,%ebx
  802183:	89 c1                	mov    %eax,%ecx
  802185:	d3 eb                	shr    %cl,%ebx
  802187:	09 de                	or     %ebx,%esi
  802189:	89 f0                	mov    %esi,%eax
  80218b:	f7 74 24 08          	divl   0x8(%esp)
  80218f:	89 d6                	mov    %edx,%esi
  802191:	89 c3                	mov    %eax,%ebx
  802193:	f7 64 24 0c          	mull   0xc(%esp)
  802197:	39 d6                	cmp    %edx,%esi
  802199:	72 0c                	jb     8021a7 <__udivdi3+0xb7>
  80219b:	89 f9                	mov    %edi,%ecx
  80219d:	d3 e5                	shl    %cl,%ebp
  80219f:	39 c5                	cmp    %eax,%ebp
  8021a1:	73 5d                	jae    802200 <__udivdi3+0x110>
  8021a3:	39 d6                	cmp    %edx,%esi
  8021a5:	75 59                	jne    802200 <__udivdi3+0x110>
  8021a7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021aa:	31 ff                	xor    %edi,%edi
  8021ac:	89 fa                	mov    %edi,%edx
  8021ae:	83 c4 1c             	add    $0x1c,%esp
  8021b1:	5b                   	pop    %ebx
  8021b2:	5e                   	pop    %esi
  8021b3:	5f                   	pop    %edi
  8021b4:	5d                   	pop    %ebp
  8021b5:	c3                   	ret    
  8021b6:	8d 76 00             	lea    0x0(%esi),%esi
  8021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021c0:	31 ff                	xor    %edi,%edi
  8021c2:	31 c0                	xor    %eax,%eax
  8021c4:	89 fa                	mov    %edi,%edx
  8021c6:	83 c4 1c             	add    $0x1c,%esp
  8021c9:	5b                   	pop    %ebx
  8021ca:	5e                   	pop    %esi
  8021cb:	5f                   	pop    %edi
  8021cc:	5d                   	pop    %ebp
  8021cd:	c3                   	ret    
  8021ce:	66 90                	xchg   %ax,%ax
  8021d0:	31 ff                	xor    %edi,%edi
  8021d2:	89 e8                	mov    %ebp,%eax
  8021d4:	89 f2                	mov    %esi,%edx
  8021d6:	f7 f3                	div    %ebx
  8021d8:	89 fa                	mov    %edi,%edx
  8021da:	83 c4 1c             	add    $0x1c,%esp
  8021dd:	5b                   	pop    %ebx
  8021de:	5e                   	pop    %esi
  8021df:	5f                   	pop    %edi
  8021e0:	5d                   	pop    %ebp
  8021e1:	c3                   	ret    
  8021e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021e8:	39 f2                	cmp    %esi,%edx
  8021ea:	72 06                	jb     8021f2 <__udivdi3+0x102>
  8021ec:	31 c0                	xor    %eax,%eax
  8021ee:	39 eb                	cmp    %ebp,%ebx
  8021f0:	77 d2                	ja     8021c4 <__udivdi3+0xd4>
  8021f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f7:	eb cb                	jmp    8021c4 <__udivdi3+0xd4>
  8021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802200:	89 d8                	mov    %ebx,%eax
  802202:	31 ff                	xor    %edi,%edi
  802204:	eb be                	jmp    8021c4 <__udivdi3+0xd4>
  802206:	66 90                	xchg   %ax,%ax
  802208:	66 90                	xchg   %ax,%ax
  80220a:	66 90                	xchg   %ax,%ax
  80220c:	66 90                	xchg   %ax,%ax
  80220e:	66 90                	xchg   %ax,%ax

00802210 <__umoddi3>:
  802210:	55                   	push   %ebp
  802211:	57                   	push   %edi
  802212:	56                   	push   %esi
  802213:	53                   	push   %ebx
  802214:	83 ec 1c             	sub    $0x1c,%esp
  802217:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80221b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80221f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802223:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802227:	85 ed                	test   %ebp,%ebp
  802229:	89 f0                	mov    %esi,%eax
  80222b:	89 da                	mov    %ebx,%edx
  80222d:	75 19                	jne    802248 <__umoddi3+0x38>
  80222f:	39 df                	cmp    %ebx,%edi
  802231:	0f 86 b1 00 00 00    	jbe    8022e8 <__umoddi3+0xd8>
  802237:	f7 f7                	div    %edi
  802239:	89 d0                	mov    %edx,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	83 c4 1c             	add    $0x1c,%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5f                   	pop    %edi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    
  802245:	8d 76 00             	lea    0x0(%esi),%esi
  802248:	39 dd                	cmp    %ebx,%ebp
  80224a:	77 f1                	ja     80223d <__umoddi3+0x2d>
  80224c:	0f bd cd             	bsr    %ebp,%ecx
  80224f:	83 f1 1f             	xor    $0x1f,%ecx
  802252:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802256:	0f 84 b4 00 00 00    	je     802310 <__umoddi3+0x100>
  80225c:	b8 20 00 00 00       	mov    $0x20,%eax
  802261:	89 c2                	mov    %eax,%edx
  802263:	8b 44 24 04          	mov    0x4(%esp),%eax
  802267:	29 c2                	sub    %eax,%edx
  802269:	89 c1                	mov    %eax,%ecx
  80226b:	89 f8                	mov    %edi,%eax
  80226d:	d3 e5                	shl    %cl,%ebp
  80226f:	89 d1                	mov    %edx,%ecx
  802271:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802275:	d3 e8                	shr    %cl,%eax
  802277:	09 c5                	or     %eax,%ebp
  802279:	8b 44 24 04          	mov    0x4(%esp),%eax
  80227d:	89 c1                	mov    %eax,%ecx
  80227f:	d3 e7                	shl    %cl,%edi
  802281:	89 d1                	mov    %edx,%ecx
  802283:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802287:	89 df                	mov    %ebx,%edi
  802289:	d3 ef                	shr    %cl,%edi
  80228b:	89 c1                	mov    %eax,%ecx
  80228d:	89 f0                	mov    %esi,%eax
  80228f:	d3 e3                	shl    %cl,%ebx
  802291:	89 d1                	mov    %edx,%ecx
  802293:	89 fa                	mov    %edi,%edx
  802295:	d3 e8                	shr    %cl,%eax
  802297:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80229c:	09 d8                	or     %ebx,%eax
  80229e:	f7 f5                	div    %ebp
  8022a0:	d3 e6                	shl    %cl,%esi
  8022a2:	89 d1                	mov    %edx,%ecx
  8022a4:	f7 64 24 08          	mull   0x8(%esp)
  8022a8:	39 d1                	cmp    %edx,%ecx
  8022aa:	89 c3                	mov    %eax,%ebx
  8022ac:	89 d7                	mov    %edx,%edi
  8022ae:	72 06                	jb     8022b6 <__umoddi3+0xa6>
  8022b0:	75 0e                	jne    8022c0 <__umoddi3+0xb0>
  8022b2:	39 c6                	cmp    %eax,%esi
  8022b4:	73 0a                	jae    8022c0 <__umoddi3+0xb0>
  8022b6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8022ba:	19 ea                	sbb    %ebp,%edx
  8022bc:	89 d7                	mov    %edx,%edi
  8022be:	89 c3                	mov    %eax,%ebx
  8022c0:	89 ca                	mov    %ecx,%edx
  8022c2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022c7:	29 de                	sub    %ebx,%esi
  8022c9:	19 fa                	sbb    %edi,%edx
  8022cb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022cf:	89 d0                	mov    %edx,%eax
  8022d1:	d3 e0                	shl    %cl,%eax
  8022d3:	89 d9                	mov    %ebx,%ecx
  8022d5:	d3 ee                	shr    %cl,%esi
  8022d7:	d3 ea                	shr    %cl,%edx
  8022d9:	09 f0                	or     %esi,%eax
  8022db:	83 c4 1c             	add    $0x1c,%esp
  8022de:	5b                   	pop    %ebx
  8022df:	5e                   	pop    %esi
  8022e0:	5f                   	pop    %edi
  8022e1:	5d                   	pop    %ebp
  8022e2:	c3                   	ret    
  8022e3:	90                   	nop
  8022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022e8:	85 ff                	test   %edi,%edi
  8022ea:	89 f9                	mov    %edi,%ecx
  8022ec:	75 0b                	jne    8022f9 <__umoddi3+0xe9>
  8022ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f3:	31 d2                	xor    %edx,%edx
  8022f5:	f7 f7                	div    %edi
  8022f7:	89 c1                	mov    %eax,%ecx
  8022f9:	89 d8                	mov    %ebx,%eax
  8022fb:	31 d2                	xor    %edx,%edx
  8022fd:	f7 f1                	div    %ecx
  8022ff:	89 f0                	mov    %esi,%eax
  802301:	f7 f1                	div    %ecx
  802303:	e9 31 ff ff ff       	jmp    802239 <__umoddi3+0x29>
  802308:	90                   	nop
  802309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802310:	39 dd                	cmp    %ebx,%ebp
  802312:	72 08                	jb     80231c <__umoddi3+0x10c>
  802314:	39 f7                	cmp    %esi,%edi
  802316:	0f 87 21 ff ff ff    	ja     80223d <__umoddi3+0x2d>
  80231c:	89 da                	mov    %ebx,%edx
  80231e:	89 f0                	mov    %esi,%eax
  802320:	29 f8                	sub    %edi,%eax
  802322:	19 ea                	sbb    %ebp,%edx
  802324:	e9 14 ff ff ff       	jmp    80223d <__umoddi3+0x2d>
