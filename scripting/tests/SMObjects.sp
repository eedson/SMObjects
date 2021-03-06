#include <SMObjects>

Object obj;

public void OnPluginStart()
{
	RegAdminCmd("sm_write", Command_Write, ADMFLAG_ROOT);
	RegAdminCmd("sm_read", Command_Read, ADMFLAG_ROOT);
}

public Action Command_Write(int client, int args)
{
	obj = new Object();
	
	obj.SetInt("index", client);
	obj.SetInt("timestamp", GetTime());
	obj.SetBool("server_exec", (client == 0));
	obj.SetFloat("somefloat", 2.0/3.0);
	
	obj.SetString("teststring", "Test");
	
	int testArray[] = {1, 2, 3, 4, 5};
	obj.SetArray("testarray", testArray, sizeof(testArray));
}

public Action Command_Read(int client, int args)
{
	int index, timestamp;
	bool server_exec;
	float somefloat;
	char teststring[32];
	
	index = obj.GetInt("index");
	timestamp = obj.GetInt("timestamp");
	server_exec = obj.GetBool("server_exec");
	somefloat = obj.GetFloat("somefloat");
	obj.GetString("teststring", teststring, sizeof(teststring));
	
	int arraySize = obj.GetArraySize("testarray");
	int[] testArray = new int[arraySize];
	obj.GetArray("testarray", testArray, arraySize);

	PrintToServer("Index: %i | Timestamp: %i | Server exec %i", index, timestamp, server_exec);
	PrintToServer("Some float: %.2f | Teststring: %s", somefloat, teststring);
	
	PrintToServer("size of testarray should be 5. It is: %i", arraySize);

	for (int i = 0; i < arraySize; i++)
	{
		PrintToServer("Should be %i: %i", i+1, testArray[i]);
	}
	
	ArrayList list = new ArrayList();
	obj.SetCell("list", list);
	
	delete list;
	delete obj;
}
