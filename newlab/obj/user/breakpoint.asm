
obj/user/breakpoint.debug：     文件格式 elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $3");
  800036:	cc                   	int3   
}
  800037:	5d                   	pop    %ebp
  800038:	c3                   	ret    

00800039 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800041:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800044:	e8 ce 00 00 00       	call   800117 <sys_getenvid>
  800049:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800051:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800056:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005b:	85 db                	test   %ebx,%ebx
  80005d:	7e 07                	jle    800066 <libmain+0x2d>
		binaryname = argv[0];
  80005f:	8b 06                	mov    (%esi),%eax
  800061:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	e8 c3 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800070:	e8 0a 00 00 00       	call   80007f <exit>
}
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007b:	5b                   	pop    %ebx
  80007c:	5e                   	pop    %esi
  80007d:	5d                   	pop    %ebp
  80007e:	c3                   	ret    

0080007f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80007f:	55                   	push   %ebp
  800080:	89 e5                	mov    %esp,%ebp
  800082:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800085:	e8 92 04 00 00       	call   80051c <close_all>
	sys_env_destroy(0);
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	6a 00                	push   $0x0
  80008f:	e8 42 00 00 00       	call   8000d6 <sys_env_destroy>
}
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	c9                   	leave  
  800098:	c3                   	ret    

00800099 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	57                   	push   %edi
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80009f:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000aa:	89 c3                	mov    %eax,%ebx
  8000ac:	89 c7                	mov    %eax,%edi
  8000ae:	89 c6                	mov    %eax,%esi
  8000b0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b2:	5b                   	pop    %ebx
  8000b3:	5e                   	pop    %esi
  8000b4:	5f                   	pop    %edi
  8000b5:	5d                   	pop    %ebp
  8000b6:	c3                   	ret    

008000b7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	57                   	push   %edi
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c7:	89 d1                	mov    %edx,%ecx
  8000c9:	89 d3                	mov    %edx,%ebx
  8000cb:	89 d7                	mov    %edx,%edi
  8000cd:	89 d6                	mov    %edx,%esi
  8000cf:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d1:	5b                   	pop    %ebx
  8000d2:	5e                   	pop    %esi
  8000d3:	5f                   	pop    %edi
  8000d4:	5d                   	pop    %ebp
  8000d5:	c3                   	ret    

008000d6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	57                   	push   %edi
  8000da:	56                   	push   %esi
  8000db:	53                   	push   %ebx
  8000dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ec:	89 cb                	mov    %ecx,%ebx
  8000ee:	89 cf                	mov    %ecx,%edi
  8000f0:	89 ce                	mov    %ecx,%esi
  8000f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	7f 08                	jg     800100 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000fb:	5b                   	pop    %ebx
  8000fc:	5e                   	pop    %esi
  8000fd:	5f                   	pop    %edi
  8000fe:	5d                   	pop    %ebp
  8000ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	50                   	push   %eax
  800104:	6a 03                	push   $0x3
  800106:	68 0a 1d 80 00       	push   $0x801d0a
  80010b:	6a 23                	push   $0x23
  80010d:	68 27 1d 80 00       	push   $0x801d27
  800112:	e8 ea 0e 00 00       	call   801001 <_panic>

00800117 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800117:	55                   	push   %ebp
  800118:	89 e5                	mov    %esp,%ebp
  80011a:	57                   	push   %edi
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80011d:	ba 00 00 00 00       	mov    $0x0,%edx
  800122:	b8 02 00 00 00       	mov    $0x2,%eax
  800127:	89 d1                	mov    %edx,%ecx
  800129:	89 d3                	mov    %edx,%ebx
  80012b:	89 d7                	mov    %edx,%edi
  80012d:	89 d6                	mov    %edx,%esi
  80012f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800131:	5b                   	pop    %ebx
  800132:	5e                   	pop    %esi
  800133:	5f                   	pop    %edi
  800134:	5d                   	pop    %ebp
  800135:	c3                   	ret    

00800136 <sys_yield>:

void
sys_yield(void)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	57                   	push   %edi
  80013a:	56                   	push   %esi
  80013b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013c:	ba 00 00 00 00       	mov    $0x0,%edx
  800141:	b8 0b 00 00 00       	mov    $0xb,%eax
  800146:	89 d1                	mov    %edx,%ecx
  800148:	89 d3                	mov    %edx,%ebx
  80014a:	89 d7                	mov    %edx,%edi
  80014c:	89 d6                	mov    %edx,%esi
  80014e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800150:	5b                   	pop    %ebx
  800151:	5e                   	pop    %esi
  800152:	5f                   	pop    %edi
  800153:	5d                   	pop    %ebp
  800154:	c3                   	ret    

00800155 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	57                   	push   %edi
  800159:	56                   	push   %esi
  80015a:	53                   	push   %ebx
  80015b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80015e:	be 00 00 00 00       	mov    $0x0,%esi
  800163:	8b 55 08             	mov    0x8(%ebp),%edx
  800166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800169:	b8 04 00 00 00       	mov    $0x4,%eax
  80016e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800171:	89 f7                	mov    %esi,%edi
  800173:	cd 30                	int    $0x30
	if(check && ret > 0)
  800175:	85 c0                	test   %eax,%eax
  800177:	7f 08                	jg     800181 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017c:	5b                   	pop    %ebx
  80017d:	5e                   	pop    %esi
  80017e:	5f                   	pop    %edi
  80017f:	5d                   	pop    %ebp
  800180:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	6a 04                	push   $0x4
  800187:	68 0a 1d 80 00       	push   $0x801d0a
  80018c:	6a 23                	push   $0x23
  80018e:	68 27 1d 80 00       	push   $0x801d27
  800193:	e8 69 0e 00 00       	call   801001 <_panic>

00800198 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	57                   	push   %edi
  80019c:	56                   	push   %esi
  80019d:	53                   	push   %ebx
  80019e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001af:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b2:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	7f 08                	jg     8001c3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001be:	5b                   	pop    %ebx
  8001bf:	5e                   	pop    %esi
  8001c0:	5f                   	pop    %edi
  8001c1:	5d                   	pop    %ebp
  8001c2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c3:	83 ec 0c             	sub    $0xc,%esp
  8001c6:	50                   	push   %eax
  8001c7:	6a 05                	push   $0x5
  8001c9:	68 0a 1d 80 00       	push   $0x801d0a
  8001ce:	6a 23                	push   $0x23
  8001d0:	68 27 1d 80 00       	push   $0x801d27
  8001d5:	e8 27 0e 00 00       	call   801001 <_panic>

008001da <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	57                   	push   %edi
  8001de:	56                   	push   %esi
  8001df:	53                   	push   %ebx
  8001e0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8001f3:	89 df                	mov    %ebx,%edi
  8001f5:	89 de                	mov    %ebx,%esi
  8001f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f9:	85 c0                	test   %eax,%eax
  8001fb:	7f 08                	jg     800205 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800200:	5b                   	pop    %ebx
  800201:	5e                   	pop    %esi
  800202:	5f                   	pop    %edi
  800203:	5d                   	pop    %ebp
  800204:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	50                   	push   %eax
  800209:	6a 06                	push   $0x6
  80020b:	68 0a 1d 80 00       	push   $0x801d0a
  800210:	6a 23                	push   $0x23
  800212:	68 27 1d 80 00       	push   $0x801d27
  800217:	e8 e5 0d 00 00       	call   801001 <_panic>

0080021c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	57                   	push   %edi
  800220:	56                   	push   %esi
  800221:	53                   	push   %ebx
  800222:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800225:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022a:	8b 55 08             	mov    0x8(%ebp),%edx
  80022d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800230:	b8 08 00 00 00       	mov    $0x8,%eax
  800235:	89 df                	mov    %ebx,%edi
  800237:	89 de                	mov    %ebx,%esi
  800239:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023b:	85 c0                	test   %eax,%eax
  80023d:	7f 08                	jg     800247 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80023f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800242:	5b                   	pop    %ebx
  800243:	5e                   	pop    %esi
  800244:	5f                   	pop    %edi
  800245:	5d                   	pop    %ebp
  800246:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	50                   	push   %eax
  80024b:	6a 08                	push   $0x8
  80024d:	68 0a 1d 80 00       	push   $0x801d0a
  800252:	6a 23                	push   $0x23
  800254:	68 27 1d 80 00       	push   $0x801d27
  800259:	e8 a3 0d 00 00       	call   801001 <_panic>

0080025e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	57                   	push   %edi
  800262:	56                   	push   %esi
  800263:	53                   	push   %ebx
  800264:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800267:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026c:	8b 55 08             	mov    0x8(%ebp),%edx
  80026f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800272:	b8 09 00 00 00       	mov    $0x9,%eax
  800277:	89 df                	mov    %ebx,%edi
  800279:	89 de                	mov    %ebx,%esi
  80027b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027d:	85 c0                	test   %eax,%eax
  80027f:	7f 08                	jg     800289 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800281:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800284:	5b                   	pop    %ebx
  800285:	5e                   	pop    %esi
  800286:	5f                   	pop    %edi
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	50                   	push   %eax
  80028d:	6a 09                	push   $0x9
  80028f:	68 0a 1d 80 00       	push   $0x801d0a
  800294:	6a 23                	push   $0x23
  800296:	68 27 1d 80 00       	push   $0x801d27
  80029b:	e8 61 0d 00 00       	call   801001 <_panic>

008002a0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002b9:	89 df                	mov    %ebx,%edi
  8002bb:	89 de                	mov    %ebx,%esi
  8002bd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	7f 08                	jg     8002cb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5e                   	pop    %esi
  8002c8:	5f                   	pop    %edi
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	6a 0a                	push   $0xa
  8002d1:	68 0a 1d 80 00       	push   $0x801d0a
  8002d6:	6a 23                	push   $0x23
  8002d8:	68 27 1d 80 00       	push   $0x801d27
  8002dd:	e8 1f 0d 00 00       	call   801001 <_panic>

008002e2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	57                   	push   %edi
  8002e6:	56                   	push   %esi
  8002e7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8002e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ee:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f3:	be 00 00 00 00       	mov    $0x0,%esi
  8002f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fe:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800300:	5b                   	pop    %ebx
  800301:	5e                   	pop    %esi
  800302:	5f                   	pop    %edi
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	57                   	push   %edi
  800309:	56                   	push   %esi
  80030a:	53                   	push   %ebx
  80030b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800313:	8b 55 08             	mov    0x8(%ebp),%edx
  800316:	b8 0d 00 00 00       	mov    $0xd,%eax
  80031b:	89 cb                	mov    %ecx,%ebx
  80031d:	89 cf                	mov    %ecx,%edi
  80031f:	89 ce                	mov    %ecx,%esi
  800321:	cd 30                	int    $0x30
	if(check && ret > 0)
  800323:	85 c0                	test   %eax,%eax
  800325:	7f 08                	jg     80032f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032a:	5b                   	pop    %ebx
  80032b:	5e                   	pop    %esi
  80032c:	5f                   	pop    %edi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	50                   	push   %eax
  800333:	6a 0d                	push   $0xd
  800335:	68 0a 1d 80 00       	push   $0x801d0a
  80033a:	6a 23                	push   $0x23
  80033c:	68 27 1d 80 00       	push   $0x801d27
  800341:	e8 bb 0c 00 00       	call   801001 <_panic>

00800346 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800349:	8b 45 08             	mov    0x8(%ebp),%eax
  80034c:	05 00 00 00 30       	add    $0x30000000,%eax
  800351:	c1 e8 0c             	shr    $0xc,%eax
}
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    

00800356 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800359:	8b 45 08             	mov    0x8(%ebp),%eax
  80035c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800361:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800366:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80036b:	5d                   	pop    %ebp
  80036c:	c3                   	ret    

0080036d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800373:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800378:	89 c2                	mov    %eax,%edx
  80037a:	c1 ea 16             	shr    $0x16,%edx
  80037d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800384:	f6 c2 01             	test   $0x1,%dl
  800387:	74 2a                	je     8003b3 <fd_alloc+0x46>
  800389:	89 c2                	mov    %eax,%edx
  80038b:	c1 ea 0c             	shr    $0xc,%edx
  80038e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800395:	f6 c2 01             	test   $0x1,%dl
  800398:	74 19                	je     8003b3 <fd_alloc+0x46>
  80039a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80039f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8003a4:	75 d2                	jne    800378 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8003a6:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8003ac:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8003b1:	eb 07                	jmp    8003ba <fd_alloc+0x4d>
			*fd_store = fd;
  8003b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8003b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003ba:	5d                   	pop    %ebp
  8003bb:	c3                   	ret    

008003bc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8003c2:	83 f8 1f             	cmp    $0x1f,%eax
  8003c5:	77 36                	ja     8003fd <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8003c7:	c1 e0 0c             	shl    $0xc,%eax
  8003ca:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8003cf:	89 c2                	mov    %eax,%edx
  8003d1:	c1 ea 16             	shr    $0x16,%edx
  8003d4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003db:	f6 c2 01             	test   $0x1,%dl
  8003de:	74 24                	je     800404 <fd_lookup+0x48>
  8003e0:	89 c2                	mov    %eax,%edx
  8003e2:	c1 ea 0c             	shr    $0xc,%edx
  8003e5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003ec:	f6 c2 01             	test   $0x1,%dl
  8003ef:	74 1a                	je     80040b <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8003f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f4:	89 02                	mov    %eax,(%edx)
	return 0;
  8003f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003fb:	5d                   	pop    %ebp
  8003fc:	c3                   	ret    
		return -E_INVAL;
  8003fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800402:	eb f7                	jmp    8003fb <fd_lookup+0x3f>
		return -E_INVAL;
  800404:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800409:	eb f0                	jmp    8003fb <fd_lookup+0x3f>
  80040b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800410:	eb e9                	jmp    8003fb <fd_lookup+0x3f>

00800412 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 08             	sub    $0x8,%esp
  800418:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80041b:	ba b4 1d 80 00       	mov    $0x801db4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800420:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800425:	39 08                	cmp    %ecx,(%eax)
  800427:	74 33                	je     80045c <dev_lookup+0x4a>
  800429:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80042c:	8b 02                	mov    (%edx),%eax
  80042e:	85 c0                	test   %eax,%eax
  800430:	75 f3                	jne    800425 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800432:	a1 04 40 80 00       	mov    0x804004,%eax
  800437:	8b 40 48             	mov    0x48(%eax),%eax
  80043a:	83 ec 04             	sub    $0x4,%esp
  80043d:	51                   	push   %ecx
  80043e:	50                   	push   %eax
  80043f:	68 38 1d 80 00       	push   $0x801d38
  800444:	e8 93 0c 00 00       	call   8010dc <cprintf>
	*dev = 0;
  800449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800452:	83 c4 10             	add    $0x10,%esp
  800455:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    
			*dev = devtab[i];
  80045c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80045f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800461:	b8 00 00 00 00       	mov    $0x0,%eax
  800466:	eb f2                	jmp    80045a <dev_lookup+0x48>

