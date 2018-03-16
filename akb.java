package toollist;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.PrintWriter;
import java.io.IOException;

//This is the program for building database of AKB Sousenkyo Voting Site ButtonList.


public class akb {
    public static void main(String[] args) {
        try{
        String list = "{\"Total\":[\"true\",\"http://akb48-sousenkyo.jp/web/akb2016/vote/\",\"document.getElementById('form_serialnum1').value=\",\"document.getElementById('form_serialnum2').value=\",\"document.getElementById('form_serialnum1').parentNode.parentNode.submit()\"],\"Team4\": [{ \"Name\":\"高橋 朱里\" , \"Url\":\"show?c=10413\" },{ \"Name\":\"飯野 雅\" , \"Url\":\"show?c=10401\" },{ \"Name\":\"伊豆田 莉奈\" , \"Url\":\"show?c=10402\" },{ \"Name\":\"岩立 沙穂\" , \"Url\":\"show?c=10403\" },{ \"Name\":\"大川 莉央\" , \"Url\":\"show?c=10404\" },{ \"Name\":\"大森 美優\" , \"Url\":\"show?c=10405\" },{ \"Name\":\"岡田 彩花\" , \"Url\":\"show?c=10406\" },{ \"Name\":\"岡田 奈々\" , \"Url\":\"show?c=10407\" },{ \"Name\":\"川本 紗矢\" , \"Url\":\"show?c=10408\" },{ \"Name\":\"北澤 早紀\" , \"Url\":\"show?c=10409\" },{ \"Name\":\"小嶋 真子\" , \"Url\":\"show?c=10410\" },{ \"Name\":\"込山 榛香\" , \"Url\":\"show?c=10411\" },{ \"Name\":\"佐藤 妃星\" , \"Url\":\"show?c=10412\" },{ \"Name\":\"土保 瑞希\" , \"Url\":\"show?c=10414\" },{ \"Name\":\"名取 稚菜\" , \"Url\":\"show?c=10415\" },{ \"Name\":\"西野 未姫\" , \"Url\":\"show?c=10416\" },{ \"Name\":\"野澤 玲奈\" , \"Url\":\"show?c=10417\" }]";

        File filein = new File("input.txt");
        Scanner scan = new Scanner(filein);
        scan.useDelimiter("\n");
        int i = scan.nextInt();
        while (i == 0) {
        	int num = scan.nextInt();
        	String team = scan.next();
        	int teamnum = scan.nextInt();
        	list = list + ",\"" + team + "\": [";
        	String name = scan.next();
        	int teamnums = teamnum + 1;
        	list = list + "{ \"Name\":\"" + name + "\" , \"Url\":\"show?c=" + Integer.toString(teamnums) + "\" }";
        	for (int j = 2; j<num+1; j++){
        		name = scan.next();
        		teamnums = teamnum + j;
        		list = list + ",{ \"Name\":\"" + name + "\" , \"Url\":\"show?c=" + Integer.toString(teamnums) + "\" }";
        	}
        	list = list + "]";
        	i = scan.nextInt();
        }
        list = list + "}";
        
        File file = new File("DataJson");
        try {
			PrintWriter pw = new PrintWriter(new BufferedWriter(new FileWriter(file)));
	        pw.println(list);
	        pw.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        scan.close();

    
    }catch(FileNotFoundException e){
        System.out.println(e);
      }
    }
}