
#include<iostream>
#include<string.h>
#include<bits/stdc++.h>
using namespace std;
class  SymbolInfo
{
public:
    string Name="";
    string type="";
    SymbolInfo *next;
    string symbol="";
    string code="";		
    string var ="";
    string id_type = "";
    vector<string> par_type_list; 		
    SymbolInfo()
    {
        next = NULL;
        var ="";
        Name ="";
    }
    ~SymbolInfo()
    {
       // delete next;

    }
    SymbolInfo(string str1,string str2)
    {
        this->Name = str1 ;
        this->type = str2;
        var ="";
    }
    SymbolInfo(string str1,string str2,string str3)
    {
        this->Name = str1 ;
        this->type = str2;
        this->var = str3;
    }
    SymbolInfo(string str1,string str2,string str3,string str4)
    {
        this->Name = str1 ;
        this->type = str2;
        this->var = str3;
        this->id_type = str4;
    }
    SymbolInfo(string str1,string str2,string str3,string str4,vector<string> s)
    {
        this->Name = str1 ;
        this->type = str2;
        this->var = str3;
        this->id_type = str4;
        this->par_type_list = s;
    }
    string getName(){return Name;}
    
    string getType(){return type;}
    
    friend class ScopeTable;


};
class ScopeTable
{
    int bucket_size;
    SymbolInfo **arr;
    int index;

    string title;


public:
    int child ;
    ScopeTable *parentScope;