00800468 <fd_close>:
{
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	57                   	push   %edi
  80046c:	56                   	push   %esi
  80046d:	53                   	push   %ebx
  80046e:	83 ec 1c             	sub    $0x1c,%esp
  800471:	8b 75 08             	mov    0x8(%ebp),%esi
  800474:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800477:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80047a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80047b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800481:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800484:	50                   	push   %eax
  800485:	e8 32 ff ff ff       	call   8003bc <fd_lookup>
  80048a:	89 c3                	mov    %eax,%ebx
  80048c:	83 c4 08             	add    $0x8,%esp
  80048f:	85 c0                	test   %eax,%eax
  800491:	78 05                	js     800498 <fd_close+0x30>
	    || fd != fd2)
  800493:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800496:	74 16                	je     8004ae <fd_close+0x46>
		return (must_exist ? r : 0);
  800498:	89 f8                	mov    %edi,%eax
  80049a:	84 c0                	test   %al,%al
  80049c:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a1:	0f 44 d8             	cmove  %eax,%ebx
}
  8004a4:	89 d8                	mov    %ebx,%eax
  8004a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004a9:	5b                   	pop    %ebx
  8004aa:	5e                   	pop    %esi
  8004ab:	5f                   	pop    %edi
  8004ac:	5d                   	pop    %ebp
  8004ad:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004b4:	50                   	push   %eax
  8004b5:	ff 36                	pushl  (%esi)
  8004b7:	e8 56 ff ff ff       	call   800412 <dev_lookup>
  8004bc:	89 c3                	mov    %eax,%ebx
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	85 c0                	test   %eax,%eax
  8004c3:	78 15                	js     8004da <fd_close+0x72>
		if (dev->dev_close)
  8004c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c8:	8b 40 10             	mov    0x10(%eax),%eax
  8004cb:	85 c0                	test   %eax,%eax
  8004cd:	74 1b                	je     8004ea <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	56                   	push   %esi
  8004d3:	ff d0                	call   *%eax
  8004d5:	89 c3                	mov    %eax,%ebx
  8004d7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	56                   	push   %esi
  8004de:	6a 00                	push   $0x0
  8004e0:	e8 f5 fc ff ff       	call   8001da <sys_page_unmap>
	return r;
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	eb ba                	jmp    8004a4 <fd_close+0x3c>
			r = 0;
  8004ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004ef:	eb e9                	jmp    8004da <fd_close+0x72>

008004f1 <close>:

int
close(int fdnum)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004fa:	50                   	push   %eax
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 b9 fe ff ff       	call   8003bc <fd_lookup>
  800503:	83 c4 08             	add    $0x8,%esp
  800506:	85 c0                	test   %eax,%eax
  800508:	78 10                	js     80051a <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	6a 01                	push   $0x1
  80050f:	ff 75 f4             	pushl  -0xc(%ebp)
  800512:	e8 51 ff ff ff       	call   800468 <fd_close>
  800517:	83 c4 10             	add    $0x10,%esp
}
  80051a:	c9                   	leave  
  80051b:	c3                   	ret    

0080051c <close_all>:

void
close_all(void)
{
  80051c:	55                   	push   %ebp
  80051d:	89 e5                	mov    %esp,%ebp
  80051f:	53                   	push   %ebx
  800520:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800523:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800528:	83 ec 0c             	sub    $0xc,%esp
  80052b:	53                   	push   %ebx
  80052c:	e8 c0 ff ff ff       	call   8004f1 <close>
	for (i = 0; i < MAXFD; i++)
  800531:	83 c3 01             	add    $0x1,%ebx
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	83 fb 20             	cmp    $0x20,%ebx
  80053a:	75 ec                	jne    800528 <close_all+0xc>
}
  80053c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80053f:	c9                   	leave  
  800540:	c3                   	ret    

00800541 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800541:	55                   	push   %ebp
  800542:	89 e5                	mov    %esp,%ebp
  800544:	57                   	push   %edi
  800545:	56                   	push   %esi
  800546:	53                   	push   %ebx
  800547:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80054a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80054d:	50                   	push   %eax
  80054e:	ff 75 08             	pushl  0x8(%ebp)
  800551:	e8 66 fe ff ff       	call   8003bc <fd_lookup>
  800556:	89 c3                	mov    %eax,%ebx
  800558:	83 c4 08             	add    $0x8,%esp
  80055b:	85 c0                	test   %eax,%eax
  80055d:	0f 88 81 00 00 00    	js     8005e4 <dup+0xa3>
		return r;
	close(newfdnum);
  800563:	83 ec 0c             	sub    $0xc,%esp
  800566:	ff 75 0c             	pushl  0xc(%ebp)
  800569:	e8 83 ff ff ff       	call   8004f1 <close>

	newfd = INDEX2FD(newfdnum);
  80056e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800571:	c1 e6 0c             	shl    $0xc,%esi
  800574:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80057a:	83 c4 04             	add    $0x4,%esp
  80057d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800580:	e8 d1 fd ff ff       	call   800356 <fd2data>
  800585:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800587:	89 34 24             	mov    %esi,(%esp)
  80058a:	e8 c7 fd ff ff       	call   800356 <fd2data>
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800594:	89 d8                	mov    %ebx,%eax
  800596:	c1 e8 16             	shr    $0x16,%eax
  800599:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8005a0:	a8 01                	test   $0x1,%al
  8005a2:	74 11                	je     8005b5 <dup+0x74>
  8005a4:	89 d8                	mov    %ebx,%eax
  8005a6:	c1 e8 0c             	shr    $0xc,%eax
  8005a9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8005b0:	f6 c2 01             	test   $0x1,%dl
  8005b3:	75 39                	jne    8005ee <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8005b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005b8:	89 d0                	mov    %edx,%eax
  8005ba:	c1 e8 0c             	shr    $0xc,%eax
  8005bd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005c4:	83 ec 0c             	sub    $0xc,%esp
  8005c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8005cc:	50                   	push   %eax
  8005cd:	56                   	push   %esi
  8005ce:	6a 00                	push   $0x0
  8005d0:	52                   	push   %edx
  8005d1:	6a 00                	push   $0x0
  8005d3:	e8 c0 fb ff ff       	call   800198 <sys_page_map>
  8005d8:	89 c3                	mov    %eax,%ebx
  8005da:	83 c4 20             	add    $0x20,%esp
  8005dd:	85 c0                	test   %eax,%eax
  8005df:	78 31                	js     800612 <dup+0xd1>
		goto err;

	return newfdnum;
  8005e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8005e4:	89 d8                	mov    %ebx,%eax
  8005e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005e9:	5b                   	pop    %ebx
  8005ea:	5e                   	pop    %esi
  8005eb:	5f                   	pop    %edi
  8005ec:	5d                   	pop    %ebp
  8005ed:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8005ee:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8005f5:	83 ec 0c             	sub    $0xc,%esp
  8005f8:	25 07 0e 00 00       	and    $0xe07,%eax
  8005fd:	50                   	push   %eax
  8005fe:	57                   	push   %edi
  8005ff:	6a 00                	push   $0x0
  800601:	53                   	push   %ebx
  800602:	6a 00                	push   $0x0
  800604:	e8 8f fb ff ff       	call   800198 <sys_page_map>
  800609:	89 c3                	mov    %eax,%ebx
  80060b:	83 c4 20             	add    $0x20,%esp
  80060e:	85 c0                	test   %eax,%eax
  800610:	79 a3                	jns    8005b5 <dup+0x74>
	sys_page_unmap(0, newfd);
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	56                   	push   %esi
  800616:	6a 00                	push   $0x0
  800618:	e8 bd fb ff ff       	call   8001da <sys_page_unmap>
	sys_page_unmap(0, nva);
  80061d:	83 c4 08             	add    $0x8,%esp
  800620:	57                   	push   %edi
  800621:	6a 00                	push   $0x0
  800623:	e8 b2 fb ff ff       	call   8001da <sys_page_unmap>
	return r;
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	eb b7                	jmp    8005e4 <dup+0xa3>

0080062d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80062d:	55                   	push   %ebp
  80062e:	89 e5                	mov    %esp,%ebp
  800630:	53                   	push   %ebx
  800631:	83 ec 14             	sub    $0x14,%esp
  800634:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800637:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80063a:	50                   	push   %eax
  80063b:	53                   	push   %ebx
  80063c:	e8 7b fd ff ff       	call   8003bc <fd_lookup>
  800641:	83 c4 08             	add    $0x8,%esp
  800644:	85 c0                	test   %eax,%eax
  800646:	78 3f                	js     800687 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80064e:	50                   	push   %eax
  80064f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800652:	ff 30                	pushl  (%eax)
  800654:	e8 b9 fd ff ff       	call   800412 <dev_lookup>
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	85 c0                	test   %eax,%eax
  80065e:	78 27                	js     800687 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800660:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800663:	8b 42 08             	mov    0x8(%edx),%eax
  800666:	83 e0 03             	and    $0x3,%eax
  800669:	83 f8 01             	cmp    $0x1,%eax
  80066c:	74 1e                	je     80068c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80066e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800671:	8b 40 08             	mov    0x8(%eax),%eax
  800674:	85 c0                	test   %eax,%eax
  800676:	74 35                	je     8006ad <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800678:	83 ec 04             	sub    $0x4,%esp
  80067b:	ff 75 10             	pushl  0x10(%ebp)
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	52                   	push   %edx
  800682:	ff d0                	call   *%eax
  800684:	83 c4 10             	add    $0x10,%esp
}
  800687:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80068a:	c9                   	leave  
  80068b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80068c:	a1 04 40 80 00       	mov    0x804004,%eax
  800691:	8b 40 48             	mov    0x48(%eax),%eax
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	53                   	push   %ebx
  800698:	50                   	push   %eax
  800699:	68 79 1d 80 00       	push   $0x801d79
  80069e:	e8 39 0a 00 00       	call   8010dc <cprintf>
		return -E_INVAL;
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ab:	eb da                	jmp    800687 <read+0x5a>
		return -E_NOT_SUPP;
  8006ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8006b2:	eb d3                	jmp    800687 <read+0x5a>

008006b4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	57                   	push   %edi
  8006b8:	56                   	push   %esi
  8006b9:	53                   	push   %ebx
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006c0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8006c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006c8:	39 f3                	cmp    %esi,%ebx
  8006ca:	73 25                	jae    8006f1 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006cc:	83 ec 04             	sub    $0x4,%esp
  8006cf:	89 f0                	mov    %esi,%eax
  8006d1:	29 d8                	sub    %ebx,%eax
  8006d3:	50                   	push   %eax
  8006d4:	89 d8                	mov    %ebx,%eax
  8006d6:	03 45 0c             	add    0xc(%ebp),%eax
  8006d9:	50                   	push   %eax
  8006da:	57                   	push   %edi
  8006db:	e8 4d ff ff ff       	call   80062d <read>
		if (m < 0)
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	78 08                	js     8006ef <readn+0x3b>
			return m;
		if (m == 0)
  8006e7:	85 c0                	test   %eax,%eax
  8006e9:	74 06                	je     8006f1 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8006eb:	01 c3                	add    %eax,%ebx
  8006ed:	eb d9                	jmp    8006c8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8006ef:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8006f1:	89 d8                	mov    %ebx,%eax
  8006f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f6:	5b                   	pop    %ebx
  8006f7:	5e                   	pop    %esi
  8006f8:	5f                   	pop    %edi
  8006f9:	5d                   	pop    %ebp
  8006fa:	c3                   	ret    

008006fb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	53                   	push   %ebx
  8006ff:	83 ec 14             	sub    $0x14,%esp
  800702:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800705:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800708:	50                   	push   %eax
  800709:	53                   	push   %ebx
  80070a:	e8 ad fc ff ff       	call   8003bc <fd_lookup>
  80070f:	83 c4 08             	add    $0x8,%esp
  800712:	85 c0                	test   %eax,%eax
  800714:	78 3a                	js     800750 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80071c:	50                   	push   %eax
  80071d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800720:	ff 30                	pushl  (%eax)
  800722:	e8 eb fc ff ff       	call   800412 <dev_lookup>
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	85 c0                	test   %eax,%eax
  80072c:	78 22                	js     800750 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80072e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800731:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800735:	74 1e                	je     800755 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073a:	8b 52 0c             	mov    0xc(%edx),%edx
  80073d:	85 d2                	test   %edx,%edx
  80073f:	74 35                	je     800776 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800741:	83 ec 04             	sub    $0x4,%esp
  800744:	ff 75 10             	pushl  0x10(%ebp)
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	50                   	push   %eax
  80074b:	ff d2                	call   *%edx
  80074d:	83 c4 10             	add    $0x10,%esp
}
  800750:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800753:	c9                   	leave  
  800754:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800755:	a1 04 40 80 00       	mov    0x804004,%eax
  80075a:	8b 40 48             	mov    0x48(%eax),%eax
  80075d:	83 ec 04             	sub    $0x4,%esp
  800760:	53                   	push   %ebx
  800761:	50                   	push   %eax
  800762:	68 95 1d 80 00       	push   $0x801d95
  800767:	e8 70 09 00 00       	call   8010dc <cprintf>
		return -E_INVAL;
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800774:	eb da                	jmp    800750 <write+0x55>
		return -E_NOT_SUPP;
  800776:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80077b:	eb d3                	jmp    800750 <write+0x55>

0080077d <seek>:

