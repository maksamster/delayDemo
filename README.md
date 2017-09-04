# delayDemo
#####GCD 是⼀种⾮常⽅便的使⽤多线程的⽅式。通过使⽤ GCD，我们可以在确保尽量简单的语法的前提下进⾏灵活的多线程编程。我们一起来看看Swift中GCD的调用。
''// 创建⽬标队列
'' let workingQueue = DispatchQueue(label: "my_queue")
'' // 派发到刚创建的队列中，GCD 会负责进⾏线程调度
'' workingQueue.async {
''     // 在 workingQueue 中异步进⾏
''     print("努⼒⼯作")
''     Thread.sleep(forTimeInterval: 2) // 模拟两秒的执⾏时间
''     DispatchQueue.main.async {
''         // 返回到主线程更新 UI
''         print("结束⼯作，更新 UI")
''     }
'' }
#####在⽇常的开发⼯作中，我们经常会遇到这样的需求：在 xx 秒后执⾏某个⽅法。⽐如切换界⾯ 2 秒后开始播⼀段动画，或者提示框出现 3 秒后⾃动消失等等...
#####最容易想到的是使⽤ Timer来创建⼀个若⼲秒后调⽤⼀次的计时器。但是这么做我们需要创建新的对象，和⼀个本来并不相⼲的 Timer 类扯上关系，同时也会⽤到 Objective-C 的运⾏时特性去查找⽅法等等，总觉着有点笨重。其实 GCD ⾥有⼀个很好⽤的延时调⽤我们可以加以利⽤写出很漂亮的⽅法来，那就是asyncAfter 。最简单的使⽤⽅法看起来是这样的：
''let time: TimeInterval = 2.0
'' DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
'' print("2 秒后输出")
'' }

#####代码⾮常简单，并没什么值得详细说明的。只是每次写这么多的话也挺累的，在这⾥我们可以稍微将它封装的好⽤⼀些，最好再加上取消的功能。
''typealias Task = (_ cancel: Bool) ->()
'' class delayDemo {
'' 
''     
''     func delay(_ time: TimeInterval, task: @escaping ()->()) -> Task? {
''         
''         func dispatch_later(block: @escaping ()->()) {
''         
''             let t = DispatchTime.now() + time
''             DispatchQueue.main.asyncAfter(deadline: t, execute: block)
''         }
''     
''     var closure: (()->())? = task
''     var result: Task?
''     
''     let delayedClosure: Task = { cancel in
''         
''         if let internalClosure = closure {
''         
''             if cancel == false {
''                 
''                 DispatchQueue.main.async(execute: internalClosure)
''             }
''         }
''         closure = nil
''         result = nil
''         }
''     
''     result = delayedClosure
''     
''     dispatch_later {
''     
''     if let delayedClosure = result {
''     
''             delayedClosure(false)
''         }
''     }
''     
''     return result
''     
''     }
''     
''     func cancel(_ task: Task?) {
''     
''         task?(true)
''     }
'' }
'' 
#####使⽤的时候就很简单了，我们想在 2 秒以后⼲点⼉什么的话：
''delay(2) { print("2 秒后输出") }
#####想要取消的话，我们可以先保留⼀个对 Task 的引⽤，然后调⽤ cancel ：
''let task = delay(5) { print("拨打 110") }
'' // 仔细想⼀想..
'' // 还是取消为妙..
'' cancel(task)
附件：[demo]