    void setIndex(int i)
    {
        index = i;

        this->title = parentScope->title+"_"+to_string(index);

    }
    int getIndex()
    {
        return index;
    }
    string getTitle(){return title;}
    ScopeTable(int n,int i)
    {
        title ="1";
        bucket_size = n;
        index = i;
        arr = new SymbolInfo*[n];
        for(int j =0; j<bucket_size; j++)
        {
            arr[j] = new SymbolInfo();
            arr[j] = NULL;


        }
        child =1;
        parentScope = NULL;

    }
    ~ScopeTable()
    {
    	/*
        for(int i=0; i<bucket_size; i++)
        {
            SymbolInfo *temp = arr[i];
            while(temp)
            {
                arr[i] = temp;
                temp = temp->next;
                delete arr[i];
            }
        }
        delete []arr; // more
        delete parentScope;
        */
    }
    int hash_func(string str)
    {
        int s =0;
        int len = str.length();
        for(int i=0 ; i<len; i++)
        {
            s+=str[i];
        }
        return s%bucket_size;
    }
    bool Insert(string name,string type)
    {
        SymbolInfo *si = new SymbolInfo(name,type);
        bool dupl = false;

        int h = hash_func(name);

        if(arr[h] == NULL)
        {
            arr[h] = si;
           
            //cout<<"Inserted "<<name<<" in ScopeTable# "<<title;
            //cout<<" at position "<<h<<", 0\n";
            return true;
        }
        else
        {
            SymbolInfo *temp;
            temp = arr[h];
            int id =0;
            while( temp->next != NULL )
            {
                if(name == temp->Name && type == temp->type)
                {
                    dupl = true;
                    //cout<<"< "<<name<<", "<<type<<" > already exists in current ScopeTable\n";
		    //fprintf(f,"%s already exists in current ScopeTable\n",name.c_str()); 	 
                    return false;
                }
                id++;
                temp = temp->next;
            }
            if(name == temp->Name && type == temp->type)
            {
                dupl = true;
                //cout<<"< "<<name<<", "<<type<<" > already exists in current ScopeTable\n";
                //fprintf(f,"%s already exists in current ScopeTable\n",name.c_str());
                return false;
            }
            if(!dupl)
            {

                //cout<<"Inserted "<<name<<" in ScopeTable# "<<title;
                //cout<<" at position "<<h<<", "<<id+1<<endl;
                temp->next = si;
                return true;

            }
            delete temp;

        }
        delete si;
        return false;
    }
    bool Insert(string name,string type,string var)
    {
        SymbolInfo *si = new SymbolInfo(name,type,var);
        bool dupl = false;

        int h = hash_func(name);

        if(arr[h] == NULL)
        {
            arr[h] = si;
           
            //cout<<"Inserted "<<name<<" in ScopeTable# "<<title;
            //cout<<" at position "<<h<<", 0\n";
            return true;
        }
        else
        {
            SymbolInfo *temp;
            temp = arr[h];
            int id =0;
            while( temp->next != NULL )
            {
                if(name == temp->Name && type == temp->type)
                {
                    dupl = true;
                    //cout<<"< "<<name<<", "<<type<<" > already exists in current ScopeTable\n";
		    //fprintf(f,"%s already exists in current ScopeTable\n",name.c_str()); 	 
                    return false;
                }
                id++;
                temp = temp->next;
            }
            if(name == temp->Name && type == temp->type)
            {
                dupl = true;
                //cout<<"< "<<name<<", "<<type<<" > already exists in current ScopeTable\n";
                //fprintf(f,"%s already exists in current ScopeTable\n",name.c_str());
                return false;
            }
            if(!dupl)
            {

                //cout<<"Inserted "<<name<<" in ScopeTable# "<<title;
                //cout<<" at position "<<h<<", "<<id+1<<endl;
                temp->next = si;
                return true;

            }
            delete temp;

        }
        delete si;
        return false;
    }
	bool Insert(string name,string type,string var,string id_type)
    {
        SymbolInfo *si = new SymbolInfo(name,type,var,id_type);
        bool dupl = false;

        int h = hash_func(name);

        if(arr[h] == NULL)
        {
            arr[h] = si;
           
            //cout<<"Inserted "<<name<<" in ScopeTable# "<<title;
            //cout<<" at position "<<h<<", 0\n";
            return true;
        }
        else
        {
            SymbolInfo *temp;
            temp = arr[h];
            int id =0;
            while( temp->next != NULL )
            {
                if(name == temp->Name && type == temp->type)
                {
                    dupl = true;
                    //cout<<"< "<<name<<", "<<type<<" > already exists in current ScopeTable\n";
		    //fprintf(f,"%s already exists in current ScopeTable\n",name.c_str()); 	 
                    return false;
                }
                id++;
                temp = temp->next;
            }
            if(name == temp->Name && type == temp->type)
            {
                dupl = true;
                //cout<<"< "<<name<<", "<<type<<" > already exists in current ScopeTable\n";
                //fprintf(f,"%s already exists in current ScopeTable\n",name.c_str());
                return false;
            }
            if(!dupl)
            {

                //cout<<"Inserted "<<name<<" in ScopeTable# "<<title;
                //cout<<" at position "<<h<<", "<<id+1<<endl;
                temp->next = si;
                return true;

            }
            delete temp;

        }
        delete si;
        return false;
    }
bool Insert(string name,string type,string var,string id_type,vector<string> p_type)
    {
        SymbolInfo *si = new SymbolInfo(name,type,var,id_type,p_type);
        bool dupl = false;

        int h = hash_func(name);

        if(arr[h] == NULL)
        {
            arr[h] = si;
           
            //cout<<"Inserted "<<name<<" in ScopeTable# "<<title;
            //cout<<" at position "<<h<<", 0\n";
            return true;
        }
        else
        {
            SymbolInfo *temp;
            temp = arr[h];
            int id =0;
            while( temp->next != NULL )
            {
                if(name == temp->Name && type == temp->type)
                {
                    dupl = true;
                    //cout<<"< "<<name<<", "<<type<<" > already exists in current ScopeTable\n";
		    //fprintf(f,"%s already exists in current ScopeTable\n",name.c_str()); 	 
                    return false;
                }
                id++;
                temp = temp->next;
            }
            if(name == temp->Name && type == temp->type)
            {
                dupl = true;
                //cout<<"< "<<name<<", "<<type<<" > already exists in current ScopeTable\n";
                //fprintf(f,"%s already exists in current ScopeTable\n",name.c_str());
                return false;
            }
            if(!dupl)
            {

                //cout<<"Inserted "<<name<<" in ScopeTable# "<<title;
                //cout<<" at position "<<h<<", "<<id+1<<endl;
                temp->next = si;
                return true;

            }
            delete temp;

        }
        delete si;
        return false;
    }