int
seek(int fdnum, off_t offset)
{
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800783:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800786:	50                   	push   %eax
  800787:	ff 75 08             	pushl  0x8(%ebp)
  80078a:	e8 2d fc ff ff       	call   8003bc <fd_lookup>
  80078f:	83 c4 08             	add    $0x8,%esp
  800792:	85 c0                	test   %eax,%eax
  800794:	78 0e                	js     8007a4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800796:	8b 55 0c             	mov    0xc(%ebp),%edx
  800799:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80079c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80079f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	53                   	push   %ebx
  8007aa:	83 ec 14             	sub    $0x14,%esp
  8007ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007b3:	50                   	push   %eax
  8007b4:	53                   	push   %ebx
  8007b5:	e8 02 fc ff ff       	call   8003bc <fd_lookup>
  8007ba:	83 c4 08             	add    $0x8,%esp
  8007bd:	85 c0                	test   %eax,%eax
  8007bf:	78 37                	js     8007f8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007c7:	50                   	push   %eax
  8007c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cb:	ff 30                	pushl  (%eax)
  8007cd:	e8 40 fc ff ff       	call   800412 <dev_lookup>
  8007d2:	83 c4 10             	add    $0x10,%esp
  8007d5:	85 c0                	test   %eax,%eax
  8007d7:	78 1f                	js     8007f8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007dc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007e0:	74 1b                	je     8007fd <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8007e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e5:	8b 52 18             	mov    0x18(%edx),%edx
  8007e8:	85 d2                	test   %edx,%edx
  8007ea:	74 32                	je     80081e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	50                   	push   %eax
  8007f3:	ff d2                	call   *%edx
  8007f5:	83 c4 10             	add    $0x10,%esp
}
  8007f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007fb:	c9                   	leave  
  8007fc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8007fd:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800802:	8b 40 48             	mov    0x48(%eax),%eax
  800805:	83 ec 04             	sub    $0x4,%esp
  800808:	53                   	push   %ebx
  800809:	50                   	push   %eax
  80080a:	68 58 1d 80 00       	push   $0x801d58
  80080f:	e8 c8 08 00 00       	call   8010dc <cprintf>
		return -E_INVAL;
  800814:	83 c4 10             	add    $0x10,%esp
  800817:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081c:	eb da                	jmp    8007f8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80081e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800823:	eb d3                	jmp    8007f8 <ftruncate+0x52>

00800825 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	53                   	push   %ebx
  800829:	83 ec 14             	sub    $0x14,%esp
  80082c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80082f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800832:	50                   	push   %eax
  800833:	ff 75 08             	pushl  0x8(%ebp)
  800836:	e8 81 fb ff ff       	call   8003bc <fd_lookup>
  80083b:	83 c4 08             	add    $0x8,%esp
  80083e:	85 c0                	test   %eax,%eax
  800840:	78 4b                	js     80088d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800848:	50                   	push   %eax
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	ff 30                	pushl  (%eax)
  80084e:	e8 bf fb ff ff       	call   800412 <dev_lookup>
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	85 c0                	test   %eax,%eax
  800858:	78 33                	js     80088d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80085a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80085d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800861:	74 2f                	je     800892 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800863:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800866:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80086d:	00 00 00 
	stat->st_isdir = 0;
  800870:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800877:	00 00 00 
	stat->st_dev = dev;
  80087a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	53                   	push   %ebx
  800884:	ff 75 f0             	pushl  -0x10(%ebp)
  800887:	ff 50 14             	call   *0x14(%eax)
  80088a:	83 c4 10             	add    $0x10,%esp
}
  80088d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800890:	c9                   	leave  
  800891:	c3                   	ret    
		return -E_NOT_SUPP;
  800892:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800897:	eb f4                	jmp    80088d <fstat+0x68>

00800899 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	56                   	push   %esi
  80089d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	6a 00                	push   $0x0
  8008a3:	ff 75 08             	pushl  0x8(%ebp)
  8008a6:	e8 e7 01 00 00       	call   800a92 <open>
  8008ab:	89 c3                	mov    %eax,%ebx
  8008ad:	83 c4 10             	add    $0x10,%esp
  8008b0:	85 c0                	test   %eax,%eax
  8008b2:	78 1b                	js     8008cf <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	50                   	push   %eax
  8008bb:	e8 65 ff ff ff       	call   800825 <fstat>
  8008c0:	89 c6                	mov    %eax,%esi
	close(fd);
  8008c2:	89 1c 24             	mov    %ebx,(%esp)
  8008c5:	e8 27 fc ff ff       	call   8004f1 <close>
	return r;
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	89 f3                	mov    %esi,%ebx
}
  8008cf:	89 d8                	mov    %ebx,%eax
  8008d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008d4:	5b                   	pop    %ebx
  8008d5:	5e                   	pop    %esi
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	56                   	push   %esi
  8008dc:	53                   	push   %ebx
  8008dd:	89 c6                	mov    %eax,%esi
  8008df:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8008e1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8008e8:	74 27                	je     800911 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8008ea:	6a 07                	push   $0x7
  8008ec:	68 00 50 80 00       	push   $0x805000
  8008f1:	56                   	push   %esi
  8008f2:	ff 35 00 40 80 00    	pushl  0x804000
  8008f8:	e8 1d 11 00 00       	call   801a1a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8008fd:	83 c4 0c             	add    $0xc,%esp
  800900:	6a 00                	push   $0x0
  800902:	53                   	push   %ebx
  800903:	6a 00                	push   $0x0
  800905:	e8 f9 10 00 00       	call   801a03 <ipc_recv>
}
  80090a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80090d:	5b                   	pop    %ebx
  80090e:	5e                   	pop    %esi
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800911:	83 ec 0c             	sub    $0xc,%esp
  800914:	6a 01                	push   $0x1
  800916:	e8 16 11 00 00       	call   801a31 <ipc_find_env>
  80091b:	a3 00 40 80 00       	mov    %eax,0x804000
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	eb c5                	jmp    8008ea <fsipc+0x12>

00800925 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 40 0c             	mov    0xc(%eax),%eax
  800931:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800936:	8b 45 0c             	mov    0xc(%ebp),%eax
  800939:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80093e:	ba 00 00 00 00       	mov    $0x0,%edx
  800943:	b8 02 00 00 00       	mov    $0x2,%eax
  800948:	e8 8b ff ff ff       	call   8008d8 <fsipc>
}
  80094d:	c9                   	leave  
  80094e:	c3                   	ret    

0080094f <devfile_flush>:
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 40 0c             	mov    0xc(%eax),%eax
  80095b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800960:	ba 00 00 00 00       	mov    $0x0,%edx
  800965:	b8 06 00 00 00       	mov    $0x6,%eax
  80096a:	e8 69 ff ff ff       	call   8008d8 <fsipc>
}
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <devfile_stat>:
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	53                   	push   %ebx
  800975:	83 ec 04             	sub    $0x4,%esp
  800978:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 40 0c             	mov    0xc(%eax),%eax
  800981:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800986:	ba 00 00 00 00       	mov    $0x0,%edx
  80098b:	b8 05 00 00 00       	mov    $0x5,%eax
  800990:	e8 43 ff ff ff       	call   8008d8 <fsipc>
  800995:	85 c0                	test   %eax,%eax
  800997:	78 2c                	js     8009c5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	68 00 50 80 00       	push   $0x805000
  8009a1:	53                   	push   %ebx
  8009a2:	e8 1f 0d 00 00       	call   8016c6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8009a7:	a1 80 50 80 00       	mov    0x805080,%eax
  8009ac:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8009b2:	a1 84 50 80 00       	mov    0x805084,%eax
  8009b7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009bd:	83 c4 10             	add    $0x10,%esp
  8009c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <devfile_write>:
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 0c             	sub    $0xc,%esp
  8009d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d3:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8009d8:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8009dd:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8009e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e3:	8b 52 0c             	mov    0xc(%edx),%edx
  8009e6:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8009ec:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8009f1:	50                   	push   %eax
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	68 08 50 80 00       	push   $0x805008
  8009fa:	e8 55 0e 00 00       	call   801854 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8009ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800a04:	b8 04 00 00 00       	mov    $0x4,%eax
  800a09:	e8 ca fe ff ff       	call   8008d8 <fsipc>
}
  800a0e:	c9                   	leave  
  800a0f:	c3                   	ret    

00800a10 <devfile_read>:
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	56                   	push   %esi
  800a14:	53                   	push   %ebx
  800a15:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8b 40 0c             	mov    0xc(%eax),%eax
  800a1e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800a23:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800a29:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2e:	b8 03 00 00 00       	mov    $0x3,%eax
  800a33:	e8 a0 fe ff ff       	call   8008d8 <fsipc>
  800a38:	89 c3                	mov    %eax,%ebx
  800a3a:	85 c0                	test   %eax,%eax
  800a3c:	78 1f                	js     800a5d <devfile_read+0x4d>
	assert(r <= n);
  800a3e:	39 f0                	cmp    %esi,%eax
  800a40:	77 24                	ja     800a66 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800a42:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a47:	7f 33                	jg     800a7c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800a49:	83 ec 04             	sub    $0x4,%esp
  800a4c:	50                   	push   %eax
  800a4d:	68 00 50 80 00       	push   $0x805000
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	e8 fa 0d 00 00       	call   801854 <memmove>
	return r;
  800a5a:	83 c4 10             	add    $0x10,%esp
}
  800a5d:	89 d8                	mov    %ebx,%eax
  800a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a62:	5b                   	pop    %ebx
  800a63:	5e                   	pop    %esi
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    
	assert(r <= n);
  800a66:	68 c4 1d 80 00       	push   $0x801dc4
  800a6b:	68 cb 1d 80 00       	push   $0x801dcb
  800a70:	6a 7c                	push   $0x7c
  800a72:	68 e0 1d 80 00       	push   $0x801de0
  800a77:	e8 85 05 00 00       	call   801001 <_panic>
	assert(r <= PGSIZE);
  800a7c:	68 eb 1d 80 00       	push   $0x801deb
  800a81:	68 cb 1d 80 00       	push   $0x801dcb
  800a86:	6a 7d                	push   $0x7d
  800a88:	68 e0 1d 80 00       	push   $0x801de0
  800a8d:	e8 6f 05 00 00       	call   801001 <_panic>

00800a92 <open>:
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	56                   	push   %esi
  800a96:	53                   	push   %ebx
  800a97:	83 ec 1c             	sub    $0x1c,%esp
  800a9a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800a9d:	56                   	push   %esi
  800a9e:	e8 ec 0b 00 00       	call   80168f <strlen>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800aab:	7f 6c                	jg     800b19 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800aad:	83 ec 0c             	sub    $0xc,%esp
  800ab0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ab3:	50                   	push   %eax
  800ab4:	e8 b4 f8 ff ff       	call   80036d <fd_alloc>
  800ab9:	89 c3                	mov    %eax,%ebx
  800abb:	83 c4 10             	add    $0x10,%esp
  800abe:	85 c0                	test   %eax,%eax
  800ac0:	78 3c                	js     800afe <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	56                   	push   %esi
  800ac6:	68 00 50 80 00       	push   $0x805000
  800acb:	e8 f6 0b 00 00       	call   8016c6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad3:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ad8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800adb:	b8 01 00 00 00       	mov    $0x1,%eax
  800ae0:	e8 f3 fd ff ff       	call   8008d8 <fsipc>
  800ae5:	89 c3                	mov    %eax,%ebx
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	85 c0                	test   %eax,%eax
  800aec:	78 19                	js     800b07 <open+0x75>
	return fd2num(fd);
  800aee:	83 ec 0c             	sub    $0xc,%esp
  800af1:	ff 75 f4             	pushl  -0xc(%ebp)
  800af4:	e8 4d f8 ff ff       	call   800346 <fd2num>
  800af9:	89 c3                	mov    %eax,%ebx
  800afb:	83 c4 10             	add    $0x10,%esp
}
  800afe:	89 d8                	mov    %ebx,%eax
  800b00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b03:	5b                   	pop    %ebx
  800b04:	5e                   	pop    %esi
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    
		fd_close(fd, 0);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	6a 00                	push   $0x0
  800b0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0f:	e8 54 f9 ff ff       	call   800468 <fd_close>
		return r;
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	eb e5                	jmp    800afe <open+0x6c>
		return -E_BAD_PATH;
  800b19:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800b1e:	eb de                	jmp    800afe <open+0x6c>

00800b20 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800b26:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2b:	b8 08 00 00 00       	mov    $0x8,%eax
  800b30:	e8 a3 fd ff ff       	call   8008d8 <fsipc>
}
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    

