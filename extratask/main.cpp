// created by Ivan Martsilenko
// SADMT - 4
// extratask for OS

#include <iostream>
#include <unistd.h>
#include <thread>  
#include <mutex>
#include <deque>
#include <condition_variable>

const int maxBufferSize = 50 ;

class UserMessage
{
    public:
    int id;
    int number;
    UserMessage(int ID, int Number)
    {
        id = ID;
        number = Number;
    }
};
class ResultMessage
{
    public:
    int id; 
    std::string result;
    ResultMessage(int ID, std::string Result)
    {
        id = ID;
        result = Result;
    }
};

std::mutex in;
std::mutex work;
std::mutex out;
std::condition_variable notifyReader;
std::condition_variable notifyWorker;
std::condition_variable notifyWriter;
std::deque<UserMessage> readerBuffer;
std::deque<UserMessage> workerBuffer;
std::deque<ResultMessage> writerBuffer;

void Producer(int val) 
{
    while(val)
    {
        std::unique_lock<std::mutex> locker1(in);
        notifyReader.wait( locker1, [](){return readerBuffer.size() < maxBufferSize;});
        usleep(rand() % 500);
        readerBuffer.push_back(*(new UserMessage( val , rand() % 1000 + 1 )));
        std::cout << "Produced user: " << val << std::endl;
        val--;
        locker1.unlock();
        notifyReader.notify_one();
    }

}
static void myRead()
{
    while (true) {
        std::unique_lock<std::mutex> locker1(in);
        notifyReader.wait( locker1, [](){return readerBuffer.size() > 0;});
        UserMessage userMsg = readerBuffer.back();
        readerBuffer.pop_back(); 
        locker1.unlock();
        notifyReader.notify_one();

        std::unique_lock<std::mutex> locker2(work);
        notifyWorker.wait( locker2, [](){return workerBuffer.size() < maxBufferSize;});
        workerBuffer.push_back(userMsg);
        std::cout << "Readed user: " << userMsg.id  << std::endl;
        locker2.unlock();
        notifyWorker.notify_one();
    }

}

static void myWork()
{
    while (true){
        usleep(1000);
        std::unique_lock<std::mutex> locker2(work);
        notifyWorker.wait( locker2, [](){return workerBuffer.size() > 0;});
        UserMessage user = workerBuffer.back();
        workerBuffer.pop_back(); 
        locker2.unlock();
        notifyWorker.notify_one();

        std::unique_lock<std::mutex> locker3(out);
        notifyWriter.wait( locker3, [](){return writerBuffer.size() < maxBufferSize;});
        writerBuffer.push_back(*(new ResultMessage( user.id , ( user.number > (rand() % 1000 + 1 )) ? "Win" : "Lose")));
        std::cout << "Calculated user: " << user.id  << std::endl;
        locker3.unlock();
        notifyWriter.notify_one();
    }
}

static void myWrite()
{

    while(true) {
        std::unique_lock<std::mutex> locker3(out);
        notifyWriter.wait( locker3, [](){return writerBuffer.size() > 0;});
        usleep(300);
        ResultMessage res = writerBuffer.back();
        writerBuffer.pop_back();
        std::cout << "User: "<< res.id << " " << res.result << std::endl;
        locker3.unlock();
        notifyWriter.notify_one();
    }

}
int main()
{

    std::cout << "Extratask" << std::endl;
    std::thread producer(Producer, 150);
    std::thread reader(myRead);
    std::thread worker(myWork);
    std::thread writer(myWrite);
    producer.join();
    reader.join();
    worker.join();
    writer.join();
    
    std::cout << "Finished" << std::endl;
    return 0;
}