    SymbolInfo* Look_up(string str)
    {

        int h = hash_func(str);
        int id =0;
        SymbolInfo* start = arr[h];
        while (start != NULL)
        {
            if(str == start->Name){
                cout<<"Found in ScopeTable# "<<title;
                cout<<" at position "<<h<<", "<<id<<endl;
                start->symbol=title;
                return start;
            }
            id++;
            if(start)
                start = start->next;
        }
        if(start && str == start->Name)
        {
            cout<<"Found in ScopeTable# "<<title;
            cout<<" at position "<<h<<", "<<id<<endl;
            start->symbol=title;
            return start;
        }

        return NULL;


    }
    bool Delete(string str)
    {

        int h= hash_func(str);

        SymbolInfo *t = arr[h];
        SymbolInfo *p = arr[h];
        if(t == NULL)
        {
            return false;
        }

        if( str == t->Name && t->next == NULL)
        {
            //cout <<"gfhj++";
            arr[h] = NULL;
            cout<<"Found in ScopeTable# "<<title<<"  at position "<<h<<", "<<0<<endl;
            cout<<"Deleted Entry "<<h<<", "<<"0"<<" from current ScopeTable \n";
            //t = NULL;
            delete t;

            return true;
        }
        if( str == t->Name && t->next != NULL)
        {


            arr[h] = t->next;
            t->next = NULL;
            delete t;
            cout<<"Found in ScopeTable# "<<title<<"  at position "<<h<<", "<<0<<endl;
            cout<<"Deleted Entry "<<h<<", "<<"0"<<" from current ScopeTable \n";
            return true;
        }
            int id =0;
            while(t->Name != str && t->next != NULL)
            {
                p = t;
                t = t->next;
                id++;
            }

            if(p && t && t->Name == str && t->next != NULL)
            {
                p->next = t->next;
                t->next =  NULL;
                cout<<"Found in ScopeTable# "<<title<<"  at position "<<h<<", "<<id<<endl;
                cout<<"Deleted Entry "<<h<<", "<<id<<" from current ScopeTable \n";
                delete t;
                return true;
            }
            else if(p && t) //ok
            {
                p->next = NULL;
                t->next = NULL;
                delete t;
                return true;
            }
        return false;

    }
    void Print(FILE* f)
    {
    	fprintf(f,"\nScopeTable # %s\n",title.c_str() );
        //cout<<"Scope__Table# "<<title<<"\n";
        for(int i=0; i<bucket_size; i++)
        {
        SymbolInfo* start = arr[i];
        if(!start  ) continue;

	    fprintf(f," %d --> ",i );
	    //cout<<i<<": --> ";

            
            while (start != NULL)
            {
                //cout<<"< "<<start->Name<<" : "<<start->type<<" > ";
                fprintf(f,"< %s , %s > ",start->Name.c_str(),start->type.c_str());
                if(start)
                    start = start->next;
            }
            //cout<<endl;
            fprintf(f,"\n");
        }
    }
};
class SymbolTable
{
    int n;
   // ScopeTable* global_scope;

    int t=0;
    string name;

public:
    ScopeTable* cur;
    SymbolTable(int bck_n,int index)
    {

        n = bck_n;
        //global_scope = new ScopeTable(n,1);
        cur = new ScopeTable(n,1);
        name ="";
    }
    ~SymbolTable()
    {
/*        ScopeTable *temp = cur;

        while(temp)
        {

            ScopeTable *cur2 = temp;

            temp = temp->parentScope;
            cout<<"------------------\n";

            delete cur2;

            cout<<"**";

        }
        //delete global_scope;
        //delete temp;

        //delete cur;
        cout<<"++ ";
        */
    }
    void Enter_Scope()
    {
        ScopeTable *new_St;
        new_St = new ScopeTable(n,1); /*Need to take care of this part...*/

        int i_p =  cur->child;
        new_St->parentScope = cur; /* jhamela ase eikhane....*/
        cur = new_St;
        cur->setIndex(i_p);

        cout<<"New ScopeTable with id  "<<cur->getTitle()<<" created\n";
        new_St = nullptr;
        delete new_St;
    }
    void Exit_scope()
    {
        int idd = cur->child;

        cout<<"ScopeTable with id "<<cur->getTitle()<<" removed\n";


        cur = cur->parentScope;
        cur->child=cur->child+1;

    }
    bool Insert(string str,string desc)
    {


        if(cur->Insert(str,desc))
        	return true;
        else
            	return false;
        
    }
    bool Insert(string str,string desc,string var)
    {


        if(cur->Insert(str,desc,var))
        	return true;
        else
            	return false;
        
    }
    bool Insert(string str,string desc,string var,string id_type)
    {


        if(cur->Insert(str,desc,var,id_type))
        	return true;
        else
            	return false;
        
    }
    bool Insert(string str,string desc,string var,string id_type,vector<string> s)
    {


        if(cur->Insert(str,desc,var,id_type,s))
        	return true;
        else
            	return false;
        
    }
    bool Remove(string del)
    {
        if(cur->Delete(del))
            return true;
        else
            return false;
    }
    SymbolInfo* Look_up(string str)
    {

        SymbolInfo * ret = NULL;
        ScopeTable *temp = cur;
        if(temp == NULL )
            return NULL;
        while(temp->parentScope !=NULL)
        {
            ret =  temp->Look_up(str);
            if(ret != NULL)
                return ret;
            temp = temp->parentScope;
        }
        if(temp)
            ret =  temp->Look_up(str);
        return ret;

        delete temp;

    }
    void Print_cur(FILE* f)
    {
        cur->Print(f);
    }
    void Print_All_Scope(FILE* f)
    {
        ScopeTable *temp = cur;
        while(temp !=NULL)
        {
            temp->Print(f);
            temp = temp->parentScope;
        }
        if(temp)
            temp->Print(f);

        delete temp;
    }
};