00800b37 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
  800b3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800b3f:	83 ec 0c             	sub    $0xc,%esp
  800b42:	ff 75 08             	pushl  0x8(%ebp)
  800b45:	e8 0c f8 ff ff       	call   800356 <fd2data>
  800b4a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800b4c:	83 c4 08             	add    $0x8,%esp
  800b4f:	68 f7 1d 80 00       	push   $0x801df7
  800b54:	53                   	push   %ebx
  800b55:	e8 6c 0b 00 00       	call   8016c6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800b5a:	8b 46 04             	mov    0x4(%esi),%eax
  800b5d:	2b 06                	sub    (%esi),%eax
  800b5f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800b65:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800b6c:	00 00 00 
	stat->st_dev = &devpipe;
  800b6f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800b76:	30 80 00 
	return 0;
}
  800b79:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b81:	5b                   	pop    %ebx
  800b82:	5e                   	pop    %esi
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	53                   	push   %ebx
  800b89:	83 ec 0c             	sub    $0xc,%esp
  800b8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800b8f:	53                   	push   %ebx
  800b90:	6a 00                	push   $0x0
  800b92:	e8 43 f6 ff ff       	call   8001da <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800b97:	89 1c 24             	mov    %ebx,(%esp)
  800b9a:	e8 b7 f7 ff ff       	call   800356 <fd2data>
  800b9f:	83 c4 08             	add    $0x8,%esp
  800ba2:	50                   	push   %eax
  800ba3:	6a 00                	push   $0x0
  800ba5:	e8 30 f6 ff ff       	call   8001da <sys_page_unmap>
}
  800baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <_pipeisclosed>:
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	57                   	push   %edi
  800bb3:	56                   	push   %esi
  800bb4:	53                   	push   %ebx
  800bb5:	83 ec 1c             	sub    $0x1c,%esp
  800bb8:	89 c7                	mov    %eax,%edi
  800bba:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800bbc:	a1 04 40 80 00       	mov    0x804004,%eax
  800bc1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	57                   	push   %edi
  800bc8:	e8 9d 0e 00 00       	call   801a6a <pageref>
  800bcd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bd0:	89 34 24             	mov    %esi,(%esp)
  800bd3:	e8 92 0e 00 00       	call   801a6a <pageref>
		nn = thisenv->env_runs;
  800bd8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800bde:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	39 cb                	cmp    %ecx,%ebx
  800be6:	74 1b                	je     800c03 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800be8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800beb:	75 cf                	jne    800bbc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800bed:	8b 42 58             	mov    0x58(%edx),%eax
  800bf0:	6a 01                	push   $0x1
  800bf2:	50                   	push   %eax
  800bf3:	53                   	push   %ebx
  800bf4:	68 fe 1d 80 00       	push   $0x801dfe
  800bf9:	e8 de 04 00 00       	call   8010dc <cprintf>
  800bfe:	83 c4 10             	add    $0x10,%esp
  800c01:	eb b9                	jmp    800bbc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800c03:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800c06:	0f 94 c0             	sete   %al
  800c09:	0f b6 c0             	movzbl %al,%eax
}
  800c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <devpipe_write>:
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	57                   	push   %edi
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
  800c1a:	83 ec 28             	sub    $0x28,%esp
  800c1d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800c20:	56                   	push   %esi
  800c21:	e8 30 f7 ff ff       	call   800356 <fd2data>
  800c26:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800c28:	83 c4 10             	add    $0x10,%esp
  800c2b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c30:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800c33:	74 4f                	je     800c84 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800c35:	8b 43 04             	mov    0x4(%ebx),%eax
  800c38:	8b 0b                	mov    (%ebx),%ecx
  800c3a:	8d 51 20             	lea    0x20(%ecx),%edx
  800c3d:	39 d0                	cmp    %edx,%eax
  800c3f:	72 14                	jb     800c55 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800c41:	89 da                	mov    %ebx,%edx
  800c43:	89 f0                	mov    %esi,%eax
  800c45:	e8 65 ff ff ff       	call   800baf <_pipeisclosed>
  800c4a:	85 c0                	test   %eax,%eax
  800c4c:	75 3a                	jne    800c88 <devpipe_write+0x74>
			sys_yield();
  800c4e:	e8 e3 f4 ff ff       	call   800136 <sys_yield>
  800c53:	eb e0                	jmp    800c35 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c58:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800c5c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800c5f:	89 c2                	mov    %eax,%edx
  800c61:	c1 fa 1f             	sar    $0x1f,%edx
  800c64:	89 d1                	mov    %edx,%ecx
  800c66:	c1 e9 1b             	shr    $0x1b,%ecx
  800c69:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  800c6c:	83 e2 1f             	and    $0x1f,%edx
  800c6f:	29 ca                	sub    %ecx,%edx
  800c71:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  800c75:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  800c79:	83 c0 01             	add    $0x1,%eax
  800c7c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800c7f:	83 c7 01             	add    $0x1,%edi
  800c82:	eb ac                	jmp    800c30 <devpipe_write+0x1c>
	return i;
  800c84:	89 f8                	mov    %edi,%eax
  800c86:	eb 05                	jmp    800c8d <devpipe_write+0x79>
				return 0;
  800c88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <devpipe_read>:
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	83 ec 18             	sub    $0x18,%esp
  800c9e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800ca1:	57                   	push   %edi
  800ca2:	e8 af f6 ff ff       	call   800356 <fd2data>
  800ca7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800ca9:	83 c4 10             	add    $0x10,%esp
  800cac:	be 00 00 00 00       	mov    $0x0,%esi
  800cb1:	3b 75 10             	cmp    0x10(%ebp),%esi
  800cb4:	74 47                	je     800cfd <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  800cb6:	8b 03                	mov    (%ebx),%eax
  800cb8:	3b 43 04             	cmp    0x4(%ebx),%eax
  800cbb:	75 22                	jne    800cdf <devpipe_read+0x4a>
			if (i > 0)
  800cbd:	85 f6                	test   %esi,%esi
  800cbf:	75 14                	jne    800cd5 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  800cc1:	89 da                	mov    %ebx,%edx
  800cc3:	89 f8                	mov    %edi,%eax
  800cc5:	e8 e5 fe ff ff       	call   800baf <_pipeisclosed>
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	75 33                	jne    800d01 <devpipe_read+0x6c>
			sys_yield();
  800cce:	e8 63 f4 ff ff       	call   800136 <sys_yield>
  800cd3:	eb e1                	jmp    800cb6 <devpipe_read+0x21>
				return i;
  800cd5:	89 f0                	mov    %esi,%eax
}
  800cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cda:	5b                   	pop    %ebx
  800cdb:	5e                   	pop    %esi
  800cdc:	5f                   	pop    %edi
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800cdf:	99                   	cltd   
  800ce0:	c1 ea 1b             	shr    $0x1b,%edx
  800ce3:	01 d0                	add    %edx,%eax
  800ce5:	83 e0 1f             	and    $0x1f,%eax
  800ce8:	29 d0                	sub    %edx,%eax
  800cea:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800cef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800cf5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  800cf8:	83 c6 01             	add    $0x1,%esi
  800cfb:	eb b4                	jmp    800cb1 <devpipe_read+0x1c>
	return i;
  800cfd:	89 f0                	mov    %esi,%eax
  800cff:	eb d6                	jmp    800cd7 <devpipe_read+0x42>
				return 0;
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	eb cf                	jmp    800cd7 <devpipe_read+0x42>

00800d08 <pipe>:
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800d10:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d13:	50                   	push   %eax
  800d14:	e8 54 f6 ff ff       	call   80036d <fd_alloc>
  800d19:	89 c3                	mov    %eax,%ebx
  800d1b:	83 c4 10             	add    $0x10,%esp
  800d1e:	85 c0                	test   %eax,%eax
  800d20:	78 5b                	js     800d7d <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d22:	83 ec 04             	sub    $0x4,%esp
  800d25:	68 07 04 00 00       	push   $0x407
  800d2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d2d:	6a 00                	push   $0x0
  800d2f:	e8 21 f4 ff ff       	call   800155 <sys_page_alloc>
  800d34:	89 c3                	mov    %eax,%ebx
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	78 40                	js     800d7d <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  800d3d:	83 ec 0c             	sub    $0xc,%esp
  800d40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d43:	50                   	push   %eax
  800d44:	e8 24 f6 ff ff       	call   80036d <fd_alloc>
  800d49:	89 c3                	mov    %eax,%ebx
  800d4b:	83 c4 10             	add    $0x10,%esp
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	78 1b                	js     800d6d <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d52:	83 ec 04             	sub    $0x4,%esp
  800d55:	68 07 04 00 00       	push   $0x407
  800d5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800d5d:	6a 00                	push   $0x0
  800d5f:	e8 f1 f3 ff ff       	call   800155 <sys_page_alloc>
  800d64:	89 c3                	mov    %eax,%ebx
  800d66:	83 c4 10             	add    $0x10,%esp
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	79 19                	jns    800d86 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  800d6d:	83 ec 08             	sub    $0x8,%esp
  800d70:	ff 75 f4             	pushl  -0xc(%ebp)
  800d73:	6a 00                	push   $0x0
  800d75:	e8 60 f4 ff ff       	call   8001da <sys_page_unmap>
  800d7a:	83 c4 10             	add    $0x10,%esp
}
  800d7d:	89 d8                	mov    %ebx,%eax
  800d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    
	va = fd2data(fd0);
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8c:	e8 c5 f5 ff ff       	call   800356 <fd2data>
  800d91:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800d93:	83 c4 0c             	add    $0xc,%esp
  800d96:	68 07 04 00 00       	push   $0x407
  800d9b:	50                   	push   %eax
  800d9c:	6a 00                	push   $0x0
  800d9e:	e8 b2 f3 ff ff       	call   800155 <sys_page_alloc>
  800da3:	89 c3                	mov    %eax,%ebx
  800da5:	83 c4 10             	add    $0x10,%esp
  800da8:	85 c0                	test   %eax,%eax
  800daa:	0f 88 8c 00 00 00    	js     800e3c <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	ff 75 f0             	pushl  -0x10(%ebp)
  800db6:	e8 9b f5 ff ff       	call   800356 <fd2data>
  800dbb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800dc2:	50                   	push   %eax
  800dc3:	6a 00                	push   $0x0
  800dc5:	56                   	push   %esi
  800dc6:	6a 00                	push   $0x0
  800dc8:	e8 cb f3 ff ff       	call   800198 <sys_page_map>
  800dcd:	89 c3                	mov    %eax,%ebx
  800dcf:	83 c4 20             	add    $0x20,%esp
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	78 58                	js     800e2e <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  800dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ddf:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800de4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dee:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800df4:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800e00:	83 ec 0c             	sub    $0xc,%esp
  800e03:	ff 75 f4             	pushl  -0xc(%ebp)
  800e06:	e8 3b f5 ff ff       	call   800346 <fd2num>
  800e0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800e10:	83 c4 04             	add    $0x4,%esp
  800e13:	ff 75 f0             	pushl  -0x10(%ebp)
  800e16:	e8 2b f5 ff ff       	call   800346 <fd2num>
  800e1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800e21:	83 c4 10             	add    $0x10,%esp
  800e24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e29:	e9 4f ff ff ff       	jmp    800d7d <pipe+0x75>
	sys_page_unmap(0, va);
  800e2e:	83 ec 08             	sub    $0x8,%esp
  800e31:	56                   	push   %esi
  800e32:	6a 00                	push   $0x0
  800e34:	e8 a1 f3 ff ff       	call   8001da <sys_page_unmap>
  800e39:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800e3c:	83 ec 08             	sub    $0x8,%esp
  800e3f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e42:	6a 00                	push   $0x0
  800e44:	e8 91 f3 ff ff       	call   8001da <sys_page_unmap>
  800e49:	83 c4 10             	add    $0x10,%esp
  800e4c:	e9 1c ff ff ff       	jmp    800d6d <pipe+0x65>

00800e51 <pipeisclosed>:
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800e57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e5a:	50                   	push   %eax
  800e5b:	ff 75 08             	pushl  0x8(%ebp)
  800e5e:	e8 59 f5 ff ff       	call   8003bc <fd_lookup>
  800e63:	83 c4 10             	add    $0x10,%esp
  800e66:	85 c0                	test   %eax,%eax
  800e68:	78 18                	js     800e82 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800e6a:	83 ec 0c             	sub    $0xc,%esp
  800e6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800e70:	e8 e1 f4 ff ff       	call   800356 <fd2data>
	return _pipeisclosed(fd, p);
  800e75:	89 c2                	mov    %eax,%edx
  800e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e7a:	e8 30 fd ff ff       	call   800baf <_pipeisclosed>
  800e7f:	83 c4 10             	add    $0x10,%esp
}
  800e82:	c9                   	leave  
  800e83:	c3                   	ret    

00800e84 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800e87:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    

00800e8e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  800e94:	68 16 1e 80 00       	push   $0x801e16
  800e99:	ff 75 0c             	pushl  0xc(%ebp)
  800e9c:	e8 25 08 00 00       	call   8016c6 <strcpy>
	return 0;
}
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea6:	c9                   	leave  
  800ea7:	c3                   	ret    

00800ea8 <devcons_write>:
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	57                   	push   %edi
  800eac:	56                   	push   %esi
  800ead:	53                   	push   %ebx
  800eae:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800eb4:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800eb9:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800ebf:	eb 2f                	jmp    800ef0 <devcons_write+0x48>
		m = n - tot;
  800ec1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec4:	29 f3                	sub    %esi,%ebx
  800ec6:	83 fb 7f             	cmp    $0x7f,%ebx
  800ec9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800ece:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800ed1:	83 ec 04             	sub    $0x4,%esp
  800ed4:	53                   	push   %ebx
  800ed5:	89 f0                	mov    %esi,%eax
  800ed7:	03 45 0c             	add    0xc(%ebp),%eax
  800eda:	50                   	push   %eax
  800edb:	57                   	push   %edi
  800edc:	e8 73 09 00 00       	call   801854 <memmove>
		sys_cputs(buf, m);
  800ee1:	83 c4 08             	add    $0x8,%esp
  800ee4:	53                   	push   %ebx
  800ee5:	57                   	push   %edi
  800ee6:	e8 ae f1 ff ff       	call   800099 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800eeb:	01 de                	add    %ebx,%esi
  800eed:	83 c4 10             	add    $0x10,%esp
  800ef0:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ef3:	72 cc                	jb     800ec1 <devcons_write+0x19>
}
  800ef5:	89 f0                	mov    %esi,%eax
  800ef7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efa:	5b                   	pop    %ebx
  800efb:	5e                   	pop    %esi
  800efc:	5f                   	pop    %edi
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    

00800eff <devcons_read>:
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 08             	sub    $0x8,%esp
  800f05:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  800f0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0e:	75 07                	jne    800f17 <devcons_read+0x18>
}
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    
		sys_yield();
  800f12:	e8 1f f2 ff ff       	call   800136 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  800f17:	e8 9b f1 ff ff       	call   8000b7 <sys_cgetc>
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	74 f2                	je     800f12 <devcons_read+0x13>
	if (c < 0)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	78 ec                	js     800f10 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  800f24:	83 f8 04             	cmp    $0x4,%eax
  800f27:	74 0c                	je     800f35 <devcons_read+0x36>
	*(char*)vbuf = c;
  800f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2c:	88 02                	mov    %al,(%edx)
	return 1;
  800f2e:	b8 01 00 00 00       	mov    $0x1,%eax
  800f33:	eb db                	jmp    800f10 <devcons_read+0x11>
		return 0;
  800f35:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3a:	eb d4                	jmp    800f10 <devcons_read+0x11>

00800f3c <cputchar>:
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  800f48:	6a 01                	push   $0x1
  800f4a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f4d:	50                   	push   %eax
  800f4e:	e8 46 f1 ff ff       	call   800099 <sys_cputs>
}
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <getchar>:
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800f5e:	6a 01                	push   $0x1
  800f60:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800f63:	50                   	push   %eax
  800f64:	6a 00                	push   $0x0
  800f66:	e8 c2 f6 ff ff       	call   80062d <read>
	if (r < 0)
  800f6b:	83 c4 10             	add    $0x10,%esp
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	78 08                	js     800f7a <getchar+0x22>
	if (r < 1)
  800f72:	85 c0                	test   %eax,%eax
  800f74:	7e 06                	jle    800f7c <getchar+0x24>
	return c;
  800f76:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800f7a:	c9                   	leave  
  800f7b:	c3                   	ret    
		return -E_EOF;
  800f7c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800f81:	eb f7                	jmp    800f7a <getchar+0x22>

00800f83 <iscons>:
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f8c:	50                   	push   %eax
  800f8d:	ff 75 08             	pushl  0x8(%ebp)
  800f90:	e8 27 f4 ff ff       	call   8003bc <fd_lookup>
  800f95:	83 c4 10             	add    $0x10,%esp
  800f98:	85 c0                	test   %eax,%eax
  800f9a:	78 11                	js     800fad <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  800f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f9f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fa5:	39 10                	cmp    %edx,(%eax)
  800fa7:	0f 94 c0             	sete   %al
  800faa:	0f b6 c0             	movzbl %al,%eax
}
  800fad:	c9                   	leave  
  800fae:	c3                   	ret    

00800faf <opencons>:
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800fb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fb8:	50                   	push   %eax
  800fb9:	e8 af f3 ff ff       	call   80036d <fd_alloc>
  800fbe:	83 c4 10             	add    $0x10,%esp
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	78 3a                	js     800fff <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800fc5:	83 ec 04             	sub    $0x4,%esp
  800fc8:	68 07 04 00 00       	push   $0x407
  800fcd:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd0:	6a 00                	push   $0x0
  800fd2:	e8 7e f1 ff ff       	call   800155 <sys_page_alloc>
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	78 21                	js     800fff <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  800fe7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fec:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800ff3:	83 ec 0c             	sub    $0xc,%esp
  800ff6:	50                   	push   %eax
  800ff7:	e8 4a f3 ff ff       	call   800346 <fd2num>
  800ffc:	83 c4 10             	add    $0x10,%esp
}
  800fff:	c9                   	leave  
  801000:	c3                   	ret    

00801001 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	56                   	push   %esi
  801005:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801006:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801009:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80100f:	e8 03 f1 ff ff       	call   800117 <sys_getenvid>
  801014:	83 ec 0c             	sub    $0xc,%esp
  801017:	ff 75 0c             	pushl  0xc(%ebp)
  80101a:	ff 75 08             	pushl  0x8(%ebp)
  80101d:	56                   	push   %esi
  80101e:	50                   	push   %eax
  80101f:	68 24 1e 80 00       	push   $0x801e24
  801024:	e8 b3 00 00 00       	call   8010dc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801029:	83 c4 18             	add    $0x18,%esp
  80102c:	53                   	push   %ebx
  80102d:	ff 75 10             	pushl  0x10(%ebp)
  801030:	e8 56 00 00 00       	call   80108b <vcprintf>
	cprintf("\n");
  801035:	c7 04 24 0f 1e 80 00 	movl   $0x801e0f,(%esp)
  80103c:	e8 9b 00 00 00       	call   8010dc <cprintf>
  801041:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801044:	cc                   	int3   
  801045:	eb fd                	jmp    801044 <_panic+0x43>

00801047 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	53                   	push   %ebx
  80104b:	83 ec 04             	sub    $0x4,%esp
  80104e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801051:	8b 13                	mov    (%ebx),%edx
  801053:	8d 42 01             	lea    0x1(%edx),%eax
  801056:	89 03                	mov    %eax,(%ebx)
  801058:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80105b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80105f:	3d ff 00 00 00       	cmp    $0xff,%eax
  801064:	74 09                	je     80106f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801066:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80106a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	68 ff 00 00 00       	push   $0xff
  801077:	8d 43 08             	lea    0x8(%ebx),%eax
  80107a:	50                   	push   %eax
  80107b:	e8 19 f0 ff ff       	call   800099 <sys_cputs>
		b->idx = 0;
  801080:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801086:	83 c4 10             	add    $0x10,%esp
  801089:	eb db                	jmp    801066 <putch+0x1f>

0080108b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801094:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80109b:	00 00 00 
	b.cnt = 0;
  80109e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8010a5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8010a8:	ff 75 0c             	pushl  0xc(%ebp)
  8010ab:	ff 75 08             	pushl  0x8(%ebp)
  8010ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8010b4:	50                   	push   %eax
  8010b5:	68 47 10 80 00       	push   $0x801047
  8010ba:	e8 1a 01 00 00       	call   8011d9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8010bf:	83 c4 08             	add    $0x8,%esp
  8010c2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8010c8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	e8 c5 ef ff ff       	call   800099 <sys_cputs>

	return b.cnt;
}
  8010d4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010e2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8010e5:	50                   	push   %eax
  8010e6:	ff 75 08             	pushl  0x8(%ebp)
  8010e9:	e8 9d ff ff ff       	call   80108b <vcprintf>
	va_end(ap);

	return cnt;
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	57                   	push   %edi
  8010f4:	56                   	push   %esi
  8010f5:	53                   	push   %ebx
  8010f6:	83 ec 1c             	sub    $0x1c,%esp
  8010f9:	89 c7                	mov    %eax,%edi
  8010fb:	89 d6                	mov    %edx,%esi
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	8b 55 0c             	mov    0xc(%ebp),%edx
  801103:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801106:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801109:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80110c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801111:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801114:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801117:	39 d3                	cmp    %edx,%ebx
  801119:	72 05                	jb     801120 <printnum+0x30>
  80111b:	39 45 10             	cmp    %eax,0x10(%ebp)
  80111e:	77 7a                	ja     80119a <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801120:	83 ec 0c             	sub    $0xc,%esp
  801123:	ff 75 18             	pushl  0x18(%ebp)
  801126:	8b 45 14             	mov    0x14(%ebp),%eax
  801129:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80112c:	53                   	push   %ebx
  80112d:	ff 75 10             	pushl  0x10(%ebp)
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 e4             	pushl  -0x1c(%ebp)
  801136:	ff 75 e0             	pushl  -0x20(%ebp)
  801139:	ff 75 dc             	pushl  -0x24(%ebp)
  80113c:	ff 75 d8             	pushl  -0x28(%ebp)
  80113f:	e8 6c 09 00 00       	call   801ab0 <__udivdi3>
  801144:	83 c4 18             	add    $0x18,%esp
  801147:	52                   	push   %edx
  801148:	50                   	push   %eax
  801149:	89 f2                	mov    %esi,%edx
  80114b:	89 f8                	mov    %edi,%eax
  80114d:	e8 9e ff ff ff       	call   8010f0 <printnum>
  801152:	83 c4 20             	add    $0x20,%esp
  801155:	eb 13                	jmp    80116a <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801157:	83 ec 08             	sub    $0x8,%esp
  80115a:	56                   	push   %esi
  80115b:	ff 75 18             	pushl  0x18(%ebp)
  80115e:	ff d7                	call   *%edi
  801160:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801163:	83 eb 01             	sub    $0x1,%ebx
  801166:	85 db                	test   %ebx,%ebx
  801168:	7f ed                	jg     801157 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80116a:	83 ec 08             	sub    $0x8,%esp
  80116d:	56                   	push   %esi
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	ff 75 e4             	pushl  -0x1c(%ebp)
  801174:	ff 75 e0             	pushl  -0x20(%ebp)
  801177:	ff 75 dc             	pushl  -0x24(%ebp)
  80117a:	ff 75 d8             	pushl  -0x28(%ebp)
  80117d:	e8 4e 0a 00 00       	call   801bd0 <__umoddi3>
  801182:	83 c4 14             	add    $0x14,%esp
  801185:	0f be 80 47 1e 80 00 	movsbl 0x801e47(%eax),%eax
  80118c:	50                   	push   %eax
  80118d:	ff d7                	call   *%edi
}
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    
  80119a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80119d:	eb c4                	jmp    801163 <printnum+0x73>

0080119f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8011a5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8011a9:	8b 10                	mov    (%eax),%edx
  8011ab:	3b 50 04             	cmp    0x4(%eax),%edx
  8011ae:	73 0a                	jae    8011ba <sprintputch+0x1b>
		*b->buf++ = ch;
  8011b0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b3:	89 08                	mov    %ecx,(%eax)
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	88 02                	mov    %al,(%edx)
}
  8011ba:	5d                   	pop    %ebp
  8011bb:	c3                   	ret    

008011bc <printfmt>:
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8011c2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8011c5:	50                   	push   %eax
  8011c6:	ff 75 10             	pushl  0x10(%ebp)
  8011c9:	ff 75 0c             	pushl  0xc(%ebp)
  8011cc:	ff 75 08             	pushl  0x8(%ebp)
  8011cf:	e8 05 00 00 00       	call   8011d9 <vprintfmt>
}
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <vprintfmt>:
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	57                   	push   %edi
  8011dd:	56                   	push   %esi
  8011de:	53                   	push   %ebx
  8011df:	83 ec 2c             	sub    $0x2c,%esp
  8011e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8011e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8011e8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8011eb:	e9 8c 03 00 00       	jmp    80157c <vprintfmt+0x3a3>
		padc = ' ';
  8011f0:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8011f4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8011fb:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801202:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801209:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80120e:	8d 47 01             	lea    0x1(%edi),%eax
  801211:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801214:	0f b6 17             	movzbl (%edi),%edx
  801217:	8d 42 dd             	lea    -0x23(%edx),%eax
  80121a:	3c 55                	cmp    $0x55,%al
  80121c:	0f 87 dd 03 00 00    	ja     8015ff <vprintfmt+0x426>
  801222:	0f b6 c0             	movzbl %al,%eax
  801225:	ff 24 85 80 1f 80 00 	jmp    *0x801f80(,%eax,4)
  80122c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80122f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801233:	eb d9                	jmp    80120e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801235:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801238:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80123c:	eb d0                	jmp    80120e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80123e:	0f b6 d2             	movzbl %dl,%edx
  801241:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801244:	b8 00 00 00 00       	mov    $0x0,%eax
  801249:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80124c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80124f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801253:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801256:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801259:	83 f9 09             	cmp    $0x9,%ecx
  80125c:	77 55                	ja     8012b3 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80125e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801261:	eb e9                	jmp    80124c <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	8b 00                	mov    (%eax),%eax
  801268:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	8d 40 04             	lea    0x4(%eax),%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801274:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801277:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80127b:	79 91                	jns    80120e <vprintfmt+0x35>
				width = precision, precision = -1;
  80127d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801280:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801283:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80128a:	eb 82                	jmp    80120e <vprintfmt+0x35>
  80128c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80128f:	85 c0                	test   %eax,%eax
  801291:	ba 00 00 00 00       	mov    $0x0,%edx
  801296:	0f 49 d0             	cmovns %eax,%edx
  801299:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80129c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80129f:	e9 6a ff ff ff       	jmp    80120e <vprintfmt+0x35>
  8012a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8012a7:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8012ae:	e9 5b ff ff ff       	jmp    80120e <vprintfmt+0x35>
  8012b3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8012b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8012b9:	eb bc                	jmp    801277 <vprintfmt+0x9e>
			lflag++;
  8012bb:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8012be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8012c1:	e9 48 ff ff ff       	jmp    80120e <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8012c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c9:	8d 78 04             	lea    0x4(%eax),%edi
  8012cc:	83 ec 08             	sub    $0x8,%esp
  8012cf:	53                   	push   %ebx
  8012d0:	ff 30                	pushl  (%eax)
  8012d2:	ff d6                	call   *%esi
			break;
  8012d4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8012d7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8012da:	e9 9a 02 00 00       	jmp    801579 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8012df:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e2:	8d 78 04             	lea    0x4(%eax),%edi
  8012e5:	8b 00                	mov    (%eax),%eax
  8012e7:	99                   	cltd   
  8012e8:	31 d0                	xor    %edx,%eax
  8012ea:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012ec:	83 f8 0f             	cmp    $0xf,%eax
  8012ef:	7f 23                	jg     801314 <vprintfmt+0x13b>
  8012f1:	8b 14 85 e0 20 80 00 	mov    0x8020e0(,%eax,4),%edx
  8012f8:	85 d2                	test   %edx,%edx
  8012fa:	74 18                	je     801314 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8012fc:	52                   	push   %edx
  8012fd:	68 dd 1d 80 00       	push   $0x801ddd
  801302:	53                   	push   %ebx
  801303:	56                   	push   %esi
  801304:	e8 b3 fe ff ff       	call   8011bc <printfmt>
  801309:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80130c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80130f:	e9 65 02 00 00       	jmp    801579 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  801314:	50                   	push   %eax
  801315:	68 5f 1e 80 00       	push   $0x801e5f
  80131a:	53                   	push   %ebx
  80131b:	56                   	push   %esi
  80131c:	e8 9b fe ff ff       	call   8011bc <printfmt>
  801321:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801324:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801327:	e9 4d 02 00 00       	jmp    801579 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  80132c:	8b 45 14             	mov    0x14(%ebp),%eax
  80132f:	83 c0 04             	add    $0x4,%eax
  801332:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80133a:	85 ff                	test   %edi,%edi
  80133c:	b8 58 1e 80 00       	mov    $0x801e58,%eax
  801341:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801344:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801348:	0f 8e bd 00 00 00    	jle    80140b <vprintfmt+0x232>
  80134e:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801352:	75 0e                	jne    801362 <vprintfmt+0x189>
  801354:	89 75 08             	mov    %esi,0x8(%ebp)
  801357:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80135a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80135d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801360:	eb 6d                	jmp    8013cf <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	ff 75 d0             	pushl  -0x30(%ebp)
  801368:	57                   	push   %edi
  801369:	e8 39 03 00 00       	call   8016a7 <strnlen>
  80136e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801371:	29 c1                	sub    %eax,%ecx
  801373:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801376:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801379:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80137d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801380:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801383:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801385:	eb 0f                	jmp    801396 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	53                   	push   %ebx
  80138b:	ff 75 e0             	pushl  -0x20(%ebp)
  80138e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801390:	83 ef 01             	sub    $0x1,%edi
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	85 ff                	test   %edi,%edi
  801398:	7f ed                	jg     801387 <vprintfmt+0x1ae>
  80139a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80139d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8013a0:	85 c9                	test   %ecx,%ecx
  8013a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a7:	0f 49 c1             	cmovns %ecx,%eax
  8013aa:	29 c1                	sub    %eax,%ecx
  8013ac:	89 75 08             	mov    %esi,0x8(%ebp)
  8013af:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8013b2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8013b5:	89 cb                	mov    %ecx,%ebx
  8013b7:	eb 16                	jmp    8013cf <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8013b9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013bd:	75 31                	jne    8013f0 <vprintfmt+0x217>
					putch(ch, putdat);
  8013bf:	83 ec 08             	sub    $0x8,%esp
  8013c2:	ff 75 0c             	pushl  0xc(%ebp)
  8013c5:	50                   	push   %eax
  8013c6:	ff 55 08             	call   *0x8(%ebp)
  8013c9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013cc:	83 eb 01             	sub    $0x1,%ebx
  8013cf:	83 c7 01             	add    $0x1,%edi
  8013d2:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8013d6:	0f be c2             	movsbl %dl,%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 59                	je     801436 <vprintfmt+0x25d>
  8013dd:	85 f6                	test   %esi,%esi
  8013df:	78 d8                	js     8013b9 <vprintfmt+0x1e0>
  8013e1:	83 ee 01             	sub    $0x1,%esi
  8013e4:	79 d3                	jns    8013b9 <vprintfmt+0x1e0>
  8013e6:	89 df                	mov    %ebx,%edi
  8013e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8013eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8013ee:	eb 37                	jmp    801427 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8013f0:	0f be d2             	movsbl %dl,%edx
  8013f3:	83 ea 20             	sub    $0x20,%edx
  8013f6:	83 fa 5e             	cmp    $0x5e,%edx
  8013f9:	76 c4                	jbe    8013bf <vprintfmt+0x1e6>
					putch('?', putdat);
  8013fb:	83 ec 08             	sub    $0x8,%esp
  8013fe:	ff 75 0c             	pushl  0xc(%ebp)
  801401:	6a 3f                	push   $0x3f
  801403:	ff 55 08             	call   *0x8(%ebp)
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	eb c1                	jmp    8013cc <vprintfmt+0x1f3>
  80140b:	89 75 08             	mov    %esi,0x8(%ebp)
  80140e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801411:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801414:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801417:	eb b6                	jmp    8013cf <vprintfmt+0x1f6>
				putch(' ', putdat);
  801419:	83 ec 08             	sub    $0x8,%esp
  80141c:	53                   	push   %ebx
  80141d:	6a 20                	push   $0x20
  80141f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801421:	83 ef 01             	sub    $0x1,%edi
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	85 ff                	test   %edi,%edi
  801429:	7f ee                	jg     801419 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80142b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80142e:	89 45 14             	mov    %eax,0x14(%ebp)
  801431:	e9 43 01 00 00       	jmp    801579 <vprintfmt+0x3a0>
  801436:	89 df                	mov    %ebx,%edi
  801438:	8b 75 08             	mov    0x8(%ebp),%esi
  80143b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80143e:	eb e7                	jmp    801427 <vprintfmt+0x24e>
	if (lflag >= 2)
  801440:	83 f9 01             	cmp    $0x1,%ecx
  801443:	7e 3f                	jle    801484 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  801445:	8b 45 14             	mov    0x14(%ebp),%eax
  801448:	8b 50 04             	mov    0x4(%eax),%edx
  80144b:	8b 00                	mov    (%eax),%eax
  80144d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801450:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801453:	8b 45 14             	mov    0x14(%ebp),%eax
  801456:	8d 40 08             	lea    0x8(%eax),%eax
  801459:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80145c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801460:	79 5c                	jns    8014be <vprintfmt+0x2e5>
				putch('-', putdat);
  801462:	83 ec 08             	sub    $0x8,%esp
  801465:	53                   	push   %ebx
  801466:	6a 2d                	push   $0x2d
  801468:	ff d6                	call   *%esi
				num = -(long long) num;
  80146a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80146d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801470:	f7 da                	neg    %edx
  801472:	83 d1 00             	adc    $0x0,%ecx
  801475:	f7 d9                	neg    %ecx
  801477:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80147a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80147f:	e9 db 00 00 00       	jmp    80155f <vprintfmt+0x386>
	else if (lflag)
  801484:	85 c9                	test   %ecx,%ecx
  801486:	75 1b                	jne    8014a3 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  801488:	8b 45 14             	mov    0x14(%ebp),%eax
  80148b:	8b 00                	mov    (%eax),%eax
  80148d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801490:	89 c1                	mov    %eax,%ecx
  801492:	c1 f9 1f             	sar    $0x1f,%ecx
  801495:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801498:	8b 45 14             	mov    0x14(%ebp),%eax
  80149b:	8d 40 04             	lea    0x4(%eax),%eax
  80149e:	89 45 14             	mov    %eax,0x14(%ebp)
  8014a1:	eb b9                	jmp    80145c <vprintfmt+0x283>
		return va_arg(*ap, long);
  8014a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a6:	8b 00                	mov    (%eax),%eax
  8014a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8014ab:	89 c1                	mov    %eax,%ecx
  8014ad:	c1 f9 1f             	sar    $0x1f,%ecx
  8014b0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8014b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b6:	8d 40 04             	lea    0x4(%eax),%eax
  8014b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8014bc:	eb 9e                	jmp    80145c <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8014be:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8014c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014c9:	e9 91 00 00 00       	jmp    80155f <vprintfmt+0x386>
	if (lflag >= 2)
  8014ce:	83 f9 01             	cmp    $0x1,%ecx
  8014d1:	7e 15                	jle    8014e8 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8014d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d6:	8b 10                	mov    (%eax),%edx
  8014d8:	8b 48 04             	mov    0x4(%eax),%ecx
  8014db:	8d 40 08             	lea    0x8(%eax),%eax
  8014de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8014e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014e6:	eb 77                	jmp    80155f <vprintfmt+0x386>
	else if (lflag)
  8014e8:	85 c9                	test   %ecx,%ecx
  8014ea:	75 17                	jne    801503 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8014ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ef:	8b 10                	mov    (%eax),%edx
  8014f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014f6:	8d 40 04             	lea    0x4(%eax),%eax
  8014f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8014fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  801501:	eb 5c                	jmp    80155f <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  801503:	8b 45 14             	mov    0x14(%ebp),%eax
  801506:	8b 10                	mov    (%eax),%edx
  801508:	b9 00 00 00 00       	mov    $0x0,%ecx
  80150d:	8d 40 04             	lea    0x4(%eax),%eax
  801510:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801513:	b8 0a 00 00 00       	mov    $0xa,%eax
  801518:	eb 45                	jmp    80155f <vprintfmt+0x386>
			putch('X', putdat);
  80151a:	83 ec 08             	sub    $0x8,%esp
  80151d:	53                   	push   %ebx
  80151e:	6a 58                	push   $0x58
  801520:	ff d6                	call   *%esi
			putch('X', putdat);
  801522:	83 c4 08             	add    $0x8,%esp
  801525:	53                   	push   %ebx
  801526:	6a 58                	push   $0x58
  801528:	ff d6                	call   *%esi
			putch('X', putdat);
  80152a:	83 c4 08             	add    $0x8,%esp
  80152d:	53                   	push   %ebx
  80152e:	6a 58                	push   $0x58
  801530:	ff d6                	call   *%esi
			break;
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	eb 42                	jmp    801579 <vprintfmt+0x3a0>
			putch('0', putdat);
  801537:	83 ec 08             	sub    $0x8,%esp
  80153a:	53                   	push   %ebx
  80153b:	6a 30                	push   $0x30
  80153d:	ff d6                	call   *%esi
			putch('x', putdat);
  80153f:	83 c4 08             	add    $0x8,%esp
  801542:	53                   	push   %ebx
  801543:	6a 78                	push   $0x78
  801545:	ff d6                	call   *%esi
			num = (unsigned long long)
  801547:	8b 45 14             	mov    0x14(%ebp),%eax
  80154a:	8b 10                	mov    (%eax),%edx
  80154c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801551:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801554:	8d 40 04             	lea    0x4(%eax),%eax
  801557:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80155a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80155f:	83 ec 0c             	sub    $0xc,%esp
  801562:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801566:	57                   	push   %edi
  801567:	ff 75 e0             	pushl  -0x20(%ebp)
  80156a:	50                   	push   %eax
  80156b:	51                   	push   %ecx
  80156c:	52                   	push   %edx
  80156d:	89 da                	mov    %ebx,%edx
  80156f:	89 f0                	mov    %esi,%eax
  801571:	e8 7a fb ff ff       	call   8010f0 <printnum>
			break;
  801576:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801579:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80157c:	83 c7 01             	add    $0x1,%edi
  80157f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801583:	83 f8 25             	cmp    $0x25,%eax
  801586:	0f 84 64 fc ff ff    	je     8011f0 <vprintfmt+0x17>
			if (ch == '\0')
  80158c:	85 c0                	test   %eax,%eax
  80158e:	0f 84 8b 00 00 00    	je     80161f <vprintfmt+0x446>
			putch(ch, putdat);
  801594:	83 ec 08             	sub    $0x8,%esp
  801597:	53                   	push   %ebx
  801598:	50                   	push   %eax
  801599:	ff d6                	call   *%esi
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	eb dc                	jmp    80157c <vprintfmt+0x3a3>
	if (lflag >= 2)
  8015a0:	83 f9 01             	cmp    $0x1,%ecx
  8015a3:	7e 15                	jle    8015ba <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8015a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a8:	8b 10                	mov    (%eax),%edx
  8015aa:	8b 48 04             	mov    0x4(%eax),%ecx
  8015ad:	8d 40 08             	lea    0x8(%eax),%eax
  8015b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8015b3:	b8 10 00 00 00       	mov    $0x10,%eax
  8015b8:	eb a5                	jmp    80155f <vprintfmt+0x386>
	else if (lflag)
  8015ba:	85 c9                	test   %ecx,%ecx
  8015bc:	75 17                	jne    8015d5 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8015be:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c1:	8b 10                	mov    (%eax),%edx
  8015c3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015c8:	8d 40 04             	lea    0x4(%eax),%eax
  8015cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8015ce:	b8 10 00 00 00       	mov    $0x10,%eax
  8015d3:	eb 8a                	jmp    80155f <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8015d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d8:	8b 10                	mov    (%eax),%edx
  8015da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015df:	8d 40 04             	lea    0x4(%eax),%eax
  8015e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8015e5:	b8 10 00 00 00       	mov    $0x10,%eax
  8015ea:	e9 70 ff ff ff       	jmp    80155f <vprintfmt+0x386>
			putch(ch, putdat);
  8015ef:	83 ec 08             	sub    $0x8,%esp
  8015f2:	53                   	push   %ebx
  8015f3:	6a 25                	push   $0x25
  8015f5:	ff d6                	call   *%esi
			break;
  8015f7:	83 c4 10             	add    $0x10,%esp
  8015fa:	e9 7a ff ff ff       	jmp    801579 <vprintfmt+0x3a0>
			putch('%', putdat);
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	53                   	push   %ebx
  801603:	6a 25                	push   $0x25
  801605:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	89 f8                	mov    %edi,%eax
  80160c:	eb 03                	jmp    801611 <vprintfmt+0x438>
  80160e:	83 e8 01             	sub    $0x1,%eax
  801611:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801615:	75 f7                	jne    80160e <vprintfmt+0x435>
  801617:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80161a:	e9 5a ff ff ff       	jmp    801579 <vprintfmt+0x3a0>
}
  80161f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801622:	5b                   	pop    %ebx
  801623:	5e                   	pop    %esi
  801624:	5f                   	pop    %edi
  801625:	5d                   	pop    %ebp
  801626:	c3                   	ret    

00801627 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 18             	sub    $0x18,%esp
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801633:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801636:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80163a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80163d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801644:	85 c0                	test   %eax,%eax
  801646:	74 26                	je     80166e <vsnprintf+0x47>
  801648:	85 d2                	test   %edx,%edx
  80164a:	7e 22                	jle    80166e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80164c:	ff 75 14             	pushl  0x14(%ebp)
  80164f:	ff 75 10             	pushl  0x10(%ebp)
  801652:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	68 9f 11 80 00       	push   $0x80119f
  80165b:	e8 79 fb ff ff       	call   8011d9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801663:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801669:	83 c4 10             	add    $0x10,%esp
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    
		return -E_INVAL;
  80166e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801673:	eb f7                	jmp    80166c <vsnprintf+0x45>

00801675 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80167b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80167e:	50                   	push   %eax
  80167f:	ff 75 10             	pushl  0x10(%ebp)
  801682:	ff 75 0c             	pushl  0xc(%ebp)
  801685:	ff 75 08             	pushl  0x8(%ebp)
  801688:	e8 9a ff ff ff       	call   801627 <vsnprintf>
	va_end(ap);

	return rc;
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801695:	b8 00 00 00 00       	mov    $0x0,%eax
  80169a:	eb 03                	jmp    80169f <strlen+0x10>
		n++;
  80169c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80169f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8016a3:	75 f7                	jne    80169c <strlen+0xd>
	return n;
}
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 03                	jmp    8016ba <strnlen+0x13>
		n++;
  8016b7:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016ba:	39 d0                	cmp    %edx,%eax
  8016bc:	74 06                	je     8016c4 <strnlen+0x1d>
  8016be:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8016c2:	75 f3                	jne    8016b7 <strnlen+0x10>
	return n;
}
  8016c4:	5d                   	pop    %ebp
  8016c5:	c3                   	ret    

008016c6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	53                   	push   %ebx
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8016d0:	89 c2                	mov    %eax,%edx
  8016d2:	83 c1 01             	add    $0x1,%ecx
  8016d5:	83 c2 01             	add    $0x1,%edx
  8016d8:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8016dc:	88 5a ff             	mov    %bl,-0x1(%edx)
  8016df:	84 db                	test   %bl,%bl
  8016e1:	75 ef                	jne    8016d2 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8016e3:	5b                   	pop    %ebx
  8016e4:	5d                   	pop    %ebp
  8016e5:	c3                   	ret    

008016e6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	53                   	push   %ebx
  8016ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8016ed:	53                   	push   %ebx
  8016ee:	e8 9c ff ff ff       	call   80168f <strlen>
  8016f3:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	01 d8                	add    %ebx,%eax
  8016fb:	50                   	push   %eax
  8016fc:	e8 c5 ff ff ff       	call   8016c6 <strcpy>
	return dst;
}
  801701:	89 d8                	mov    %ebx,%eax
  801703:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	56                   	push   %esi
  80170c:	53                   	push   %ebx
  80170d:	8b 75 08             	mov    0x8(%ebp),%esi
  801710:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801713:	89 f3                	mov    %esi,%ebx
  801715:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801718:	89 f2                	mov    %esi,%edx
  80171a:	eb 0f                	jmp    80172b <strncpy+0x23>
		*dst++ = *src;
  80171c:	83 c2 01             	add    $0x1,%edx
  80171f:	0f b6 01             	movzbl (%ecx),%eax
  801722:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801725:	80 39 01             	cmpb   $0x1,(%ecx)
  801728:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80172b:	39 da                	cmp    %ebx,%edx
  80172d:	75 ed                	jne    80171c <strncpy+0x14>
	}
	return ret;
}
  80172f:	89 f0                	mov    %esi,%eax
  801731:	5b                   	pop    %ebx
  801732:	5e                   	pop    %esi
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    

00801735 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	56                   	push   %esi
  801739:	53                   	push   %ebx
  80173a:	8b 75 08             	mov    0x8(%ebp),%esi
  80173d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801740:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801743:	89 f0                	mov    %esi,%eax
  801745:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801749:	85 c9                	test   %ecx,%ecx
  80174b:	75 0b                	jne    801758 <strlcpy+0x23>
  80174d:	eb 17                	jmp    801766 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80174f:	83 c2 01             	add    $0x1,%edx
  801752:	83 c0 01             	add    $0x1,%eax
  801755:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801758:	39 d8                	cmp    %ebx,%eax
  80175a:	74 07                	je     801763 <strlcpy+0x2e>
  80175c:	0f b6 0a             	movzbl (%edx),%ecx
  80175f:	84 c9                	test   %cl,%cl
  801761:	75 ec                	jne    80174f <strlcpy+0x1a>
		*dst = '\0';
  801763:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801766:	29 f0                	sub    %esi,%eax
}
  801768:	5b                   	pop    %ebx
  801769:	5e                   	pop    %esi
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801772:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801775:	eb 06                	jmp    80177d <strcmp+0x11>
		p++, q++;
  801777:	83 c1 01             	add    $0x1,%ecx
  80177a:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80177d:	0f b6 01             	movzbl (%ecx),%eax
  801780:	84 c0                	test   %al,%al
  801782:	74 04                	je     801788 <strcmp+0x1c>
  801784:	3a 02                	cmp    (%edx),%al
  801786:	74 ef                	je     801777 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801788:	0f b6 c0             	movzbl %al,%eax
  80178b:	0f b6 12             	movzbl (%edx),%edx
  80178e:	29 d0                	sub    %edx,%eax
}
  801790:	5d                   	pop    %ebp
  801791:	c3                   	ret    

00801792 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	53                   	push   %ebx
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179c:	89 c3                	mov    %eax,%ebx
  80179e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8017a1:	eb 06                	jmp    8017a9 <strncmp+0x17>
		n--, p++, q++;
  8017a3:	83 c0 01             	add    $0x1,%eax
  8017a6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8017a9:	39 d8                	cmp    %ebx,%eax
  8017ab:	74 16                	je     8017c3 <strncmp+0x31>
  8017ad:	0f b6 08             	movzbl (%eax),%ecx
  8017b0:	84 c9                	test   %cl,%cl
  8017b2:	74 04                	je     8017b8 <strncmp+0x26>
  8017b4:	3a 0a                	cmp    (%edx),%cl
  8017b6:	74 eb                	je     8017a3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017b8:	0f b6 00             	movzbl (%eax),%eax
  8017bb:	0f b6 12             	movzbl (%edx),%edx
  8017be:	29 d0                	sub    %edx,%eax
}
  8017c0:	5b                   	pop    %ebx
  8017c1:	5d                   	pop    %ebp
  8017c2:	c3                   	ret    
		return 0;
  8017c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c8:	eb f6                	jmp    8017c0 <strncmp+0x2e>

008017ca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8017d4:	0f b6 10             	movzbl (%eax),%edx
  8017d7:	84 d2                	test   %dl,%dl
  8017d9:	74 09                	je     8017e4 <strchr+0x1a>
		if (*s == c)
  8017db:	38 ca                	cmp    %cl,%dl
  8017dd:	74 0a                	je     8017e9 <strchr+0x1f>
	for (; *s; s++)
  8017df:	83 c0 01             	add    $0x1,%eax
  8017e2:	eb f0                	jmp    8017d4 <strchr+0xa>
			return (char *) s;
	return 0;
  8017e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e9:	5d                   	pop    %ebp
  8017ea:	c3                   	ret    

008017eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8017f5:	eb 03                	jmp    8017fa <strfind+0xf>
  8017f7:	83 c0 01             	add    $0x1,%eax
  8017fa:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8017fd:	38 ca                	cmp    %cl,%dl
  8017ff:	74 04                	je     801805 <strfind+0x1a>
  801801:	84 d2                	test   %dl,%dl
  801803:	75 f2                	jne    8017f7 <strfind+0xc>
			break;
	return (char *) s;
}
  801805:	5d                   	pop    %ebp
  801806:	c3                   	ret    

00801807 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	57                   	push   %edi
  80180b:	56                   	push   %esi
  80180c:	53                   	push   %ebx
  80180d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801810:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801813:	85 c9                	test   %ecx,%ecx
  801815:	74 13                	je     80182a <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801817:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80181d:	75 05                	jne    801824 <memset+0x1d>
  80181f:	f6 c1 03             	test   $0x3,%cl
  801822:	74 0d                	je     801831 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	fc                   	cld    
  801828:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80182a:	89 f8                	mov    %edi,%eax
  80182c:	5b                   	pop    %ebx
  80182d:	5e                   	pop    %esi
  80182e:	5f                   	pop    %edi
  80182f:	5d                   	pop    %ebp
  801830:	c3                   	ret    
		c &= 0xFF;
  801831:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801835:	89 d3                	mov    %edx,%ebx
  801837:	c1 e3 08             	shl    $0x8,%ebx
  80183a:	89 d0                	mov    %edx,%eax
  80183c:	c1 e0 18             	shl    $0x18,%eax
  80183f:	89 d6                	mov    %edx,%esi
  801841:	c1 e6 10             	shl    $0x10,%esi
  801844:	09 f0                	or     %esi,%eax
  801846:	09 c2                	or     %eax,%edx
  801848:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80184a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80184d:	89 d0                	mov    %edx,%eax
  80184f:	fc                   	cld    
  801850:	f3 ab                	rep stos %eax,%es:(%edi)
  801852:	eb d6                	jmp    80182a <memset+0x23>

00801854 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	57                   	push   %edi
  801858:	56                   	push   %esi
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80185f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801862:	39 c6                	cmp    %eax,%esi
  801864:	73 35                	jae    80189b <memmove+0x47>
  801866:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801869:	39 c2                	cmp    %eax,%edx
  80186b:	76 2e                	jbe    80189b <memmove+0x47>
		s += n;
		d += n;
  80186d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801870:	89 d6                	mov    %edx,%esi
  801872:	09 fe                	or     %edi,%esi
  801874:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80187a:	74 0c                	je     801888 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80187c:	83 ef 01             	sub    $0x1,%edi
  80187f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801882:	fd                   	std    
  801883:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801885:	fc                   	cld    
  801886:	eb 21                	jmp    8018a9 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801888:	f6 c1 03             	test   $0x3,%cl
  80188b:	75 ef                	jne    80187c <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80188d:	83 ef 04             	sub    $0x4,%edi
  801890:	8d 72 fc             	lea    -0x4(%edx),%esi
  801893:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801896:	fd                   	std    
  801897:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801899:	eb ea                	jmp    801885 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80189b:	89 f2                	mov    %esi,%edx
  80189d:	09 c2                	or     %eax,%edx
  80189f:	f6 c2 03             	test   $0x3,%dl
  8018a2:	74 09                	je     8018ad <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8018a4:	89 c7                	mov    %eax,%edi
  8018a6:	fc                   	cld    
  8018a7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8018a9:	5e                   	pop    %esi
  8018aa:	5f                   	pop    %edi
  8018ab:	5d                   	pop    %ebp
  8018ac:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8018ad:	f6 c1 03             	test   $0x3,%cl
  8018b0:	75 f2                	jne    8018a4 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8018b2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8018b5:	89 c7                	mov    %eax,%edi
  8018b7:	fc                   	cld    
  8018b8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8018ba:	eb ed                	jmp    8018a9 <memmove+0x55>

008018bc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8018bf:	ff 75 10             	pushl  0x10(%ebp)
  8018c2:	ff 75 0c             	pushl  0xc(%ebp)
  8018c5:	ff 75 08             	pushl  0x8(%ebp)
  8018c8:	e8 87 ff ff ff       	call   801854 <memmove>
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	56                   	push   %esi
  8018d3:	53                   	push   %ebx
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018da:	89 c6                	mov    %eax,%esi
  8018dc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018df:	39 f0                	cmp    %esi,%eax
  8018e1:	74 1c                	je     8018ff <memcmp+0x30>
		if (*s1 != *s2)
  8018e3:	0f b6 08             	movzbl (%eax),%ecx
  8018e6:	0f b6 1a             	movzbl (%edx),%ebx
  8018e9:	38 d9                	cmp    %bl,%cl
  8018eb:	75 08                	jne    8018f5 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8018ed:	83 c0 01             	add    $0x1,%eax
  8018f0:	83 c2 01             	add    $0x1,%edx
  8018f3:	eb ea                	jmp    8018df <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8018f5:	0f b6 c1             	movzbl %cl,%eax
  8018f8:	0f b6 db             	movzbl %bl,%ebx
  8018fb:	29 d8                	sub    %ebx,%eax
  8018fd:	eb 05                	jmp    801904 <memcmp+0x35>
	}

	return 0;
  8018ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801904:	5b                   	pop    %ebx
  801905:	5e                   	pop    %esi
  801906:	5d                   	pop    %ebp
  801907:	c3                   	ret    

00801908 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801911:	89 c2                	mov    %eax,%edx
  801913:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801916:	39 d0                	cmp    %edx,%eax
  801918:	73 09                	jae    801923 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191a:	38 08                	cmp    %cl,(%eax)
  80191c:	74 05                	je     801923 <memfind+0x1b>
	for (; s < ends; s++)
  80191e:	83 c0 01             	add    $0x1,%eax
  801921:	eb f3                	jmp    801916 <memfind+0xe>
			break;
	return (void *) s;
}
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    

00801925 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	57                   	push   %edi
  801929:	56                   	push   %esi
  80192a:	53                   	push   %ebx
  80192b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80192e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801931:	eb 03                	jmp    801936 <strtol+0x11>
		s++;
  801933:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801936:	0f b6 01             	movzbl (%ecx),%eax
  801939:	3c 20                	cmp    $0x20,%al
  80193b:	74 f6                	je     801933 <strtol+0xe>
  80193d:	3c 09                	cmp    $0x9,%al
  80193f:	74 f2                	je     801933 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  801941:	3c 2b                	cmp    $0x2b,%al
  801943:	74 2e                	je     801973 <strtol+0x4e>
	int neg = 0;
  801945:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80194a:	3c 2d                	cmp    $0x2d,%al
  80194c:	74 2f                	je     80197d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80194e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801954:	75 05                	jne    80195b <strtol+0x36>
  801956:	80 39 30             	cmpb   $0x30,(%ecx)
  801959:	74 2c                	je     801987 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80195b:	85 db                	test   %ebx,%ebx
  80195d:	75 0a                	jne    801969 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80195f:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  801964:	80 39 30             	cmpb   $0x30,(%ecx)
  801967:	74 28                	je     801991 <strtol+0x6c>
		base = 10;
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
  80196e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801971:	eb 50                	jmp    8019c3 <strtol+0x9e>
		s++;
  801973:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801976:	bf 00 00 00 00       	mov    $0x0,%edi
  80197b:	eb d1                	jmp    80194e <strtol+0x29>
		s++, neg = 1;
  80197d:	83 c1 01             	add    $0x1,%ecx
  801980:	bf 01 00 00 00       	mov    $0x1,%edi
  801985:	eb c7                	jmp    80194e <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801987:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80198b:	74 0e                	je     80199b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80198d:	85 db                	test   %ebx,%ebx
  80198f:	75 d8                	jne    801969 <strtol+0x44>
		s++, base = 8;
  801991:	83 c1 01             	add    $0x1,%ecx
  801994:	bb 08 00 00 00       	mov    $0x8,%ebx
  801999:	eb ce                	jmp    801969 <strtol+0x44>
		s += 2, base = 16;
  80199b:	83 c1 02             	add    $0x2,%ecx
  80199e:	bb 10 00 00 00       	mov    $0x10,%ebx
  8019a3:	eb c4                	jmp    801969 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8019a5:	8d 72 9f             	lea    -0x61(%edx),%esi
  8019a8:	89 f3                	mov    %esi,%ebx
  8019aa:	80 fb 19             	cmp    $0x19,%bl
  8019ad:	77 29                	ja     8019d8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  8019af:	0f be d2             	movsbl %dl,%edx
  8019b2:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8019b5:	3b 55 10             	cmp    0x10(%ebp),%edx
  8019b8:	7d 30                	jge    8019ea <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8019ba:	83 c1 01             	add    $0x1,%ecx
  8019bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019c1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8019c3:	0f b6 11             	movzbl (%ecx),%edx
  8019c6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8019c9:	89 f3                	mov    %esi,%ebx
  8019cb:	80 fb 09             	cmp    $0x9,%bl
  8019ce:	77 d5                	ja     8019a5 <strtol+0x80>
			dig = *s - '0';
  8019d0:	0f be d2             	movsbl %dl,%edx
  8019d3:	83 ea 30             	sub    $0x30,%edx
  8019d6:	eb dd                	jmp    8019b5 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  8019d8:	8d 72 bf             	lea    -0x41(%edx),%esi
  8019db:	89 f3                	mov    %esi,%ebx
  8019dd:	80 fb 19             	cmp    $0x19,%bl
  8019e0:	77 08                	ja     8019ea <strtol+0xc5>
			dig = *s - 'A' + 10;
  8019e2:	0f be d2             	movsbl %dl,%edx
  8019e5:	83 ea 37             	sub    $0x37,%edx
  8019e8:	eb cb                	jmp    8019b5 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  8019ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019ee:	74 05                	je     8019f5 <strtol+0xd0>
		*endptr = (char *) s;
  8019f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019f3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8019f5:	89 c2                	mov    %eax,%edx
  8019f7:	f7 da                	neg    %edx
  8019f9:	85 ff                	test   %edi,%edi
  8019fb:	0f 45 c2             	cmovne %edx,%eax
}
  8019fe:	5b                   	pop    %ebx
  8019ff:	5e                   	pop    %esi
  801a00:	5f                   	pop    %edi
  801a01:	5d                   	pop    %ebp
  801a02:	c3                   	ret    

00801a03 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801a09:	68 40 21 80 00       	push   $0x802140
  801a0e:	6a 1a                	push   $0x1a
  801a10:	68 59 21 80 00       	push   $0x802159
  801a15:	e8 e7 f5 ff ff       	call   801001 <_panic>

00801a1a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801a20:	68 63 21 80 00       	push   $0x802163
  801a25:	6a 2a                	push   $0x2a
  801a27:	68 59 21 80 00       	push   $0x802159
  801a2c:	e8 d0 f5 ff ff       	call   801001 <_panic>

00801a31 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a37:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a3c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a3f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a45:	8b 52 50             	mov    0x50(%edx),%edx
  801a48:	39 ca                	cmp    %ecx,%edx
  801a4a:	74 11                	je     801a5d <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801a4c:	83 c0 01             	add    $0x1,%eax
  801a4f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a54:	75 e6                	jne    801a3c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801a56:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5b:	eb 0b                	jmp    801a68 <ipc_find_env+0x37>
			return envs[i].env_id;
  801a5d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a60:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a65:	8b 40 48             	mov    0x48(%eax),%eax
}
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    

00801a6a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a70:	89 d0                	mov    %edx,%eax
  801a72:	c1 e8 16             	shr    $0x16,%eax
  801a75:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a7c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801a81:	f6 c1 01             	test   $0x1,%cl
  801a84:	74 1d                	je     801aa3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801a86:	c1 ea 0c             	shr    $0xc,%edx
  801a89:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801a90:	f6 c2 01             	test   $0x1,%dl
  801a93:	74 0e                	je     801aa3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801a95:	c1 ea 0c             	shr    $0xc,%edx
  801a98:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801a9f:	ef 
  801aa0:	0f b7 c0             	movzwl %ax,%eax
}
  801aa3:	5d                   	pop    %ebp
  801aa4:	c3                   	ret    
  801aa5:	66 90                	xchg   %ax,%ax
  801aa7:	66 90                	xchg   %ax,%ax
  801aa9:	66 90                	xchg   %ax,%ax
  801aab:	66 90                	xchg   %ax,%ax
  801aad:	66 90                	xchg   %ax,%ax
  801aaf:	90                   	nop

00801ab0 <__udivdi3>:
  801ab0:	55                   	push   %ebp
  801ab1:	57                   	push   %edi
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 1c             	sub    $0x1c,%esp
  801ab7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801abb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801abf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ac3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ac7:	85 d2                	test   %edx,%edx
  801ac9:	75 35                	jne    801b00 <__udivdi3+0x50>
  801acb:	39 f3                	cmp    %esi,%ebx
  801acd:	0f 87 bd 00 00 00    	ja     801b90 <__udivdi3+0xe0>
  801ad3:	85 db                	test   %ebx,%ebx
  801ad5:	89 d9                	mov    %ebx,%ecx
  801ad7:	75 0b                	jne    801ae4 <__udivdi3+0x34>
  801ad9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ade:	31 d2                	xor    %edx,%edx
  801ae0:	f7 f3                	div    %ebx
  801ae2:	89 c1                	mov    %eax,%ecx
  801ae4:	31 d2                	xor    %edx,%edx
  801ae6:	89 f0                	mov    %esi,%eax
  801ae8:	f7 f1                	div    %ecx
  801aea:	89 c6                	mov    %eax,%esi
  801aec:	89 e8                	mov    %ebp,%eax
  801aee:	89 f7                	mov    %esi,%edi
  801af0:	f7 f1                	div    %ecx
  801af2:	89 fa                	mov    %edi,%edx
  801af4:	83 c4 1c             	add    $0x1c,%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5f                   	pop    %edi
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    
  801afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801b00:	39 f2                	cmp    %esi,%edx
  801b02:	77 7c                	ja     801b80 <__udivdi3+0xd0>
  801b04:	0f bd fa             	bsr    %edx,%edi
  801b07:	83 f7 1f             	xor    $0x1f,%edi
  801b0a:	0f 84 98 00 00 00    	je     801ba8 <__udivdi3+0xf8>
  801b10:	89 f9                	mov    %edi,%ecx
  801b12:	b8 20 00 00 00       	mov    $0x20,%eax
  801b17:	29 f8                	sub    %edi,%eax
  801b19:	d3 e2                	shl    %cl,%edx
  801b1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b1f:	89 c1                	mov    %eax,%ecx
  801b21:	89 da                	mov    %ebx,%edx
  801b23:	d3 ea                	shr    %cl,%edx
  801b25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801b29:	09 d1                	or     %edx,%ecx
  801b2b:	89 f2                	mov    %esi,%edx
  801b2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b31:	89 f9                	mov    %edi,%ecx
  801b33:	d3 e3                	shl    %cl,%ebx
  801b35:	89 c1                	mov    %eax,%ecx
  801b37:	d3 ea                	shr    %cl,%edx
  801b39:	89 f9                	mov    %edi,%ecx
  801b3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801b3f:	d3 e6                	shl    %cl,%esi
  801b41:	89 eb                	mov    %ebp,%ebx
  801b43:	89 c1                	mov    %eax,%ecx
  801b45:	d3 eb                	shr    %cl,%ebx
  801b47:	09 de                	or     %ebx,%esi
  801b49:	89 f0                	mov    %esi,%eax
  801b4b:	f7 74 24 08          	divl   0x8(%esp)
  801b4f:	89 d6                	mov    %edx,%esi
  801b51:	89 c3                	mov    %eax,%ebx
  801b53:	f7 64 24 0c          	mull   0xc(%esp)
  801b57:	39 d6                	cmp    %edx,%esi
  801b59:	72 0c                	jb     801b67 <__udivdi3+0xb7>
  801b5b:	89 f9                	mov    %edi,%ecx
  801b5d:	d3 e5                	shl    %cl,%ebp
  801b5f:	39 c5                	cmp    %eax,%ebp
  801b61:	73 5d                	jae    801bc0 <__udivdi3+0x110>
  801b63:	39 d6                	cmp    %edx,%esi
  801b65:	75 59                	jne    801bc0 <__udivdi3+0x110>
  801b67:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b6a:	31 ff                	xor    %edi,%edi
  801b6c:	89 fa                	mov    %edi,%edx
  801b6e:	83 c4 1c             	add    $0x1c,%esp
  801b71:	5b                   	pop    %ebx
  801b72:	5e                   	pop    %esi
  801b73:	5f                   	pop    %edi
  801b74:	5d                   	pop    %ebp
  801b75:	c3                   	ret    
  801b76:	8d 76 00             	lea    0x0(%esi),%esi
  801b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801b80:	31 ff                	xor    %edi,%edi
  801b82:	31 c0                	xor    %eax,%eax
  801b84:	89 fa                	mov    %edi,%edx
  801b86:	83 c4 1c             	add    $0x1c,%esp
  801b89:	5b                   	pop    %ebx
  801b8a:	5e                   	pop    %esi
  801b8b:	5f                   	pop    %edi
  801b8c:	5d                   	pop    %ebp
  801b8d:	c3                   	ret    
  801b8e:	66 90                	xchg   %ax,%ax
  801b90:	31 ff                	xor    %edi,%edi
  801b92:	89 e8                	mov    %ebp,%eax
  801b94:	89 f2                	mov    %esi,%edx
  801b96:	f7 f3                	div    %ebx
  801b98:	89 fa                	mov    %edi,%edx
  801b9a:	83 c4 1c             	add    $0x1c,%esp
  801b9d:	5b                   	pop    %ebx
  801b9e:	5e                   	pop    %esi
  801b9f:	5f                   	pop    %edi
  801ba0:	5d                   	pop    %ebp
  801ba1:	c3                   	ret    
  801ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ba8:	39 f2                	cmp    %esi,%edx
  801baa:	72 06                	jb     801bb2 <__udivdi3+0x102>
  801bac:	31 c0                	xor    %eax,%eax
  801bae:	39 eb                	cmp    %ebp,%ebx
  801bb0:	77 d2                	ja     801b84 <__udivdi3+0xd4>
  801bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb7:	eb cb                	jmp    801b84 <__udivdi3+0xd4>
  801bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801bc0:	89 d8                	mov    %ebx,%eax
  801bc2:	31 ff                	xor    %edi,%edi
  801bc4:	eb be                	jmp    801b84 <__udivdi3+0xd4>
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	66 90                	xchg   %ax,%ax
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	66 90                	xchg   %ax,%ax
  801bce:	66 90                	xchg   %ax,%ax

00801bd0 <__umoddi3>:
  801bd0:	55                   	push   %ebp
  801bd1:	57                   	push   %edi
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 1c             	sub    $0x1c,%esp
  801bd7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801bdb:	8b 74 24 30          	mov    0x30(%esp),%esi
  801bdf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801be3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801be7:	85 ed                	test   %ebp,%ebp
  801be9:	89 f0                	mov    %esi,%eax
  801beb:	89 da                	mov    %ebx,%edx
  801bed:	75 19                	jne    801c08 <__umoddi3+0x38>
  801bef:	39 df                	cmp    %ebx,%edi
  801bf1:	0f 86 b1 00 00 00    	jbe    801ca8 <__umoddi3+0xd8>
  801bf7:	f7 f7                	div    %edi
  801bf9:	89 d0                	mov    %edx,%eax
  801bfb:	31 d2                	xor    %edx,%edx
  801bfd:	83 c4 1c             	add    $0x1c,%esp
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5f                   	pop    %edi
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    
  801c05:	8d 76 00             	lea    0x0(%esi),%esi
  801c08:	39 dd                	cmp    %ebx,%ebp
  801c0a:	77 f1                	ja     801bfd <__umoddi3+0x2d>
  801c0c:	0f bd cd             	bsr    %ebp,%ecx
  801c0f:	83 f1 1f             	xor    $0x1f,%ecx
  801c12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c16:	0f 84 b4 00 00 00    	je     801cd0 <__umoddi3+0x100>
  801c1c:	b8 20 00 00 00       	mov    $0x20,%eax
  801c21:	89 c2                	mov    %eax,%edx
  801c23:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c27:	29 c2                	sub    %eax,%edx
  801c29:	89 c1                	mov    %eax,%ecx
  801c2b:	89 f8                	mov    %edi,%eax
  801c2d:	d3 e5                	shl    %cl,%ebp
  801c2f:	89 d1                	mov    %edx,%ecx
  801c31:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c35:	d3 e8                	shr    %cl,%eax
  801c37:	09 c5                	or     %eax,%ebp
  801c39:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c3d:	89 c1                	mov    %eax,%ecx
  801c3f:	d3 e7                	shl    %cl,%edi
  801c41:	89 d1                	mov    %edx,%ecx
  801c43:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801c47:	89 df                	mov    %ebx,%edi
  801c49:	d3 ef                	shr    %cl,%edi
  801c4b:	89 c1                	mov    %eax,%ecx
  801c4d:	89 f0                	mov    %esi,%eax
  801c4f:	d3 e3                	shl    %cl,%ebx
  801c51:	89 d1                	mov    %edx,%ecx
  801c53:	89 fa                	mov    %edi,%edx
  801c55:	d3 e8                	shr    %cl,%eax
  801c57:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801c5c:	09 d8                	or     %ebx,%eax
  801c5e:	f7 f5                	div    %ebp
  801c60:	d3 e6                	shl    %cl,%esi
  801c62:	89 d1                	mov    %edx,%ecx
  801c64:	f7 64 24 08          	mull   0x8(%esp)
  801c68:	39 d1                	cmp    %edx,%ecx
  801c6a:	89 c3                	mov    %eax,%ebx
  801c6c:	89 d7                	mov    %edx,%edi
  801c6e:	72 06                	jb     801c76 <__umoddi3+0xa6>
  801c70:	75 0e                	jne    801c80 <__umoddi3+0xb0>
  801c72:	39 c6                	cmp    %eax,%esi
  801c74:	73 0a                	jae    801c80 <__umoddi3+0xb0>
  801c76:	2b 44 24 08          	sub    0x8(%esp),%eax
  801c7a:	19 ea                	sbb    %ebp,%edx
  801c7c:	89 d7                	mov    %edx,%edi
  801c7e:	89 c3                	mov    %eax,%ebx
  801c80:	89 ca                	mov    %ecx,%edx
  801c82:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801c87:	29 de                	sub    %ebx,%esi
  801c89:	19 fa                	sbb    %edi,%edx
  801c8b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801c8f:	89 d0                	mov    %edx,%eax
  801c91:	d3 e0                	shl    %cl,%eax
  801c93:	89 d9                	mov    %ebx,%ecx
  801c95:	d3 ee                	shr    %cl,%esi
  801c97:	d3 ea                	shr    %cl,%edx
  801c99:	09 f0                	or     %esi,%eax
  801c9b:	83 c4 1c             	add    $0x1c,%esp
  801c9e:	5b                   	pop    %ebx
  801c9f:	5e                   	pop    %esi
  801ca0:	5f                   	pop    %edi
  801ca1:	5d                   	pop    %ebp
  801ca2:	c3                   	ret    
  801ca3:	90                   	nop
  801ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ca8:	85 ff                	test   %edi,%edi
  801caa:	89 f9                	mov    %edi,%ecx
  801cac:	75 0b                	jne    801cb9 <__umoddi3+0xe9>
  801cae:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb3:	31 d2                	xor    %edx,%edx
  801cb5:	f7 f7                	div    %edi
  801cb7:	89 c1                	mov    %eax,%ecx
  801cb9:	89 d8                	mov    %ebx,%eax
  801cbb:	31 d2                	xor    %edx,%edx
  801cbd:	f7 f1                	div    %ecx
  801cbf:	89 f0                	mov    %esi,%eax
  801cc1:	f7 f1                	div    %ecx
  801cc3:	e9 31 ff ff ff       	jmp    801bf9 <__umoddi3+0x29>
  801cc8:	90                   	nop
  801cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cd0:	39 dd                	cmp    %ebx,%ebp
  801cd2:	72 08                	jb     801cdc <__umoddi3+0x10c>
  801cd4:	39 f7                	cmp    %esi,%edi
  801cd6:	0f 87 21 ff ff ff    	ja     801bfd <__umoddi3+0x2d>
  801cdc:	89 da                	mov    %ebx,%edx
  801cde:	89 f0                	mov    %esi,%eax
  801ce0:	29 f8                	sub    %edi,%eax
  801ce2:	19 ea                	sbb    %ebp,%edx
  801ce4:	e9 14 ff ff ff       	jmp    801bfd <__umoddi3+0x2d>
